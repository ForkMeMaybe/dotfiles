#!/bin/bash

# Define the path to your dotfiles repository
DOTFILES_DIR="$HOME/repos/dotfiles/roles"

# List directories (roles) in the dotfiles directory
roles=$(find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

# Use rofi to select a role
selected_role=$(echo "$roles" | rofi -dmenu -p "Select a role to save:")

# Check if a role was selected
if [[ -n "$selected_role" ]]; then
    # Run the ansible-playbook command for the selected role
    cd "$HOME/repos/dotfiles" || exit
    if ./dotfiles save-"$selected_role"; then
        # If successful, notify of success
        notify-send -u normal -i ~/.config/dunst/icons/success.png "Dotfiles saved" "Role '$selected_role' saved successfully."
    else
        # If unsuccessful, notify of failure
        notify-send -u critical -i ~/.config/dunst/icons/error.png "Error" "Failed to save role '$selected_role'."
    fi
else
    echo "No role selected."
    notify-send -u low -i ~/.config/dunst/icons/notification.png "No role selected."
fi

