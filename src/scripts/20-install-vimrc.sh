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

# Setup new vimrc.local file
sudo cp "$VIMRC_PATH" /etc/vimrc.local

if [ "$is_server" = false ]; then
    # Compile vimrc for user
    vim -c 'PlugInstall'

    # Compress compiled dir
    zip -r ~/vim.zip ~/.vim

    # Copy compiled dir to servers
    scp -rq ~/vim.zip servera:/home/student/
    scp -rq ~/vim.zip serverb:/home/student/

    # Clear zipped file
    rm -rf ~/vim.zip

    # Copy compiles to root dir
    sudo cp -rf ~/.vim /root/
    sudo chown root:root -R /root/.vim
else
    # Run on server
    unzip vim.zip
    rm -rf vim.zip

    # Copy compiles to root dir
    sudo cp -rf ~/.vim /root/
    sudo chown root:root -R /root/.vim
fi

# Compile vimrc
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# vim +PlugInstall +qall
# vim -c "source /etc/vimrc" -c "quit"

echo "$FINISHED_MESSAGE"