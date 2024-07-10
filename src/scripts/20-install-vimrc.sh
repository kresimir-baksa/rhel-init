#!/bin/bash

INFO_MESSAGE="Install plugins for vim and rice it"
FINISHED_MESSAGE="Setting up /etc/vimrc.local done"

VIMRC_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/vimrc.local"

is_server=false
if [[ $(hostname) == server* ]];
then
    is_server=true
fi

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

# Make the backup
if [ -f /etc/vimrc.local ]; then
    sudo cp /etc/vimrc.local /etc/vimrc.local.backup
fi

# Install git to be able to download the theme
sudo dnf install -y git

# Make global config dirs
# sudo mkdir -p /etc/vim/conf.d
# sudo mkdir -p /usr/local/opt/fzf
# sudo chmod a+rwx /etc/vim/conf.d
# sudo chmod a+rwx /usr/local/opt/fzf

# Setup new vimrc.local file
sudo cp "$VIMRC_PATH" /etc/vimrc.local

# Compile vimrc for user and root
# if [ "$is_server" = false ]; then
# vim -c 'PlugInstall'
# sudo vim -c 'PlugInstall'
# fi

# Compile vimrc
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# vim +PlugInstall +qall
# vim -c "source /etc/vimrc" -c "quit"

echo "$FINISHED_MESSAGE"