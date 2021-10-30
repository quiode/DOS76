#!/bin/bash
# This script gets all config files on this system and updates the repo.
echo -e "\e[1;34mUpdating repo config files...\e[0m"
# Constants
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=$SCRIPT_DIR"/../../"

# Variables
unalias cp

# Updating repo
cd "$SCRIPT_DIR" || exit
git pull --rebase || exit

# upload configs
bash "$SCRIPT_DIR/scripts/sub/upload_configs.sh" || exit

echo -e "\e[1;32mDone! Uploading repo...\e[0m"
git commit -a -m "Config Update" || exit
git push || exit
echo -e "\e[1;32mDone\e[0m"
