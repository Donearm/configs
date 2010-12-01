#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

#source /etc/X11/Xsession 2> /tmp/startx.log
#hddtemp -d /dev/sda /dev/sdb

# not needed since Xorg 7.4
#xmodmap .Xmodmap

# D-bus
#if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
#       eval `dbus-launch --sh-syntax --exit-with-session`
#fi

# Terminate X with Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp &

# nvidia pixmap cache. 1024 default
nvidia-settings -a PixmapCacheRoundSizeKB=16000

# Start ttytter inside screen, but only if it's not already running
/mnt/documents/Script/ttytter_screen_startup.sh
#screen -dm -c ~/.screenrc-ttytter &

# exporting LANG before launching awesome. It's needed when on runlevel
# 5 and not using a display manager
LANG=it_IT.utf8 exec dbus-launch ck-launch-session awesome
#exec openbox-session
# exec /opt/kde/bin/startkde
# exec gnome-session
#exec /mnt/documents/Script/awesome_autostart.sh
#exec /mnt/documents/Script/dwm_start.sh
#exec /mnt/documents/Script/xmonad_start.sh
