#!/bin/bash
# This script gets all config files on this system and updates the repo.

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Variables
unalias cp

# Versioning
# First line = config
# Second line = packages
if [ -d "/home/$USER/.config/DOS76" ]; then
    if [ "$(sed '1!d' /home/"$USER"/.config/DOS76/version.txt)" = "$(sed '1!d' "$SCRIPT_DIR"/version.txt)" ]; then
        exit 1
    else
        sh "$SCRIPT_DIR"/scripts/sub/install_config.sh || exit
    fi

    if [ "$(sed '2!d' /home/"$USER"/.config/DOS76/version.txt)" = "$(sed '2!d' "$SCRIPT_DIR"/version.txt)" ]; then
        exit 1
    else
        sh "$SCRIPT_DIR"/scripts/sub/install_packages.sh || exit
    fi
else
    mkdir -p /home/"$USER"/.config/DOS76

    sh "$SCRIPT_DIR"/scripts/sub/install_config.sh || exit
    sh "$SCRIPT_DIR"/scripts/sub/install_packages.sh || exit
fi

cp -r "$SCRIPT_DIR"/version.txt /home/"$USER"/.config/DOS76/
