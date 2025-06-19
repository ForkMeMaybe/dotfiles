#!/bin/env bash

# Start gnome-keyring
nitrogen --restore
wal -R
picom &
dunst &
~/.config/qtile/clean_thumbs_cache.sh &
~/.config/qtile/battery_monitor.sh &
