#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

# Terminate X with Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp &

# nvidia pixmap cache. 1024 default
nvidia-settings -a PixmapCacheRoundSizeKB=2048

# Start ttytter inside screen/tmux, but only if it's not already running
/mnt/documents/Script/ttytter_startup.sh

# DNSCrypt please
sudo dnscrypt-proxy --daemonize

# proper launch of a dbus session
source /etc/X11/xinit/xinitrc.d/30-dbus

# exporting LANG before launching awesome. It's needed when on runlevel
# 5 and not using a display manager
#LANG=it_IT.utf8 exec nohup &> /dev/null dbus-launch ck-launch-session awesome
exec ck-launch-session awesome
#exec openbox-session
# exec /opt/kde/bin/startkde
#exec ck-launch-session gnome-session
# exec ck-launch-session /mnt/documents/Script/compiz_start.sh
#exec /mnt/documents/Script/awesome_autostart.sh
#exec /mnt/documents/Script/dwm_start.sh
#exec /mnt/documents/Script/xmonad_start.sh
