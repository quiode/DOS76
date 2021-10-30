#!/bin/bash
# Installs the latest configuration files
echo -e "\e[34mInstalling latest configuration files...\e[0m"

# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# Variables
unalias cp

# Gnome Terminal Dracula Theme
echo -e "\e[34mSetting Gnome Terminal...\e[0m"
git clone https://github.com/dracula/gnome-terminal
cd gnome-terminal || exit
./install.sh
cd ../
rm -rf gnome-terminal

eval "$(dircolors "/home/$USER/.dir_colors/dircolors")"

# Neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' # Install vim-plug

cp "$SCRIPT_DIR""/configs/nvim/init.vim" ~/.config/nvim/init.vim

# OneDrive
echo -e "\e[34mSetting OneDrive...\e[0m"
choice=''
while :; do
    read -r -p 'OneDrive is going to be set-up. If you want to use another directory than the standard one, specify it now. Use <Enter> for the default one.' choice
    if [ -d "$choice" ]; then
        if [ -w "$choice" ]; then
            break
        else
            echo -e "\e[31mThe specified directory is not writeable. Please try again...\e[0m"
        fi
    elif
        [ -z "$choice" ]
    then
        choice='/home/'$USER'/OneDrive'
        break
    else
        echo -e "\e[31mThe directory you specified does not exist. Please try again.\e[0m"
    fi
done

echo -e "\e[34mPlease authenticate with your personal account.\e[0m"
onedrive
# Copy the personal account config files
cp -r "$SCRIPT_DIR""/configs/onedrive/onedrive/config" /home/"$USER"/.config/onedrive

if [ ! -d "$choice" ]; then
    mkdir "$choice"
else
    echo -e "\e[31mThe specified directory already exists.\e[0m"
    read -r -p 'Do you want to overwrite it? [Y/n]' choice
    if [ "$choice" == "n" ]; then
        leave
    elif [ "$choice" == "N" ]; then
        leave
    else
        sudo rm -rf "$choice"
        mkdir "$choice"
    fi
fi
# Replace the default save-location with the one specified
mkdir "$choice"'/Private/'
cd /home/"$USER"/.config/onedrive || exit

# https://stackoverflow.com/questions/11145270/how-to-replace-an-entire-line-in-a-text-file-by-line-number
sed -i '7s#.*#sync_dir = "'"$choice"'/Private/"#' config

# Make onedrive school setup
cp -r "$SCRIPT_DIR""/configs/onedrive/onedrive-school" /home/"$USER"/.config/

# Replace the default save-location with the one specified
mkdir "$choice"'/School/'
cd /home/"$USER"/.config/onedrive-school || exit

# https://stackoverflow.com/questions/11145270/how-to-replace-an-entire-line-in-a-text-file-by-line-number
sed -i '7s#.*#sync_dir = "'"$choice"'/School/"#' config

echo -e "\e[34mPlease authenticate with your school account.\e[0m"

onedrive --confdir="~/.config/onedrive-school"

# Setup notification daemon for OneDrive Private
sudo systemctl stop onedrive@"$USER".service
sudo systemctl disable onedrive@"$USER".service

systemctl --user enable onedrive
systemctl --user start onedrive

# Setup notification daemon for OneDrive School
cd /usr/lib/systemd/user/ || exit
sudo cp onedrive.service onedrive-school.service

sed -i '8s#.*#ExecStart=/usr/bin/onedrive --monitor --confdir="/home/'"$USER"'/.config/onedrive-school#' onedrive-school.service

systemctl --user enable onedrive-school
systemctl --user start onedrive-school

# scripts
cd "$SCRIPT_DIR" || exit
git clone https://github.com/quiode/scripts
cd scripts/scripts || exit
sudo cp -r onedrive/onedrive-status /opt && sudo chmod +x /opt/onedrive-status # Install onedrive-status script

sudo rm -r "$SCRIPT_DIR"/scripts # clean up

# bash files
cp -r "$SCRIPT_DIR""/configs/bash/." /home/"$USER"/

# NVM
cd "$SCRIPT_DIR" || exit
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
. /home/"$USER"/.bashrc
nvm install node

# VS-Code
# TODO: Error
if [ ! -d "/home/$USER/.config/Code" ]; then
    mkdir -p /home/"$USER"/.config/Code
    mkdir -p /home/"$USER"/.config/Code/User
elif [ ! -d "/home/$USER/.config/Code/User" ]; then
    mkdir -p /home/"$USER"/.config/Code/User
fi

cp -r "$SCRIPT_DIR""/configs/code/settings.json" /home/"$USER"/.config/Code/User/settings.json
cp -r "$SCRIPT_DIR""/configs/code/keybindings.json" /home/"$USER"/.config/Code/User/keybindings.json
cp -r "$SCRIPT_DIR""/configs/code/.prettierrc.json" /home/"$USER"/.config/

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

# Thunderbird
if [ ! -d "/home/$USER/.thunderbird/" ]; then
    mkdir -p /home/"$USER"/.thunderbird/
fi

cp -r "$SCRIPT_DIR""/configs/thunderbird/." /home/"$USER"/.thunderbird/

# LibreOffice
libreoffice # Have to make if more efficient
cd "$SCRIPT_DIR" || exit
git clone https://github.com/dracula/libreoffice.git
cd libreoffice || exit
cp dracula.soc /home/"$USER"/.config/libreoffice/*/user/config/
sh add_dracula_application_colors.sh

wget https://github.com/dohliam/libreoffice-impress-templates/releases/download/v2.2/libreoffice-impress-templates-all_2.2-1.deb # Check regularly for the latest release
sudo dpkg -i libreoffice-impress-templates-all_2.2-1.deb
rm -r libreoffice-impress-templates-all_2.2-1.deb

# qBittorrent
# TODO: Test from here
wget https://github.com/dracula/qbittorrent/raw/master/qbittorrent.qbtheme
if [ ! -d "/home/$USER/.config/qBittorrent" ]; then
    mkdir -p /home/"$USER"/.config/qBittorrent
fi
mv qbittorrent.qbtheme /home/"$USER"/.config/qBittorrent/
cp -r "$SCRIPT_DIR""/configs/qbittorrent/qBittorrent.conf" /home/"$USER"/.config/qBittorrent/
sed -i '7s#.*#General\\CustomUIThemePath=/home/'"$USER"'/.config/qBittorrent/qbittorrent.qbtheme#' /home/"$USER"/.config/qBittorrent/qBittorrent.conf

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

# Github SSH Key
echo -e "\e[34mSetting SSH-Key for GitHub. Please follow instructions. (Just Press Enter (and select SSH instead of HTTPS))\e[0m"
sleep 2
ssh-keygen -t ed25519 -C "domi.schwaiger04@gmail.com"
eval "$(ssh-agent -s)"
ssh-add /home/"$USER"/.ssh/id_ed25519
gh auth login
