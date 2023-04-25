#!/bin/bash

#Get update packages
sudo apt update

#Upgrade packages
sudo apt upgrade

#Upgrade additional distro packages
sudo apt dist-upgrade

#Update Ubuntu distro
sudo do-release-upgrade


#Add variables to .bashrc
echo '
#Variables
export WINHOME="/mnt/c/Users/$USER"
' >> $HOME/.bashrc


#Git configuration
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com


#Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#Write brew lines to .bashrc
echo '
#BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#BREW COMPLETION
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi
' >> ~/.bashrc
#Use brew in the same session without reloading
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


#OH-MY-POSH
brew install go jandedobbeleer/oh-my-posh/oh-my-posh
#Write oh-my-posh lines to .bashrc
echo '
#OH-MY-POSH
eval "$(oh-my-posh init bash --config "$/mnt/c/Users/$USER/Github/gist/ohmyposh/ohmyposhCustome.omp.json")"
' >> ~/.bashrc
