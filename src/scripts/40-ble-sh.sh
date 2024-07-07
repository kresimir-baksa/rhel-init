#!/bin/bash

INFO_MESSAGE="Install ble.sh for bash terminal"
FINISHED_MESSAGE="Installation of ble.sh completed"

BLE_BASHRC_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/ble.bashrc.sh"
BLE_COLORS_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/ble.colors"

minimal_install=false
if [[ $(hostname) == server* ]];
then
    minimal_install=true
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
            exit 1
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Run the script

# Create global blesh dir
sudo mkdir -p /etc/blesh`
sudo chmod a+rwx /etc/blesh

if [ "$minimal_install" = false ]; then
    # Install on workstation

    # Clone and install
    git clone --recursive https://github.com/akinomyoga/ble.sh.git
    cd ble.sh
    make
    cp -rf ./out/* /etc/blesh/

    # Copy color theme to INSDIR
    cp "$BLE_COLORS_PATH" /etc/blesh/
else
    # Download build from workstation
    scp -rq workstation:/etc/blesh/* /etc/blesh/
fi

# Add bashrc config
sed -i "s|path-to-blesh|/etc/blesh/ble.sh|g" $BLE_BASHRC_PATH
sed -i "s|path-to-blesh-colors|/etc/blesh/ble.colors|g" $BLE_BASHRC_PATH
sudo cp $BLE_BASHRC_PATH /etc/profile.d/

echo "$FINISHED_MESSAGE"