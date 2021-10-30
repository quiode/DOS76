#!/bin/bash
# Installs the latest packages
echo -e "\e[34mInstalling latest packages...\e[0m"

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=$SCRIPT_DIR"/../../"
# Variables
unalias cp

#APT
echo -e "\e[34mAPT\e[0m"
sudo apt-get update
# OneDrive Repositories
echo 'deb https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_21.04/ ./' >>/etc/apt/sources.list
wget https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_21.04/Release.key
sudo apt-key add ./Release.key
rm ./Release.key

# GitHub Cli
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

# GitHub Desktop
wget -qO - https://packagecloud.io/shiftkey/desktop/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/shiftkey/desktop/any/ any main" > /etc/apt/sources.list.d/packagecloud-shiftky-desktop.list'

# Teams
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'

# Zotero
wget -qO- https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash

# AppImage
sudo add-apt-repository ppa:appimagelauncher-team/stable

# Signal
# NOTE: These instructions only work for 64 bit Debian-based
# Linux distributions such as Ubuntu, Mint etc.

# 1. Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor >signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg >/dev/null

if [ -e signal-desktop-keyring.gpg ]; then
    rm -r signal-desktop-keyring.gpg
fi

# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |
    sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

sudo add-apt-repository -y universe multiverse
sudo apt-get update
sudo apt-get upgrade -y
filepath=$SCRIPT_DIR"/packages/apt.txt"
while read -r line; do
    sudo apt-get install -y "$line"
done <"$filepath"
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y
# FLATPAK
echo -e "\e[34mFLATPAK\e[0m"
flatpak update
filepath=$SCRIPT_DIR"/packages/flatpak.txt"
while read -r line; do
    flatpak install "$line" -y
done <"$filepath"
# SNAP
echo -e "\e[34mSNAP\e[0m"
sudo snap refresh
filepath=$SCRIPT_DIR"/packages/snap.txt"
while read -r line; do
    sudo snap install "$line"
done <"$filepath"
