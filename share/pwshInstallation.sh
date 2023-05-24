#Make directory for Github and gists
mkdir -p $HOME/Github/gist
#Clone pwshInstaller script from gist
git clone https://gist.github.com/86b8b157c90d6b2ebcb1eb98c4a701e8.git $HOME/Github/gist/pwshInstaller
#Clone ohmyposh config from gist
git clone https://gist.github.com/387ff25579b25bff63a6bc1a7635be27.git $HOME/Github/gist/ohmyposh


#Install powershell from script
source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh
#Add alias to update pwsh
echo 'alias pwshUpdate="source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh"' >> $HOME/.zshrc


#Create directory for pwsh profile folder
mkdir -p $HOME/.config/powershell
#Create symbolic link of profile.ps1 to powershell profile folder
ln -s $HOME/Github/installation-Scripts/share/profile.ps1 $HOME/.config/powershell/profile.ps1
#Create symbolic link of ohmyposh to powershell profile folder
ln -s $HOME/Github/gist/ohmyposh/ohmyposhCustome.omp.json $HOME/.config/powershell/ohmyposhCustome.omp.json


#Install Powershell modules
pwsh -NoProfile -c "& { Install-Module -Name Terminal-Icons -Scope CurrentUser -Force }"
pwsh -NoProfile -c "& { Install-Module -Name PSReadLine -Scope CurrentUser -Force }"


#Create directory for ohmyposh installation
mkdir -p $HOME/.local/bin
#Install ohmyposh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin
