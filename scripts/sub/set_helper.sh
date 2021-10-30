#!/bin/bash
# Downloads this repo and runs the set program
git clone https://github.com/quiode/DOS76

sudo chmod +x DOS76/scripts/main/set.sh

bash DOS76/scripts/main/set.sh

sudo rm -r DOS76
