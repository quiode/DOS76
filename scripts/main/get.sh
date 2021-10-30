#!/bin/bash
# This script gets all config files on this system and updates the repo.

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Variables
unalias cp

# Versioning
# First line = config
# Second line = packages
# Third line = additional programms
# Fourth line = one time setup
if [ -d "/home/$USER/.config/DOS76" ]; then
    if [ ! "$(sed '1!d' /home/"$USER"/.config/DOS76/version.txt)" = "$(sed '1!d' "$SCRIPT_DIR"/version.txt)" ]; then
        echo "\e[1;34mUpdating config files.\e[0m"
        sh "$SCRIPT_DIR"/scripts/sub/install_config.sh || exit
    elif [ ! "$(sed '2!d' /home/"$USER"/.config/DOS76/version.txt)" = "$(sed '2!d' "$SCRIPT_DIR"/version.txt)" ]; then
        echo "\e[1;34mUpdating package files.\e[0m"
        sh "$SCRIPT_DIR"/scripts/sub/install_packages.sh || exit
    elif [ ! "$(sed '3!d' /home/"$USER"/.config/DOS76/version.txt)" = "$(sed '3!d' "$SCRIPT_DIR"/version.txt)" ]; then
        echo "\e[1;34mUpdating additional programs.\e[0m"
        sh "$SCRIPT_DIR"/scripts/sub/install_programms.sh || exit
    elif [ ! "$(sed '4!d' /home/"$USER"/.config/DOS76/version.txt)" = "$(sed '4!d' "$SCRIPT_DIR"/version.txt)" ]; then
        echo "\e[1;34mUpdating one time setup files.\e[0m"
        sh "$SCRIPT_DIR"/scripts/sub/one_time_setup.sh || exit
    else
        echo "\e[1;32mEverything is up to date.\e[0m"
        exit 1
    fi
else

    mkdir -p /home/"$USER"/.config/DOS76

    sh "$SCRIPT_DIR"/scripts/sub/install_config.sh || exit
    sh "$SCRIPT_DIR"/scripts/sub/install_packages.sh || exit
    sh "$SCRIPT_DIR"/scripts/sub/install_programms.sh || exit
    sh "$SCRIPT_DIR"/scripts/sub/one_time_setup.sh || exit
fi

cp -r "$SCRIPT_DIR"/version.txt /home/"$USER"/.config/DOS76/
