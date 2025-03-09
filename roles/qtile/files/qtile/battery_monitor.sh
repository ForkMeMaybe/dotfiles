#!/bin/env bash

icondir="$HOME/.config/dunst/icons"
low_battery_icon="$icondir/battery-low.png"
full_battery_icon="$icondir/battery-full.png"
charging_icon="$icondir/battery-charging.png"
discharging_icon="$icondir/battery-discharging.png"
battery_at_60_icon="$icondir/battery-60.png"

# Kill all similarly named processes except this one
for pid in $(pgrep -f "$(basename "$0")"); do
    if [ $pid != $$ ]; then
        kill $pid
    fi
done

i=1
low_battery_flag=1
time=4000 # Time in ms (milliseconds)

while true; do
    percentage=$(cat /sys/class/power_supply/BAT0/capacity)
    charging=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$charging" != "Charging" ]; then
        # If the battery is not charging
        if [ $percentage -le 20 ] && [ $low_battery_flag -eq 1 ]; then
            notify-send -u critical -i "$low_battery_icon" "Low Battery" "$percentage%"
            low_battery_flag=0
        fi
    else
        # If the battery is charging
        if [ $i -eq 0 ]; then
            dunstctl close
            notify-send -u low -i "$charging_icon" "$percentage%" "Charging"
            i=1
        fi

        if [ $percentage -eq 60 ]; then
            notify-send -u normal -i "$battery_at_60_icon" "Battery At" "$percentage%"
        fi

        if [ $percentage -eq 90 ]; then
            notify-send -u critical -i "$full_battery_icon" "High Battery" "$percentage%"
        fi
    fi

    # Toggling low battery flag
    if [ $percentage -gt 20 ] && [ $low_battery_flag -eq 0 ]; then
        low_battery_flag=1
    fi

    # Check for charging status change
    if [ "$charging" != "Charging" ] && [ $i -eq 1 ]; then
        dunstctl close
        notify-send -u low -i "$discharging_icon" "$percentage%" "Discharging"
        i=0
    fi

    sleep $(( time / 1000 ))
done

