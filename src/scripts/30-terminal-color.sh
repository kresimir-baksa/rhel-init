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
sudo cp "$BASH_PROMPT_PATH" /etc/profiles.d/prompt.sh

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