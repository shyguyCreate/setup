#!/bin/bash

#Additions commands to .profile file
echo '#Extra commands for WSL bash command.' >> ~/.bashrc
echo '. /mnt/c/Users/$USER/OneDrive/Documents/WSL/bashrc_Extra.sh' >> ~/.bashrc

#git config
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"

#Change distro update type
sudo nano /etc/update-manager/release-upgrades  #Change to Prompt=lts

#Update Ubuntu distro
sudo do-release-upgrade -d

#Get update packages
sudo apt update

#Upgrade packages
sudo apt upgrade