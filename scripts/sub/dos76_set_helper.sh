#!/bin/bash
# Downloads this repo and runs the set program
cd /home/"$USER" || exit

git clone https://github.com/quiode/DOS76

sudo chmod +x DOS76/scripts/main/set.sh

bash DOS76/scripts/main/set.sh

cd /home/"$USER" || exit
sudo rm -r DOS76
