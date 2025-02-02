#!/bin/bash

INFO_MESSAGE="Disable sudo passwords for wheel users"
FINISHED_MESSAGE="/etc/sudoers updated, sudo password no longer needed"

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

# Make backup
sudo cp /etc/sudoers /etc/sudoers.backup

# Set wheel user to nopasswd
sudo sed -i 's/# %wheel	ALL=(ALL)	NOPASSWD: ALL/%wheel	ALL=(ALL)	NOPASSWD: ALL/g' /etc/sudoers

# Comment out password request for wheel users
sudo sed -i 's/%wheel	ALL=(ALL)	ALL/# %wheel	ALL=(ALL)	ALL/g' /etc/sudoers