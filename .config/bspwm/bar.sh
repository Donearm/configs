#!/bin/bash

#lemonbar feed
battery() {
    batpercent=`acpi -b | awk '{print $4}' | sed 's/[%,]//g'`
    chgstate=`acpi -b | awk '{print $3}' | sed 's/,//g'`
    if [ $chgstate == "Charging" ]
      then
        batstatus="+"
	else
		batstatus="-"
    fi
echo "%{T2}$batstatus%{T1}$batpercent%"
}

clock() {
    curtime=`date '+%k:%M'` 
    curdate=`date '+%d %b %Y'`
    echo "%{T1}$curtime %{T1}$curdate"
}

volume() {
    curvol=`amixer get Master | grep "Mono: Playback" | awk '{print $4}' | sed 's/\[//g;s/\]//g;s/%//g'`
    ismute=`amixer get Master | grep "Mono: Playback" | awk '{print $6}' | sed 's/\[//g;s/\]//g;s/%//g'`

	if [ "$ismute" = "off" ]
	then
		curvol="muted"
	else
		curvol="${curvol}%"
	fi
    echo "%{T2} %{A4:"amixer -q sset Master 3%+":}%{A5:"amixer -q sset Master 3%-":}%{A3:"amixer -q sset Master toggle":}$volicon %{T1}$curvol %{A}%{A}%{A}"
}


netstatus() {
    curwifistat=`cat /sys/class/net/wlp7s0/operstate`
	curwifisent=`cat /sys/class/net/wlp7s0/statistics/tx_bytes`
	curwifireceived=`cat /sys/class/net/wlp7s0/statistics/rx_bytes`
    if [ "$curwifistat" = "down" ]	
      then
		  echo "No connection"
      else
		  echo "%{T1}Sent/Received: $((${curwifisent}/1024000))Mb/$((${curwifireceived}/1024000))Mb"
    fi
}

load_avg() {
	avgload=$(cut -d " " -f 1-3 /proc/loadavg)
	echo "load $avgload"
}

#mpd() {
#    nowplaying=`mpc | head -n 1`
#    if [[ "$nowplaying" != volume* ]]
#      then
#        echo "%{A1:"mpc toggle":}%{A2:"mpc stop":}%{A3:"mpc random":}%{A4:"mpc next":}%{A5:"mpc prev":}%{T2} %{T1}$nowplaying%{A}%{A}%{A}%{A}%{A}  "
#    fi
#}
# This loop will fill a buffer with our infos, and output it to stdout.

while :; do

    echo "%{B#DDecf0f1}%{F#2c2c2c}%{T2}%{l} %{T1} %{r}%{F#2C2C2C} $(load_avg) $(netstatus) $(volume)  $(battery)  $(clock)  "
    sleep 1

done
