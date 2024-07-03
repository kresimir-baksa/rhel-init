#!/bin/bash

INFO_MESSAGE="Install plugins for vim and rice it"
FINISHED_MESSAGE="Setting up /etc/vimrc.local done"

VIMRC_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/vimrc.local"

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

# Make the backup
sudo cp /etc/vimrc.local /etc/vimrc.local.backup

# Setup new vimrc.local file
sudo cat "$VIMRC_PATH" > /etc/vimrc.local

echo "$FINISHED_MESSAGE"