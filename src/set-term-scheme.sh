#!/bin/bash

# List existing profiles with names
echo "Existing profiles:"
for profile in $(dconf list /org/gnome/terminal/legacy/profiles:/ | grep '^:' | sed 's/\///'); do
    name=$(dconf read /org/gnome/terminal/legacy/profiles:/$profile/visible-name)
    echo "$profile: $name"
done

# Prompt the user to enter the UUID of the profile to set as default
read -p "Enter the UUID of the profile to set as default: " selected_uuid

# Set the selected profile as the default
dconf write /org/gnome/terminal/legacy/profiles:/default "'$selected_uuid'"

echo "Profile $selected_uuid set as default."

