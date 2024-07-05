#!/bin/bash

INFO_MESSAGE="Rice bash terminal"
FINISHED_MESSAGE="Terminal ricing finished"

BASH_PROMPT_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/bash-prompt"
UTILS_PATH="$(cd "$(readlink -f $(dirname "$0"))/../utils" && pwd)"
TMUX_CONFIG_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/tmux.conf"
COLOR_SCHEME_PATH=$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/gruvbox.conf"

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
    # Generate a new UUID for the duplicate profile
    new_uuid=$(uuidgen)

    # Load new color scheme config
    cat "$COLOR_SCHEME_PATH" | dconf load /org/gnome/terminal/legacy/profiles:/:$new_uuid/

    # Set the new profile as the default
    dconf write /org/gnome/terminal/legacy/profiles:/default "'$new_uuid'"
fi

echo "$FINISHED_MESSAGE"