#!/bin/bash
# This script installs all packages and configfiles, removes old config filesset

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=$SCRIPT_DIR"/../../"
# Variables
unalias cp
# Functions
leave() {
    echo -e "Aborting..."
    exit 1
}

post_setup() {
    # Versioning
    # First line = config
    # Second line = packages
    # Third line = additional programs
    # Fourth line = one time setup
    if [ ! -d "/home/$USER/.config/DOS76" ]; then
        mkdir -p /home/"$USER"/.config/DOS76
    fi

    cp -r "$SCRIPT_DIR""/version.txt" /home/"$USER"/.config/DOS76/

    echo -e "\e[34mCongratulations! You just finished installing. Next steps are:\e[0m"
    echo -e "\e[34m- Setting your theme (if you want one, I don't but hey) and personal information in LibreOffice\e[0m"
    echo -e "\e[34m- Setting your theme in Joplin and changing your settings.\e[0m"
    echo -e "\e[34m- Running :PlugInstall and :UpdateRemotePlugins in NeoVim \e[0m"
    exit 0

    rm -r "$SCRIPT_DIR""/../"
}

if [[ $EUID -eq 0 ]]; then
    echo -e "\e[31mDo not run this as the root user\e[0m"
    leave
fi

if [ -d "/home/$USER/.config/DOS76" ]; then
    echo -e "\e[31mYou already have DOS76 installed.\e[0m"
    echo -e "\e[31mIf you want to reinstall, delete the folder /home/$USER/.config/DOS76\e[0m"
    echo -e "\e[31mIf you want to update, run the update script.\e[0m"
    leave
fi

while true; do
    read -r -p 'If you continue, all packages will be downloaded. Do you want to continue [Y/n]?' choice
    case "$choice" in
    n | N) leave ;;
    *) break ;;
    esac
done

bash "$SCRIPT_DIR"/scripts/sub/install_packages.sh

bash "$SCRIPT_DIR"/scripts/sub/install_programms.sh

bash "$SCRIPT_DIR"/scripts/sub/one_time_setup.sh

while true; do
    read -r -p 'If you continue, all config files will be overritten. Do you want to continue [Y/n]?' choice
    case "$choice" in
    n | N) leave ;;
    *) break ;;
    esac
done

bash "$SCRIPT_DIR"/scripts/sub/install_configs.sh

neofetch

post_setup
