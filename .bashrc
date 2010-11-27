alias vi="vim"
alias ll="ls -asl -F -T 0 -b -H -1 --color=always"
alias less="less -r"
alias cp="cp -p"
alias df="df -T"
alias du="du -h -c"
alias bash="/bin/bash --login"
alias konsole="konsole --ls"
alias slrn="slrn --kill-log $HOME/.slrn/kill_log.log"
alias startx="startx -- -nolisten tcp -deferglyphs 16 2> ~/.xsession-errors"
alias fetf="fetchmail -F pop.mail.yahoo.it popmail.email.it pop3.live.com"
alias fetco="fetchmail -c"
alias gmail="mutt -f imaps://forod.g@imap.gmail.com:993"
alias gmail2="mutt -f imaps://fioregianluca@imap.gmail.com:993"
alias bajkal="mutt -f imap://in.virgilio.it"
alias email_it="mutt -f imap://imapmail.email.it/INBOX"
alias alsamixer="alsamixer -V all"
alias svim="sudo vim"
alias voracious="voracious --age-limit 2800 -b kortirion --nobozo"
alias vcs="vcs -j -c 4 -u nirari -H 200 -O bg_heading=lavender \
-O bg_sign=lavender -O bg_contact=lavender \
-O font_heading=DejaVu-Sans-Condensed-Bold"
# Skype using gtk instead of qt
alias skype="skype --disable-cleanlooks -style GTK"
# Mplayer using 2 threads/cpu by default 
# disabled because it make playing dvds impossible
#alias mplayer="mplayer -lavdopts fast:threads=2"
# Feh alias for loading all the images in the directory
#alias fehall="feh --scale-down -S filename ."
alias orphans="pacman -Qtdq"
# Rsync alias to sync between laptop and desktop over ssh
alias ssrsync="rsync -avz --progress --inplace --rsh='ssh -p8898'"
# Two openssl aliases to encode/decode files
alias ssl_enc="openssl aes-256-cbc -salt"
alias ssl_dec="openssl aes-256-cbc -d"


# Set the keycodes for the extra keys that aren't usually recognized by
# the kernel
#setkeycodes e002 131 &	# n°1
#setkeycodes e003 132 &	# n°2
#setkeycodes e004 133 &	# n°3
#setkeycodes e005 134 &	# n°4
#setkeycodes e006 135 &	# n°5
#setkeycodes e026 136 &	# ?
#setkeycodes e059 137 &	# the search icon
#setkeycodes e00a 138 &	# the book icon
#setkeycodes e009 139 &	# the exit icon
#setkeycodes e018 140 &	# the eject icon

# top 10 most used commands
topten() {
	history | awk '{print $4}' | awk 'BEGIN {FS ="|"} {print $1}' \
		| sort | uniq -c | sort -rn | head -10
}
# mkmv - creates a new directory and moves the file into it, in 1 step
# Usage: mkmv <file> <directory>
mkmv() {
    mkdir "$2"
    mv "$1" "$2"
}

startX() {
	nohup &> /dev/null startx -- -nolisten tcp -deferglyphs 16 2> ~/.xsession-errors
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

# Pngtojpeg - converts each png file in the current directory in a jpeg
pngtojpeg() {
	for p in *.[pP][nN][gG] ; do
		convert "$p" "${p%.*}.jpg" ;
	done
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


#export PATH=/usr/X11R6/bin:/usr/sbin:/sbin/:/usr/local/sbin/:/usr/local/bin:/opt/kde/bin:/usr/lib/python2.5/:/opt/gnome/bin:/lib/splash/bin:/opt/xfce4/bin/:/opt/texlive/bin:$PATH
export PATH=/usr/local/bin:$PATH

# Bash Prompts
if [ "$TERM" = "linux" ]
then
    #export PS1='\[\e[1;34;40m\][\[\e[31;40m\]\u\[\e[34;40m\]@\[\e[31;40m\]\H\[\e[34;40m\] \W]\[\e[36;40m\]$ \[\e[0m\]' # scritte rosse, sfondo nero, directories blu
    export PS1="${bBlue}\[[${bRed}\u${bnc}@${bRed}\H ${bBlue}\W${bBlue}]\]$ ${bnc}"
elif [[ "$TERM" = "screen" || "$TERM" = "screen-256color" ]]
then
    if [[ `whoami` == "root" ]]; then
		export PS1=".:\$(date +%d/%m/%Y):. :${WINDOW}: \w \n ${bred} >: ${bnc}"
    else
		export PS1=".:\$(date +%d/%m/%Y):. :${WINDOW}: \w \n >: "
    fi
elif [[ "$TERM" = "rxvt-unicode" || "$TERM" = "rxvt" ]]
then
    #export PS1='\u@\w \n >: '
    if [[ `whoami` == "root" ]]; then
		export PS1=".:\$(date +%d/%m/%Y):. \w \n ${bred} >: ${bnc}"
    else
		export PS1=".:\$(date +%d/%m/%Y):. \w \n >: "
    fi
    #export TITLEBAR='\[\e]0;\u | term | \w\007\]'
# Let's try
    export TITLEBAR='\[\e]0;\u  $BASH_COMMAND\007'
    export COLORTERM='rxvt-unicode'
else
    export PS1='[\u@\H \W ]\$ '
fi

# cgroup stuff
#if [ "$PS1" ] ; then
#	mkdir -m 0700 -p /cgroup/cpu/$$
#	echo 1 > /cgroup/cpu/$$/notify_on_release
#	echo $$ > /cgroup/cpu/$$/tasks
#fi

export BROWSER="/usr/bin/firefox"
export EDITOR="vim"
export MAIL="$HOME/Maildir/"
export SERVER='news.tin.it'
export SLANG_EDITOR='vim'
export NNTPSERVER='news.tin.it'
export MAILCHECK=600000000000 # I don't really need a shell mailcheck....
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

# set the desktop integration for OO (may be kde or gnome)
export OOO_FORCE_DESKTOP=gnome
# to improve firefox responsiveness
export MOZ_DISABLE_PANGO=1

# Check terminal size
shopt -s checkwinsize

clear # clear the screen if something is on it
