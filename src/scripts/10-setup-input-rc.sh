#!/bin/bash

INFO_MESSAGE="Add keyboard shorcuts for bash in /etc/inputrc"
FINISHED_MESSAGE="Lines successfully added to /etc/inputrc"

INPUTRC_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/bash-inputrc"

# Parse the input options
while getopts "is" opt; do
    case ${opt} in
        i )
            echo "$INFO_MESSAGE"
            exit 0
            ;;
        s )
            # 0 = run as admin, 1 = run as user
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Run the script
grep -qxF "## arrow up" /etc/inputrc && echo "Changes already done" && return 0

# Make backup
sudo cp /etc/inputrc /etc/inputrc.backup

# Add lines to /etc/inputrc
sudo cat "$INPUTRC_PATH" >> /etc/inputrc

echo "$FINISHED_MESSAGE"