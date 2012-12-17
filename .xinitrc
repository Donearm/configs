#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

# Terminate X with Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp &

# Start ttytter inside screen/tmux, but only if it's not already running
#/mnt/documents/Script/ttytter_startup.sh

# exporting LANG before launching awesome. It's needed when on runlevel
# 5 and not using a display manager
#LANG=it_IT.utf8 exec nohup &> /dev/null dbus-launch ck-launch-session awesome
exec awesome
#exec openbox-session
# exec /opt/kde/bin/startkde
#exec ck-launch-session gnome-session
# exec ck-launch-session /mnt/documents/Script/compiz_start.sh
#exec /mnt/documents/Script/dwm_start.sh
#exec /home/gianluca/monsterwm_start.sh
#exec /mnt/documents/Script/old_scripts/xmonad_start.sh
