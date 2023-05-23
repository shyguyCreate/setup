#Make directory for Github and gists
mkdir -p $HOME/Github/gist
#Clone pwshInstaller script from gist
git clone https://gist.github.com/86b8b157c90d6b2ebcb1eb98c4a701e8.git $HOME/Github/gist/pwshInstaller
#Clone ohmyposh config from gist
git clone https://gist.github.com/387ff25579b25bff63a6bc1a7635be27.git $HOME/Github/gist/ohmyposh


#Install powershell from script
source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh


#Create directory for pwsh profile folder
mkdir -p $HOME/.config/powershell
#Create symbolic link of profile.ps1 to powershell profile folder
ln -s $HOME/Github/installation-Scripts/share/profile.ps1 $HOME/.config/powershell/profile.ps1
#Create symbolic link of ohmyposh to powershell profile folder
ln -s $HOME/Github/gist/ohmyposh/ohmyposhCustome.omp.json $HOME/.config/powershell/ohmyposhCustome.omp.json


#Install Powershell modules
/usr/bin/pwsh -NoProfile -c "& { Install-Module -Name Terminal-Icons -Scope CurrentUser -Force }"
/usr/bin/pwsh -NoProfile -c "& { Install-Module -Name PSReadLine -Scope CurrentUser -Force }"


#Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#Write brew lines to .zshrc
echo '
#BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#BREW COMPLETION
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi
' >> $HOME/.zshrc
#Use brew in the same session without reloading
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

#Install go ohmyposh
brew install go jandedobbeleer/oh-my-posh/oh-my-posh


#Add alias to update zoom meslo-fonts pwsh
echo '
alias pwshUpdate="source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh"
' >> $HOME/.zshrc
