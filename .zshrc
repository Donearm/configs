HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=3000
setopt HIST_IGNORE_DUPS
unsetopt beep
bindkey -v

zstyle :compinstall filename '/home/gianluca/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit

typeset -U path
path=(/usr/local/bin /opt/android-sdk/platform-tools/ /usr/lib/go/site/bin/ ~/.go/bin/ $path)
