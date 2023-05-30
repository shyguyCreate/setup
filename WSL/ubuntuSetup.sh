#!/bin/bash

#Get update packages
sudo apt update

#Upgrade packages
sudo apt upgrade

#Upgrade additional distro packages
sudo apt dist-upgrade


#Install build tools
sudo apt-get install build-essential procps curl file git zip unzip


#Add variables to .profile
echo -n '
# Windows variables
export cDRIVE="/mnt/c"
export WINHOME="/mnt/c/Users/$USER"
' >> $HOME/.profile


#Git configuration
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com


#Make directory for Github and gists
mkdir -p $HOME/Github/gist
#Clone git repository from this script
git clone https://github.com/shyguyCreate/install-Scripts.git $HOME/Github/install-Scripts


#Install ohmyposh
mkdir -p $HOME/.local/bin && export PATH="$HOME/.local/bin:$PATH"
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin


#Write oh-my-posh lines to .profile
echo -n '
#OH-MY-POSH
eval "$(oh-my-posh init bash --config "$HOME/Github/install-Scripts/share/ohmyposh.omp.json")"
alias oh-my-posh-Update="curl -s https://ohmyposh.dev/install.sh | bash -s"
' >> $HOME/.profile


#Update Ubuntu distro
sudo do-release-upgrade
