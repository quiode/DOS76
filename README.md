# DOS76

# Table of Contents

- [DOS76](#dos76)
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Installation](#installation)
  - [Using the GitHub CLI](#using-the-github-cli)
  - [Using Git](#using-git)
- [Usage](#usage)

# Introduction

This repository is meant to easly setup a new Computer with my personal settings. It is meant to first cleanly install the [OS](https://pop.system76.com/) and then directely run the script. \
\
Versioning is done with a [version file](version.txt). The lines work as this:

1. Version of the config files
1. Version of the package list
1. Version of the additional programs
1. Version of the one time setup

# Installation

## Using the [GitHub CLI](https://github.com/cli/cli)

This is not tested as the GitHub Cli doesn't work on my machine.

```bash
gh clone quiode/DOS76
cd DOS76/scripts/main
chmod +x get.bashinstall.sh set.sh
./install.sh
```

## Using [Git](https://git-scm.com/)

```bash
git clone https://github.com/quiode/DOS76
cd DOS76/scripts/main
chmod +x get.bashinstall.sh set.sh
./install.sh
```

# Usage

- Install the dotfiles with [install](./scripts/main/install.sh).
- Update the dotfiles on the system with the files in the repository with [get](./scripts/main/get.sh).
- Update the dotfiles in the repository with the files in the system with [set](./scripts/main/set.sh).
