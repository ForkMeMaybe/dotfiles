#!/bin/sh

export XDG_CURRENT_DESKTOP=qtile
export XDG_SESSION_DESKTOP=qtile
export XDG_SESSION_TYPE=x11
export QT_QPA_PLATFORM=xcb
export GDK_BACKEND=x11

dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE

exec /usr/bin/qtile start
