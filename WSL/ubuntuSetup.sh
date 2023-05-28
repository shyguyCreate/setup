#!/bin/bash

#Get update packages
sudo apt update

#Upgrade packages
sudo apt upgrade

#Upgrade additional distro packages
sudo apt dist-upgrade

#Update Ubuntu distro
sudo do-release-upgrade

#Install build tools
sudo apt-get install build-essential procps curl file git


#Add variables to .profile
echo '
#Variables
export WINHOME="/mnt/c/Users/$USER"
' >> $HOME/.profile


#Git configuration
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com


#Install ohmyposh
mkdir -p $HOME/.local/bin && curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin


#Write oh-my-posh lines to .profile
echo '
#OH-MY-POSH
eval "$(oh-my-posh init bash --config "$/mnt/c/Users/$USER/Github/install-Scripts/share/ohmyposh.omp.json")"
alias oh-my-posh-Update="curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin"
' >> $HOME/.profile
