# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt APPEND_HISTORY # append to history file
setopt INC_APPEND_HISTORY # write to history file immediately, not when the shell exits
setopt SHARE_HISTORY # share history between all sessions
setopt HIST_IGNORE_DUPS  # do not record an event that was just recorded again
setopt HIST_FIND_NO_DUPS # do not display a previously found event
setopt HIST_IGNORE_SPACE # do not record an event starting with a space
bindkey -v # vi-mode
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gianluca/.zshrc'

# Custom keybindings
bindkey ^e end-of-line # Ctrl+e goes to the end of line
bindkey	^a beginning-of-line # Ctrl+a goes to the beginning of line

# Search history
typeset -g -A key
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# And search history without using grep
histsearch() { fc -lim "*$@*" 1 }

# enable autocompletion
autoload -Uz compinit
compinit
# End of lines added by compinstall

# general variables
export GPG_TTY=$TTY
export BROWSER="vivaldi-stable"
export EDITOR="vim"
export MAIL="$HOME/Maildir/"
# Use less with utf8
export LESSCHARSET="utf-8"
export DATE=`date +%G_%m_%d`
export XAUTHORITY="$HOME/.Xauthority"
eval $(dircolors -b ~/.dir_colors/dircolors.custom)

# completion for kitty terminal
kitty + complete setup zsh | source /dev/stdin

# Enable prompt theme
autoload -Uz promptinit
promptinit
prompt spaceship

SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  #hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  node          # Node.js section
  #ruby          # Ruby section
  #elixir        # Elixir section
  #xcode         # Xcode section
  #swift         # Swift section
  golang        # Go section
  #php           # PHP section
  #rust          # Rust section
  #haskell       # Haskell Stack section
  #julia         # Julia section
  #docker        # Docker section
  #aws           # Amazon Web Services section
  #gcloud        # Google Cloud Platform section
  #venv          # virtualenv section
  #conda         # conda virtualenv section
  pyenv         # Pyenv section
  #dotnet        # .NET section
  #ember         # Ember.js section
  #kubectl       # Kubectl context section
  #terraform     # Terraform workspace section
  #exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  #vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

SPACESHIP_USER_SHOW=always
SPACESHIP_HOST_SHOW=always
SPACESHIP_HOST_SHOW_FULL=true
SPACESHIP_BATTERY_SHOW=always
SPACESHIP_EXIT_CODE_SHOW=true

SPACESHIP_PACKAGE_SYMBOL=📦
SPACESHIP_NODE_SYMBOL=☊
SPACESHIP_GOLANG_SYMBOL=ꗝ
SPACESHIP_PYENV_SYMBOL=𝧜
SPACESHIP_JOBS_SYMBOL=Ⓙ

# Enable history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Automatically rehash
zstyle ':completion:*' rehash true

## Aliases ##
alias vi="vim"
alias mutt="neomutt"
alias ll="ls -asl -F -T 0 -b -H -1 --color=always"
alias l="ls -CF"
alias less="less -rW"
alias cp="cp -p"
alias df="df -T"
alias du="du -h -c"
alias grep="grep --color"
alias dpmsoff="xset -dpms && xset s off"
alias dpmson="xset +dpms && xset s on"
alias orphans="pacman -Qtdq"
alias expliciti="pacman -Qetq"
alias gmail="mutt -f imaps://forod.g@imap.gmail.com:993"
alias gmail2="mutt -f imaps://fioregianluca@imap.gmail.com:993"
alias gmail3="mutt -f imaps://puffosaltatore@imap.gmail.com:993"
alias bajkal="mutt -f imap://in.virgilio.it"
alias yahoo="mutt -f imaps://gianluca1181@imap.mail.yahoo.com:993"
alias nespressoguide="mutt -f imaps://admin@nespressoguide.com@mail.nespressoguide.com:993"
alias pop3msn="mutt -f pops://kinetic8@live.com@pop3.live.com:995"
# Show user declared functions
alias show_funcs="declare -F | grep -v _"
# Correctly connect over ssh (kitty terminal fix)
alias kittyssh="kitty +kitten ssh"
alias waterfox="env MOZ_ENABLE_WAYLAND=1 waterfox-g3"
# Set default scanner and options for scanimage
alias scanimage="scanimage --device 'airscan:e0:Canon MG3600 series' --progress"
# Launch ESO
alias eso="gtk-launch The_Elder_Scrolls_Online"

## Functions ##
toptwenty () {
	history 1 | awk '{if ($2 == "sudo") {print $3} else {print $2}}' | \
		awk 'BEGIN {FS ="|"} {print $1}' \
		| grep -v toptwenty | sort | uniq -c | sort -rn | head -20
}

# Quickly mount/umount an Android phone
phone() {
    if [[ $1 == 'mount' ]]; then
        mkdir -p phone
        go-mtpfs -o allow_other phone
        if [ $? -eq 0 ]; then
            echo "Your phone has been successfully mounted"
        else
            echo "Something went wrong, the phone couldn't be mounted"
        fi
    elif [[ $1 == 'umount' ]]; then
        fusermount -u phone
        if [ $? -eq 0 ]; then
            if [ -d phone ]; then
                rm -rf phone/
            fi
        else
            echo "Couldn't unmount the phone"
        fi
    else
        echo "Use phone (mount|umount) to mount or unmount your phone"
        return 1
    fi
}

# weather forecast on the cli
forecast_me() {
    curl -S http://wttr.in/$1
}

# output local directories, relative to . , that suck up the most
# diskspace
wheredidallthespacego() {
    sudo du -h $1 | grep -P '^[0-9\.]+[MGT]'
}

# reverse list of the processes using the most memory
wheredidallthememorygo() {
	ps aux  | awk '{print $6/1024 " MB\t\t" $11}'  | sort -n
}

# Play Youtube videos while downloading. Requires youtube-dl and mpv
youplay() {
    yt-dlp --geo-bypass -o - $1 | mpv -
}

gitgrep() {
    git rev-list --all | ( while read revision; do
        git grep -F $1 $revision;
    done
    )
}

# Pngtojpeg - converts each png in the current directory to jpeg
pngtojpeg () {
	for p in *.[pP][nN][gG] ; do
		convert "$p" "${p%.*}.jpg" ;
	done
}

# optimize and resize to a given size an image
# Usage: resizeimage imgpath size pathtosavetheimg
resizeimages() {
    mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 62 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
}

# optimize images by converting them to the max compression of the WebP format
# Usage: webpmaxcompression originalimage webpimage
webpmaxcompression() {
	magick $1 -quality 50 -define webp:lossless=false,thread-level=1,method=6,auto-filter=true,alpha-compression=1,alpha-filtering=2,alpha-quality=1,filter-strength=80 $2
}

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn -c "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
# Plugins for nnn
export NNN_PLUG='p:preview-tui;m:preview-tui-ext;f:-_feh -d *'
# Fifo for nnn
export NNN_FIFO=/tmp/nnn.fifo
# Bookmarks for nnn
export NNN_BMS="h:${HOME};p:/mnt/private/"
# Colors for nnn
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
# Archives to handle in nnn
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"

# Main ledger file for (h)ledger
export LEDGER_FILE="${HOME}/.ledger/all.journal"

# Hardware acceleration
export MOZ_X11_EGL=1 # For Firefox
export MOZ_WEBRENDER=1 # For Firefox
export LIBVA_DRIVER_NAME=radeonsi
export VDPAU_DRIVER=radeonsi

# Check if gnome-keyring is running already and export the SSH_AUTH_SOCK
# variable
if [ -z "$SSH_AUTH_SOCK" ];then
    eval $(gnome-keyring-daemon --start)
fi
