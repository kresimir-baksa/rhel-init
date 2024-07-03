#!/bin/bash

# Get the current default profile UUID
current_default=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")

# Generate a new UUID for the duplicate profile
new_uuid=$(uuidgen)

# Duplicate the current profile
dconf dump /org/gnome/terminal/legacy/profiles:/:$current_default/ | dconf load /org/gnome/terminal/legacy/profiles:/:$new_uuid/

# Set the visible name for the new profile
dconf write /org/gnome/terminal/legacy/profiles:/:$new_uuid/visible-name "'new_duplicate'"

# Set the new profile as the default
dconf write /org/gnome/terminal/legacy/profiles:/default "'$new_uuid'"

echo "Duplicated profile $current_default to $new_uuid and set it as default."
