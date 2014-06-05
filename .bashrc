alias vi="vim"
alias ll="ls -asl -F -T 0 -b -H -1 --color=always"
alias l="ls -CF"
alias less="less -r"
alias cp="cp -p"
alias df="df -T"
alias du="du -h -c"
alias bash="/bin/bash --login"
alias slrn="slrn --kill-log $HOME/.slrn/kill_log.log"
alias startx="startx -- -nolisten tcp -deferglyphs 16 2> ~/.xsession-errors"
alias fetf="fetchmail -F pop.mail.yahoo.it pop3.live.com"
alias fetco="fetchmail -c"
alias gmail="mutt -f imaps://forod.g@imap.gmail.com:993"
alias gmail2="mutt -f imaps://fioregianluca@imap.gmail.com:993"
alias bajkal="mutt -f imap://in.virgilio.it"
alias pop3yahoo="mutt -f pop://gianluca1181@pop.mail.yahoo.it"
alias pop3msn="mutt -f pops://kinetic8@live.com@pop3.live.com:995"
alias alsamixer="alsamixer -V all"
alias dpmsoff="xset -dpms && xset s off"
alias dpmson="xset +dpms && xset s on"
alias dvdburn="growisofs -Z /dev/cdrom -J -R"
alias httpsharedir="python -m http.server 8001"
# Skype using gtk instead of qt
alias skype="skype --disable-cleanlooks -style GTK"
# Mplayer using 2 threads/cpu by default
# disabled because it make playing dvds impossible
#alias mplayer="mplayer -lavdopts fast:threads=2"
alias orphans="pacman -Qtdq" # packages not required by any other
alias expliciti="pacman -Qetq" # explicitly installed packages not required by any other
# Rsync alias to sync between laptop and desktop over ssh
alias ssrsync="rsync -avz --progress --inplace --delete-after --rsh='ssh -p8898'"
# Two openssl aliases to encode/decode files
alias ssl_enc="openssl aes-256-cbc -salt"
alias ssl_dec="openssl aes-256-cbc -d"
# Ettercap ARP spoofing ;)
alias etterspoof="sudo ettercap -T -M arp:remote -P autoadd /192.168.1.3/ /192.168.1.1/"


# top 15 most used commands
topfifteen() {
	history | awk '{if ($4 == "sudo") {print $5} else {print $4}}' | \
		awk 'BEGIN {FS ="|"} {print $1}' \
		| grep -v topfifteen | sort | uniq -c | sort -rn | head -15
}

startX() {
	if [ -z "$XDG_VTNR" ]; then
		nohup &> /dev/null startx -- -nolisten tcp -deferglyphs 16 2> ~/.xsession-errors
	else
		nohup &> /dev/null startx -- -nolisten tcp -deferglyphs 16 vt$XDG_VTNR 2> ~/.xsession-errors
	fi
	disown
	logout
}

# Fahstat - get info about current folding@home unit
fahstat() {
	#echo
	cat /opt/fah-smp/gianluca/unitinfo.txt
	echo
	tail -n 1 /opt/fah-smp/gianluca/FAHlog.txt
	echo
}

# Pngtojpeg - converts each png in the current directory in jpeg
pngtojpeg() {
	for p in *.[pP][nN][gG] ; do
		convert "$p" "${p%.*}.jpg" ;
	done
}

vboxbuild() {
	sudo dkms install vboxhost/$1 -k $(uname -r)/$(uname -m)
}

gitgrep() {
	git rev-list --all | ( while read revision; do
		git grep -F $1 $revision;
	done
	)
}

# Quickly mount/umount the Nexus 5
nexus_on() {
	mkdir -p nexus
	jmtpfs -o allow_other nexus
	if [ $? -eq 0 ]; then
		echo "Nexus5 successfully mounted"
	else
		echo "Something went wrong, the Nexus couldn't be mounted"
	fi
}

nexus_off() {
	fusermount -u nexus
	if [ $? -eq 0 ]; then
		if [ -d nexus ]; then
			rm -rf nexus/
		fi
	else
		echo "Couldn't unmount the Nexus"
	fi
}

# Easily mark and jump in the filesystem
# From
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function mjump() {
	cd -P "$MARKPATH/$1" 2>/dev/null || echo "No suck mark: $1"
}
function mmark() {
	mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function munmark() {
	rm -i "$MARKPATH/$1"
}
function mmarks() {
	\ls -l "$MARKPATH" | grep -v '^total' | awk '{printf "%-15s -> %s\n", $9,$11}' && echo
}

# No one should read/write/execute my files by default
#umask 0077

# Bash Colors
bblack="\033[0;30m" # black
bred="\033[0;31m" # red
bRed="\033[1;31m" # bold red
bgreen="\033[0;32m" # green
bGreen="\033[1;32m" # bold green
byellow="\033[0;33m" # yellow
bYellow="\033[1;33m" # bold yellow
bblue="\033[0;34m" # blue
bBlue="\033[1;34m" # bold blue
bmagenta="\033[0;35m" # magenta
bMagenta="\033[1;35m" # bold magenta
bcyan="\033[0;36m" # cyan
bCyan="\033[1;36m" # bold cyan
bwhite="\033[0;37m" # white
bnc="\033[0;0m" # no color
undblack="\033[4;30m" # black underlined
undred="\033[4;31m" # red underlined
undgreen="\033[4;32m" # green underlined
undyellow="\033[4;33m" # yellow underlined
undblue="\033[4;34m" # blue underlined
undpurple="\033[4;35m" # purple underlined
undcyan="\033[4;36m" # cyan underlined
undwhite="\033[4;37m" # white underlined
# background colors
bgblack="\033[40m"
bgred="\033[41m"
bggreen="\033[42m"
bgyellow="\033[43m"
bgblue="\033[44m"
bgmagenta="\033[45m"
bgcyan="\033[46m"
bgwhite="\033[47m"
txtreset="\033[0m" # text reset


export PATH=/usr/local/bin:/opt/android-sdk/platform-tools/:/usr/lib/go/site/bin/:$HOME/.go/bin/:$PATH

# Variables for the git prompt
GIT_PS1_SHOWDIRTYSTATE="1"
GIT_PS1_SHOWUNTRACKEDFILES="1"

# Bash Prompts
if [ "$TERM" = "linux" ]
then
    PS1="${bRed}\[[${bnc}\u@\H ${bRed}\W${bRed}]\]$ ${bnc}"
elif [[ "$TERM" = "screen" || "$TERM" = "screen-256color" ]]
then
    if [[ `whoami` == "root" ]]; then
		PS1="${bRed}«${bnc} \$(date +%d/%m/%Y) ${bRed}»${bnc} \w \n${bred} >: ${bnc}"
    else
		PS1="${bRed}«${bnc} \$(date +%d/%m/%Y) ${bRed}»${bnc} \w \n >: "
    fi
elif [[ "$TERM" = "rxvt-unicode" || "$TERM" = "rxvt" || "$TERM" = "rxvt-256color" || "$TERM" = "rxvt-unicode-256color" ]]
then
	# 256 colors available?
	if [[ "$TERM" != "rxvt-256color" ]]; then
		if [ -e /usr/share/terminfo/r/rxvt-256color ]; then
			export TERM='rxvt-256color'
		else
			continue
		fi
	fi
    if [[ `whoami` == "root" ]]; then
		PS1="${bRed}«${bnc} \$(date +%d/%m/%Y) ${bRed}»${bnc} \w \n${bred} >: ${bnc}"
    else
		PS1="${bRed}«${bnc} \$(date +%d/%m/%Y) \$(__git_ps1 [%s]) ${bRed}»${bnc} \w \n >: "
    fi
    #export TITLEBAR='\[\e]0;\u | term | \w\007\]'
# Let's try
    export TITLEBAR='\[\e]0;\u  $BASH_COMMAND\007'
    export COLORTERM='rxvt-unicode'
else
    if [[ `whoami` == "root" ]]; then
		PS1="${bRed}«${bnc} \$(date +%d/%m/%Y)${bRed} »${bnc} \w \n${bred} >: ${bnc}"
    else
		PS1="${bRed}«${bnc} \$(date +%d/%m/%Y)${bRed} »${bnc} \w \n >: "
    fi
fi


export BROWSER="firefox"
export EDITOR="vim"
export MAIL="$HOME/Maildir/"
export SERVER='news.tin.it'
export SLANG_EDITOR='vim'
export NNTPSERVER='news.tin.it'
export MAILCHECK=600000000000 # I don't really need a shell mailcheck....
export PYTHONSTARTUP="$HOME/.pythonrc.py"
export GOPATH=$HOME/.go/:$GOPATH
export LANG=it_IT.utf8
export LANGUAGE=it_IT.utf8
export LC_TYPE=it_IT.utf8
export LC_CTYPE=it_IT.utf8
export LC_COLLATE=it_IT.utf8
export LC_ALL=it_IT.utf8
export LC_MESSAGES=it_IT.utf8
export LC_NUMERIC=it_IT.utf8
# use less with utf8
export LESSCHARSET="utf-8"
export DATE=`date +%G_%m_%d`
# set the size of the bash history
export HISTSIZE=5000
# add date and time to history elements
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoreboth # no doubles in bash_history
# Colorized grep output
export GREP_OPTIONS="--color"

# set ls colors
# di=directories, fi=files, ln=symbolic links, pi=fifo, so=sockets,
# bd=block files, cd=character files, or=symbolic orphaned links,
# mi=non-existent files that have a symbolic link to them,
# ex=executables
#
# Color numbers:
# 0 (default)
# 1 (bold)
# 4 (underlined)
# 5 (flashing)
# 7 (reverse field)
# 31 (red)
# 32 (green)
# 33 (orange)
# 34 (blue)
# 35 (purple)
# 36 (cyan)
# 37 (grey)
# 40 (black background)
# 41 (red background)
# 42 (green background)
# 43 (orange background)
# 44 (blue background)
# 45 (purple background)
# 46 (cyan background)
# 47 (grey background)
# 90 (dark grey)
# 91 (light red)
# 92 (light green)
# 93 (yellow)
# 94 (light blue)
# 95 (light purple)
# 96 (turquoise)
# 100 (dark grey background)
# 101 (light red background)
# 102 (light green background)
# 103 (yellow background)
# 104 (light blue background)
# 105 (light purple background)
# 106 (turquoise background
#export LS_COLORS="di=1:fi=0:ln=95:pi=93:so=36:bd=96:cd=96:or=95,101:mi=95,101:ex=94"
eval $(dircolors -b ~/.dir_colors/dircolors.ansi-universal)

# set the desktop integration for OO (may be kde or gnome)
export OOO_FORCE_DESKTOP=gnome
# to improve firefox responsiveness
export MOZ_DISABLE_PANGO=1
# Make Qt use Gtk2 themes
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# Two variables to use vdpau backend via Gallium3d on open source Amd
# drivers
export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=r600

# Check terminal size
shopt -s checkwinsize
# autocorrect cd typos
shopt -s cdspell

# auto completion
source /usr/share/bash-completion/completions/git
source /usr/share/bash-completion/completions/tmux
source /usr/share/bash-completion/completions/task
# udisks functions
source /mnt/d/Script/utilities/udisks_functions
# git prompt
source /usr/share/git/git-prompt.sh
# To.sh shell bookmarking
source /mnt/d/Script/utilities/to.sh

# Launch ssh-agent, but only if it's not been launched already!
if [[ -z `pgrep ssh-agent` ]]; then
	eval $(ssh-agent)
fi

clear # clear the screen if something is on it
