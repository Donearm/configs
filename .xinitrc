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

# Terminate X with Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp &

# not needed anymore for 180.* and higher drivers
#nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1
nvidia-settings -a PixmapCacheRoundSizeKB=4096

# Start ttytter inside screen, but only if it's not already running
/mnt/documents/Script/ttytter_screen_startup.sh
#screen -dm -c ~/.screenrc-ttytter &


exec awesome
#exec openbox-session
# exec /opt/kde/bin/startkde
# exec gnome-session
#exec /mnt/documents/Script/awesome_autostart.sh
#exec /mnt/documents/Script/dwm_start.sh
#exec /mnt/documents/Script/xmonad_start.sh
