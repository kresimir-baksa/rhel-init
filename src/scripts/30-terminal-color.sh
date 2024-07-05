#!/bin/bash

INFO_MESSAGE="Rice bash terminal"
FINISHED_MESSAGE="Terminal ricing finished"

BASH_PROMPT_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/bash-prompt"
TMUX_CONFIG_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/tmux.conf"
COLOR_SCHEME_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/gruvbox.conf"

minimal_install=false
if [[ $(hostname) == server* ]];
then
    minimal_install=true
fi

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
sudo cp "$TMUX_CONFIG_PATH" /etc/tmux.conf

if [ "$minimal_install" = false ]; then
    # Generate a new UUID for the new profile
    new_uuid=$(uuidgen)
    echo "Generated UUID for new profile: $new_uuid"

    # Create the new profile with the name "default"
    profile_path="/org/gnome/terminal/legacy/profiles:/:${new_uuid}/"
    dconf write "${profile_path}visible-name" "'default'"

    # Get the current list of profile UUIDs
    profiles_list=$(dconf read /org/gnome/terminal/legacy/profiles:/list)

    # Check if profiles list is empty
    if [ -z "$profiles_list" ] || [ "$profiles_list" == "[]" ]; then
        echo "No profiles found. Creating a new profiles list."
        profiles_list="['${new_uuid}']"
    else
        echo "Current profiles list: $profiles_list"
        # Add the new UUID to the list of profiles
        profiles_list=$(echo $profiles_list | sed "s/]/, '${new_uuid}']/")
    fi

    # Write the updated profiles list back to dconf
    dconf write /org/gnome/terminal/legacy/profiles:/list "${profiles_list}"
    echo "Updated profiles list: $profiles_list"

    # Load new color scheme config
    cat "$COLOR_SCHEME_PATH" | dconf load /org/gnome/terminal/legacy/profiles:/:$new_uuid/

    # Set the new profile as the default profile
    dconf write /org/gnome/terminal/legacy/profiles:/default "'${new_uuid}'"
    echo "New profile set as default."
fi

echo "$FINISHED_MESSAGE"