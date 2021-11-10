#!/bin/bash
# This script gets current config files and updates the ones in the repo with them
echo -e "\e[1;34mGetting current repo files...\e[0m"

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=$SCRIPT_DIR"/../../"
# Variables
unalias cp

# Neovim
cp ~/.config/nvim/init.vim "$SCRIPT_DIR""/configs/nvim/"

# bash files
cp -r /home/"$USER"/.bashrc "$SCRIPT_DIR""/configs/bash/"
cp -r /home/"$USER"/.profile "$SCRIPT_DIR""/configs/bash/"
cp -r /home/"$USER"/.bash_aliases "$SCRIPT_DIR""/configs/bash/"

# VS-Code
cp -r /home/"$USER"/.config/Code/User/settings.json "$SCRIPT_DIR""/configs/code/"
cp -r /home/"$USER"/.config/Code/User/keybindings.json "$SCRIPT_DIR""/configs/code/"
cp -r /home/"$USER"/.config/.prettierrc.json "$SCRIPT_DIR""/configs/code/"

# Thunderbird
cp -r /home/"$USER"/.thunderbird/. "$SCRIPT_DIR""/configs/thunderbird/"

# qBittorrent
cp -r /home/"$USER"/.config/qBittorrent/qBittorrent.conf "$SCRIPT_DIR""/configs/qbittorrent/"

# Git
cp -r /home/"$USER"/.gitconfig "$SCRIPT_DIR""/configs/git/"
