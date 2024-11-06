#!/bin/bash
notify-send -u normal "Autostart.sh executed"

nitrogen --restore
picom &
dunst &
~/.config/qtile/battery_monitor.sh &
