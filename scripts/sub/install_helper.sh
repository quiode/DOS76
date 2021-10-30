#!/bin/bash
# This helper helps installing the latest version of the repo.
git clone https://github.com/quiode/DOS76

sudo chmod +x DOS76/scripts/main/install.sh

bash DOS76/scripts/main/install.sh

sudo rm -r DOS76
