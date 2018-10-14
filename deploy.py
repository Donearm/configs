#!/usr/bin/env python
# -*- coding: utf-8 -*-
###############################################################################
# Copyright (c) 2015, Gianluca Fiore
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
###############################################################################

__author__ = "Gianluca Fiore"
__license__ = "GPL"
__version__ = "0.1"
__date__ = "20150223"
__status__ = "beta"

import sys
import os
from shutil import which
from subprocess import call, STDOUT

HOME        = os.environ['HOME']
DOTFILES    = HOME + '/.config/configfiles/'
REPOURL     = 'https://github.com/Donearm/configs'

def is_file_or_link(source_file):
    """
    Return True if source_file is a file or a link
    """
    return os.path.isfile(source_file) or os.path.islink(source_file)

def mkdir(directory):
    """
    Mkdir function, like mkdir -p in *nix shells
    Create a directory, and parent ones if needed, but only if it doesn't 
    already exist.
    """
    if os.path.isdir(directory):
        pass
    elif os.path.isfile(directory) or os.path.islink(directory):
        raise OSError("a file or symlink with the same name already exists.")
    else:
        head, tail = os.path.split(directory)
        print(head, tail)
        # Check that parent directory exists already
        if head and not os.path.isdir(head):
            # make it then
            mkdir(head)

        if tail:
            os.mkdir(directory)

def collect_links(directory):
    """
    Collect files and directories relative to directory
    """
    files = [os.path.join(DOTFILES, directory, f) for f in
             os.listdir(os.path.join(DOTFILES, directory))]
    for f in files:
        src = os.path.relpath(f, DOTFILES)
        if os.path.isfile(f):
            symlink(f, HOME)
        elif os.path.isdir(f):
            symlink(os.path.join(directory, f), HOME)
            collect_links(os.path.join(directory, f))
        elif os.path.islink(f):
            # Ignore symlinks
            pass
        else:
            raise AssertionError("%s is neither a file nor a folder" % src)

def symlink(src, dst):
    """
    Make a symlink from src to dst
    src is always relative to DOTFILES
    """
    rel_src = os.path.relpath(src, DOTFILES)
    if os.path.islink(dst):
        # We made it already?
        return 1

    final_dst = os.path.join(dst, rel_src)
    if os.path.isdir(src):
        mkdir(dst)

    if os.path.isfile(src):
        # Check that the directory containing the file to link has been 
        # previously made
        if not os.path.isdir(os.path.dirname(final_dst)):
            mkdir(os.path.dirname(final_dst))

        if is_file_or_link(final_dst):
            pass
        else:
            os.symlink(src, final_dst)
    

def check_empty_dir(directory):
    """
    Check whether a directory is empty or not
    True = not empty
    False = empty
    """
    return os.listdir(directory)

def git(repo, action):
    git = which('git')
    if git:
        if action == "clone":
            cmd = ['git', 'clone', repo, DOTFILES]
        elif action == "pull":
            cmd = ['git', 'pull', repo, DOTFILES]
        else:
            # Default to git status
            cmd = ['git', 'status']

        ret = call(cmd, stderr=STDOUT)
        if ret != 0:
            print("Git returned non-zero exit status!")
            return 1
    else:
        print("Git is not available\nExiting...")
        return 1


def main():
    # Make dotfiles directory and check that it's empty
    mkdir(DOTFILES)
    if check_empty_dir(DOTFILES):
        print("Dotfiles directory not empty, did you git clone the repo already?")
        return 1

    # Clone/Pull repository
    git(REPOURL, 'clone')

    # Deploy files to $HOME
    collect_links(DOTFILES)



if __name__ == '__main__':
    status = main()
    sys.exit(status)

