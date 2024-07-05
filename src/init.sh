#!/bin/bash

export BASE_PATH="$(cd "$(readlink -f $(dirname "$0"))/.." && pwd)"
export CONFIG_PATH="$BASE_PATH/config"
export SCRIPTS_PATH="$BASE_PATH/src/scripts"
SERVERS=("servera" "serverb")

# Flag for automatic installation
auto_install=false

# Check for the -y parameter
while getopts "y" option; do
    case $option in
        y)
            auto_install=true
            ;;
        *)
            echo "Usage: $0 [-y]"
            exit 1
            ;;
    esac
done

for SERVER in "${SERVERS[@]}";
do
    scp -rq $BASE_PATH $SERVER:/home/student/
done

for script_file in $(ls $SCRIPTS_PATH);
do
    install=$auto_install
    script="$SCRIPTS_PATH/$script_file"

    if [ "$install" = false ]; then
        question="$(bash "$script" -i)"
        read -p "$question? (Y/n) " answer
        if [[ -z $answer || $answer =~ ^[Yy]$ ]]; then
            install=true
        else
            echo "Skipping $script_file."
        fi
    fi

    if [ "$install" = true ]; then
        echo "Running $script_file on workstation"
        sudo bash "$script"
        echo "Running $script_file on workstation DONE"
        echo ""

        for SERVER in "${SERVERS[@]}";
        do
            echo "Running $script_file on $SERVER"
            ssh $SERVER 'bash -s' << EOF
                sudo bash /home/student/rhel-init/src/scripts/$script_file
EOF
            echo "Running $script_file on $SERVER DONE"
            echo ""
        done
    fi
done

for SERVER in "${SERVERS[@]}";
do
    ssh $SERVER "rm -rf /home/student/rhel-init"
done
