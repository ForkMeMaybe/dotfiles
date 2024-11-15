#!/bin/env bash

# Icons for notifications
icon_success="$HOME/.config/dunst/icons/cached.png"
icon_error="$HOME/.config/dunst/icons/warning.png"
icon_warning="$HOME/.config/dunst/icons/exclamation.png"

# The cache directory path
cache_directory="$HOME/.cache/mpv_thumbs_cache"

# Check if the cache directory exists, if not, exit
if [ ! -d "$cache_directory" ]; then
    notify-send "MPV Cache Cleaner" "Cache directory does not exist." -i "$icon_warning" -u normal
    exit 0
fi

# Maximum allowed cache size in bytes (e.g., 50MB = 50 * 1024 * 1024)
#max_cache_size=$((50 * 1024 * 1024))
max_cache_size=1000  # Set a small value to trigger cleanup

# Function to calculate directory size
get_cache_size() {
    du -sb "$cache_directory" | awk '{print $1}'
}

# Function to clean the cache if it exceeds the max size
clean_cache_if_needed() {
    local cache_size
    cache_size=$(get_cache_size)

    # Check if the size retrieval was successful
    if [ -z "$cache_size" ]; then
        notify-send "MPV Cache Cleaner" "Failed to retrieve cache size." -i "$icon_error" -u critical
        exit 1
    fi

    if [ "$cache_size" -gt "$max_cache_size" ]; then
        # Attempt to remove everything in the cache directory
        if rm -rf "$cache_directory"/*; then
            notify-send "MPV Cache Cleaner" "Cache cleaned to free up space." -i "$icon_success" -u normal
        else
            notify-send "MPV Cache Cleaner" "Failed to clean cache directory." -i "$icon_error" -u critical
            exit 1
        fi
    fi
}

# Clean the cache if necessary before proceeding
clean_cache_if_needed

