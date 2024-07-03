#!/bin/bash

INFO_MESSAGE="Rice bash terminal"
FINISHED_MESSAGE="Terminal ricing finished"

BASH_PROMPT_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/bash-prompt"

# Parse the input options
while getopts "i" opt; do
    case ${opt} in
        i )
            echo "$INFO_MESSAGE"
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Run the script

# Setup terminal prompt
sudo cp "$BASH_PROMPT_PATH" /etc/profile.d/prompt.sh

# Duplicate current prifle to enable gogh script run
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

# Run gogh
# Clone the repo into "$HOME/src/gogh"
mkdir -p "$HOME/src"
cd "$HOME/src"
git clone https://github.com/Gogh-Co/Gogh.git gogh
cd gogh

# necessary in the Gnome terminal on ubuntu
export TERMINAL=gnome-terminal

# Enter theme installs dir
cd installs

# install themes
./gruvbox-dark.sh

# Cleanup
rm -rf "$HOME/src"

echo "$FINISHED_MESSAGE"



# # Clone the repo into "$HOME/src/gogh"
# mkdir -p "$HOME/src"
# cd "$HOME/src"
# git clone https://github.com/Gogh-Co/Gogh.git gogh
# cd gogh

# # necessary in the Gnome terminal on ubuntu
# export TERMINAL=gnome-terminal

# # Enter theme installs dir
# cd installs

# # install themes
# ./gruvbox-dark.sh