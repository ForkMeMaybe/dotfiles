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
    ./dotfiles save-"$selected_role"
else
    echo "No role selected."
fi

