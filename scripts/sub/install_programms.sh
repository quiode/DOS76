#!/bin/bash
# This script installs additional packages not managed by a package manager
echo -e "\e[34mInstalling latest programs...\e[0m"

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=$SCRIPT_DIR"/../../"
# Variables
unalias cp

# Neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' # Install vim-plug

# NVM
cd "$SCRIPT_DIR" || exit
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | sh
sh /home/"$USER"/.bashrc
nvm install node

#VS-Code
echo -e "\e[34mInstalling VS-Code Extensions\e[0m"
filepath=$SCRIPT_DIR"/packages/code.txt"
while read -r line; do
    code --install-extension "$line"
done <"$filepath"

# Write
cd "$SCRIPT_DIR" || exit
wget -O write-tgz http://www.styluslabs.com/download/write-tgz
tar -xf write-tgz
sudo mv Write /opt/
cd /opt/Write/ || exit
sudo chmod +x setup.sh
./setup.sh
cd "$SCRIPT_DIR" || exit
rm -r write-tgz

# Rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

# Gnome Shell Extensions
# https://github.com/brunelli/gnome-shell-extension-installer
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x gnome-shell-extension-installer
sudo mv gnome-shell-extension-installer /usr/bin/

filepath=$SCRIPT_DIR"/packages/gnome_shell_extensions.txt"
while read -r line; do
    gnome-shell-extension-installer "$line" --yes
done <"$filepath"

# Droidcam
cd /home/"$USER"/ || exit
mkdir tmp
cd /tmp/ || exit
wget -O droidcam_latest.zip https://files.dev47apps.net/linux/droidcam_1.8.0.zip
unzip droidcam_latest.zip -d droidcam
cd droidcam && sudo ./install-client
sudo ./install-video
sudo ./install-sound
