#!/bin/bash
# Downloads this repo and runs the update program
git clone https://github.com/quiode/DOS76

sudo chmod +x DOS76/scripts/main/get.sh

sh DOS76/scripts/main/get.sh

sudo rm -r DOS76