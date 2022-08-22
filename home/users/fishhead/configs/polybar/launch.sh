
# # Terminate already running bar instances
# killall -q polybar

# # Wait until the processes have been shut down
# while pgrep -x polybar >/dev/null; do sleep 1; done
# export ACTIVE_INT="$(ip addr show | awk '/inet.*enp/{print $NF; exit}')"

# # Launch bar1 and bar2
# MONITOR=$(xrandr --listactivemonitors | awk '{ print $4}') polybar top &
# # MONITOR=$(xrandr --listactivemonitors | awk '{ print $4}') polybar bottom &

# # MONITOR=HDMI1 polybar top &
# #MONITOR=HDMI1 polybar bottom &
# #MONITOR=HDMI2 polybar top2 &
# echo "Bars launched..."


#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
    export TRAY_POSITION=none
    if [[ $m == "eDP1" ]]; then
        TRAY_POSITION=right
    fi
    MONITOR=$m polybar --reload powerbar &
done