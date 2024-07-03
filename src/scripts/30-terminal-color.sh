#!/bin/bash

INFO_MESSAGE="Rice bash terminal"
FINISHED_MESSAGE="Terminal ricing finished"

BASH_PROMPT_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/bash-prompt"
UTILS_PATH="$(cd "$(readlink -f $(dirname "$0"))/../utils" && pwd)"

minimal_install=false

# Parse the input options
while getopts "im" opt; do
    case ${opt} in
        i )
            echo "$INFO_MESSAGE"
            exit 0
            ;;
        m )
            minimal_install=true
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

if [ "$minimal_install" = false ]; then
    # Duplicate current prifle to enable gogh script run
    bash "$UTILS_PATH/duplicate-term-theme.sh"

    sleep 1

    # Run gogh
    bash "$UTILS_PATH/gogh.sh"

    # Cleanup
    rm -rf "$HOME/src"
fi

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