#!/bin/bash
notify-send -u normal "Autostart.sh executed"

nitrogen --restore
picom &
dunst &
~/.config/qtile/clean_thumbs_cache.sh &
~/.config/qtile/battery_monitor.sh &
