#!/bin/env bash

# Icons for notifications
icon_success="$HOME/.config/dunst/icons/cached.png"
icon_error="$HOME/.config/dunst/icons/warning.png"
icon_warning="$HOME/.config/dunst/icons/exclamation.png"

# The cache directory paths
mpv_cache_directory="$HOME/.cache/mpv_thumbs_cache"
tumbler_cache_directory="$HOME/.cache/thumbnails"

# Function to calculate directory size
get_cache_size() {
    du -sb "$1" | awk '{print $1}'
}

# Function to clean the cache if it exceeds the max size
clean_cache_if_needed() {
    local cache_size
    cache_size=$(get_cache_size "$1")
    local cache_name=$2

    # Check if the size retrieval was successful
    if [ -z "$cache_size" ]; then
        notify-send "$cache_name Cache Cleaner" "Failed to retrieve cache size." -i "$icon_error" -u critical
        exit 1
    fi

    if [ "$cache_size" -gt "$max_cache_size" ]; then
        # Attempt to remove everything in the cache directory
        if rm -rf "$1"/*; then
            notify-send "$cache_name Cache Cleaner" "$cache_name cache cleared to free up space." -i "$icon_success" -u normal
        else
            notify-send "$cache_name Cache Cleaner" "Failed to clean $cache_name cache." -i "$icon_error" -u critical
            exit 1
        fi
    fi
}

# Maximum allowed cache size in bytes (e.g., 50MB = 50 * 1024 * 1024)
#max_cache_size=$((50 * 1024 * 1024))
max_cache_size=1000

# Check if both directories exist
if [ ! -d "$mpv_cache_directory" ] && [ ! -d "$tumbler_cache_directory" ]; then
    notify-send "Cache Cleaner" "Neither MPV nor Tumbler cache directory exists." -i "$icon_warning" -u normal
    exit 0
fi

# Clean MPV cache if the MPV directory exists
if [ -d "$mpv_cache_directory" ]; then
    clean_cache_if_needed "$mpv_cache_directory" "MPV"
fi

# Clean MPV cache if the MPV directory exists
if [ -d "$tumbler_cache_directory" ]; then
    clean_cache_if_needed "$tumbler_cache_directory" "Tumbler"
fi

