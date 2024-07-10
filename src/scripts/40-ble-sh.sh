#!/bin/bash

INFO_MESSAGE="Install ble.sh for bash terminal"
FINISHED_MESSAGE="Installation of ble.sh completed"

BLE_ETC_PATH="/etc/ble"
BASHRC_SCRIPT="/etc/bashrc"
BLE_BASHRC_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/ble.bashrc.sh"
BLE_COLORS_PATH="$(cd "$(readlink -f $(dirname "$0"))/../.." && pwd)/config/ble.colors"
SOURCE_COMMAND="source $BLE_ETC_PATH/ble.sh && source $BLE_ETC_PATH/ble.colors"

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
            exit 1
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Run the BASHRC_SCRIPT

# Create global blesh dir
sudo mkdir -p $BLE_ETC_PATH
sudo chmod a+rwx $BLE_ETC_PATH

if [ "$is_server" = false ]; then
    # Install on workstation

    # Make sure that make is installed
    sudo dnf install make -y

    # Clone and install
    git clone --recursive https://github.com/akinomyoga/ble.sh.git
    cd ble.sh
    make
    cp -rf ./out/* $BLE_ETC_PATH/

    # Copy color theme to INSDIR
    cp "$BLE_COLORS_PATH" "$BLE_ETC_PATH/"

    # Clean up ble.sh repo
    rm -rf ble.sh
else
    # Install expect
    sudo dnf install expect -y

    # Download build from workstation
    expect <<EOF
    set timeout -1
    spawn scp -o StrictHostKeyChecking=no -rq workstation:$BLE_ETC_PATH /home/student/ble
    expect {
        "*password:" {
            send "$password\r"
            exp_continue
        }
        eof
    }
EOF
    # scp -o StrictHostKeyChecking=no -rq workstation:"$BLE_ETC_PATH"/* "$BLE_ETC_PATH"/
    sudo mv ~/ble /etc/
fi

# Check if the line is already present
if ! grep -qF "$SOURCE_COMMAND" "$BASHRC_SCRIPT"; then
    # Make backup
    sudo cp "$BASHRC_SCRIPT" "$BASHRC_SCRIPT.backup"
    
    # Use awk to insert the line before the last 'fi' statement
    awk -v insert="$SOURCE_COMMAND" '
    BEGIN { lastFiLine = 0; }
    {
        lines[NR] = $0;
        if ($1 == "fi" && $2 == "" && substr($0, length, 1) != "#") {
            lastFiLine = NR;
        }
    }
    END {
        for (i = 1; i <= NR; i++) {
            print lines[i];
            if (i == lastFiLine - 1) {
                print insert;
            }
        }
    }' "$BASHRC_SCRIPT" > bashrc.tmp
    sudo mv bashrc.tmp "$BASHRC_SCRIPT"
fi

echo "$FINISHED_MESSAGE"