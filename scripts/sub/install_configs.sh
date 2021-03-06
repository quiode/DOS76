#!/bin/bash
# Installs the latest configuration files
echo -e "\e[34mInstalling latest configuration files...\e[0m"

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=$SCRIPT_DIR"/../../"
# Variables
unalias cp

# Neovim
if [ ! -d ~/.config/nvim ]; then
    mkdir -p ~/.config/nvim
fi
cp "$SCRIPT_DIR""/configs/nvim/init.vim" ~/.config/nvim/

# bash files
cp -r "$SCRIPT_DIR""/configs/bash/." /home/"$USER"/

# VS-Code
if [ ! -d "/home/$USER/.config/Code" ]; then
    mkdir -p /home/"$USER"/.config/Code
    mkdir -p /home/"$USER"/.config/Code/User
elif [ ! -d "/home/$USER/.config/Code/User" ]; then
    mkdir -p /home/"$USER"/.config/Code/User
fi

cp -r "$SCRIPT_DIR""/configs/code/settings.json" /home/"$USER"/.config/Code/User/
cp -r "$SCRIPT_DIR""/configs/code/keybindings.json" /home/"$USER"/.config/Code/User/
cp -r "$SCRIPT_DIR""/configs/code/.prettierrc.json" /home/"$USER"/.config/

# Thunderbird
if [ ! -d "/home/$USER/.thunderbird/" ]; then
    mkdir -p /home/"$USER"/.thunderbird/
fi

cp -r "$SCRIPT_DIR""/configs/thunderbird/." /home/"$USER"/.thunderbird/

# qBittorrent
cp -r "$SCRIPT_DIR""/configs/qbittorrent/qBittorrent.conf" /home/"$USER"/.config/qBittorrent/
sed -i '7s#.*#General\\CustomUIThemePath=/home/'"$USER"'/.config/qBittorrent/qbittorrent.qbtheme#' /home/"$USER"/.config/qBittorrent/qBittorrent.conf

# Git
cp -r "$SCRIPT_DIR""/configs/git/.gitconfig" /home/"$USER"/
