#!/bin/bash

INFO_MESSAGE="Add aliases for bash in /etc/profile.d"
FINISHED_MESSAGE="Lines successfully added to /etc/profile.d"

BASH_ALIASES_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/bash-aliases.sh"

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
sudo cp "$BASH_ALIASES_PATH" /etc/profile.d/

echo "$FINISHED_MESSAGE"