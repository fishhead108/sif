#!/bin/bash
action=$(echo -e "lock\nlogout\nshutdown\nreboot" | rofi -dmenu -p "power:")

if [[ "$action" == "lock" ]]
then
    ~/.i3/i3lock-fancy-multimonitor/lock
fi

if [[ "$action" == "logout" ]]
then
    i3-msg exit
fi

if [[ "$action" == "shutdown" ]]
then
    systemctl poweroff
fi

if [[ "$action" == "reboot" ]]
then
    shutdown -r now
fi
