#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

# Terminate X with Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp &

# Load some programs from standard ArchLinux's xorg-xinit package
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Start ttytter inside screen/tmux, but only if it's not already running
#/mnt/documents/Script/ttytter_startup.sh

# exporting LANG before launching awesome. It's needed when on runlevel
# 5 and not using a display manager
#LANG=it_IT.utf8 exec nohup &> /dev/null dbus-launch ck-launch-session awesome
exec awesome
#exec openbox-session
# exec /opt/kde/bin/startkde
#exec gnome-session
# exec ck-launch-session /mnt/documents/Script/compiz_start.sh
#exec /mnt/documents/Script/dwm_start.sh
#exec /home/gianluca/monsterwm_start.sh
#exec /mnt/documents/Script/old_scripts/xmonad_start.sh
