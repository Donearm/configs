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

# Some aliases
alias vi="vim"
alias ll="ls -asl -F -T 0 -b -H -1 --color=always"
alias l="ls - CF"
alias less="less -r"
alias cp="cp -p"
alias df="df -T"
alias du="du -h -c"
alias grep="grep --color"
alias orphans="pacman -Qtdq"
alias expliciti="pacman -Qetq"
