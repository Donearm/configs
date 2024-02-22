# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
export BROWSER="firefox"
export EDITOR="vim"
export MAIL="$HOME/Maildir/"
# Use less with utf8
export LESSCHARSET="utf-8"
export DATE=`date +%G_%m_%d`
export XAUTHORITY="$HOME/.Xauthority"
eval $(dircolors -b ~/.dir_colors/dircolors.custom)

# completion for kitty terminal
#kitty + complete setup zsh | source /dev/stdin

# icons-in-terminal https://github.com/sebastiencs/icons-in-terminal
source /usr/share/icons-in-terminal/icons_bash.sh

# Enable powerlevel10k prompt
if [ "$TERM" = "linux" ]
then
	autoload -Uz promptinit
	promptinit
	prompt walters
else
	source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

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
alias timestamp="echo `date "+%Y-%m-%d %R"`"
# Show user declared functions
alias show_funcs="declare -F | grep -v _"
# Correctly connect over ssh (kitty terminal fix)
alias kittyssh="kitty +kitten ssh"
alias waterfox="env MOZ_ENABLE_WAYLAND=1 waterfox-g3"
# Set default scanner and options for scanimage
alias scanimage="scanimage --device 'airscan:e0:Canon MG3600 series' --progress"
alias figma="env LD_PRELOAD=/usr/lib/libm.so.6 figma-linux"
# Helper to cast desktop on Panasonic Smart Tv
alias casttotv='xrandr --output HDMI-A-0 --mode 3840x2160 --post "0x0" --scale 0.5x0.5'

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
        go-mtpfs phone
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

# Quickly mount/umount a GoPro camera
gopro() {
    if [[ $1 == 'mount' ]]; then
        mkdir -p gopro
        go-mtpfs -allow-other -dev GoPro gopro
        if [ $? -eq 0 ]; then
            echo "Your GoPro has been successfully mounted"
        else
            echo "Something went wrong, the GoPro couldn't be mounted"
        fi
    elif [[ $1 == 'umount' ]]; then
        fusermount -u gopro
        if [ $? -eq 0 ]; then
            if [ -d gopro ]; then
                rm -rf gopro/
            fi
        else
            echo "Couldn't unmount the GoPro"
        fi
    else
        echo "Use gopro (mount|umount) to mount or unmount your GoPro"
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

du1 () {
	du -h --max-depth=1 "$@" | sort -k 1,1h -k 2,2f
}

screenshot () {
	ffmpeg -f x11grab -video_size 1920x1080 -i $DISPLAY -vframes 1 screen.png
}

# two quick functions to connect and disconnect the Momentum3 headphones via 
# bluetoothctl
momentum3_connect () {
	echo -e "power on\nconnect 00:1B:66:C0:52:9F\nquit\n" | bluetoothctl
}

momentum3_disconnect () {
	echo -e "disconnect 00:1B:66:C0:52:9F\nquit\n" | bluetoothctl
}
# function to unpair and attempt to pair again with the Momentu3 
# headphones via bluetoothctl
momentum3_repair () {
	echo -e "power on\nscan on\nuntrust 00:1B:66:C0:52:9F\nremove 00:1B:66:C0:52:9F\npair 00:1B:66:C0:52:9F\nquit\n" | bluetoothctl
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

	# this will create a fifo where all nnn selections will be written 
	# to
	NNN_FIFO="$(mktemp --suffix=-nnn -u)"
	export NNN_FIFO
	(umask 077; mkfifo "$NNN_FIFO")

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn -a -c "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi

	rm -r "$NNN_FIFO"
}
# Plugins for nnn
export NNN_PLUG='p:preview-tui;m:preview-tui-ext;f:-_feh -d *'
# Fifo for nnn
#export NNN_FIFO=/tmp/nnn.fifo
# Bookmarks for nnn
export NNN_BMS="h:${HOME};p:/mnt/private/"
# Colors for nnn
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
# Archives to handle in nnn
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"

function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Main ledger file for (h)ledger
export LEDGER_FILE="${HOME}/.ledger/all.journal"

# Hardware acceleration
export MOZ_X11_EGL=1 # For Firefox
export MOZ_WEBRENDER=1 # For Firefox
export LIBVA_DRIVER_NAME=radeonsi
export VDPAU_DRIVER=radeonsi

# Check if gnome-keyring is running already and export the SSH_AUTH_SOCK
# variable
#if [ -z "$SSH_AUTH_SOCK" ];then
#    eval $(gnome-keyring-daemon --start)
#fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
