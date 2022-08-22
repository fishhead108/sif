#!/bin/sh --login

. <(udevadm info -q property -p /sys/class/power_supply/BAT0 | grep -E 'POWER_SUPPLY_(CAPACITY|STATUS)=')

if [[ $POWER_SUPPLY_STATUS = Discharging && $POWER_SUPPLY_CAPACITY -lt 10 ]];
  then notify-send -u critical "Battery is low: $POWER_SUPPLY_CAPACITY";
fi