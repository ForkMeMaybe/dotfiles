#!/bin/env bash

# Start gnome-keyring
nitrogen --restore
wal -R
picom &
dunst &
QT_QPA_PLATFORM=xcb XDG_SESSION_TYPE=x11 flameshot &
~/.config/qtile/clean_thumbs_cache.sh &
~/.config/qtile/battery_monitor.sh &
# /usr/lib/xdg-desktop-portal-gtk &
