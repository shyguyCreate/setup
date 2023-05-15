#Update system
sudo pacman -Syu


#Install GUI for printer
sudo pacman -S system-config-printer --needed
#Add printer support for USB
sudo pacman -S cups cups-pdf --needed
sudo systemctl enable --now cups
#Add wireless printer support
sudo pacman -S avahi nss-mdns --needed
sudo systemctl enable avahi-daemon.service
#Enable Avahi support for hostname resolution
echo '\nEdit /etc/nsswitch.conf and change the hosts line to look like this:
"hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns"'


#Install git and add user name and email
sudo pacman -S git --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com


#Make directory for Github and gists
mkdir -p $HOME/Github/gist
#Clone git repository from this script
git clone https://github.com/shyguyCreate/installation-Setup.git $HOME/Github/installation-Setup
#Clone pwshInstaller script from gist
git clone https://gist.github.com/86b8b157c90d6b2ebcb1eb98c4a701e8.git $HOME/Github/gist/pwshInstaller
#Clone ohmyposh config from gist
git clone https://gist.github.com/387ff25579b25bff63a6bc1a7635be27.git $HOME/Github/gist/ohmyposh
#Clone Meslo NF Installer script from gist
git clone https://gist.github.com/3174d5463d717f7d7a8c67e45cd914be.git $HOME/Github/gist/meslofontsInstaller
#Clone zoomInstaller script from gist
git clone https://gist.github.com/fdec7db1dfe9588c0c3d735d142fcf41.git $HOME/Github/gist/zoomInstaller


#Install zsh
sudo pacman -S zsh --needed
#Install powerlevel10k
sudo pacman -S zsh-theme-powerlevel10k --needed && echo 'Run "p10k configure" to create new prompt'
#Install zsh plugins
sudo pacman -S zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search --needed


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

#Install go gh ohmyposh
brew install go gh jandedobbeleer/oh-my-posh/oh-my-posh


#Install snap
sudo pacman -S snapd --needed
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

#Install vscode
sudo snap install code --classic
 

#Install yay to check zoom updates and packages no longer in repo
sudo pacman -S yay --needed

#Install bash-language-server for completion inside text editors
sudo pacman -S bash-completion bash-language-server --needed

#Install firefox with ACC support and chromium
sudo pacman -S firefox gstreamer chromium --needed

#Install office suite
sudo pacman -S onlyoffice-desktopeditors --needed

#Install image and video editor
sudo pacman -S gimp shotcut --needed

#Install media player and recorder
sudo pacman -S vlc obs-studio --needed


#Install Meslo Nerd Fonts from script
source $HOME/Github/gist/meslofontsInstaller/meslofontsInstaller.sh

#Install zoom from script
source $HOME/Github/gist/zoomInstaller/zoomInstaller.sh

#Install powershell from script
source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh


#Create directory for pwsh profile folder
mkdir -p $HOME/.config/powershell
#Create symbolic link of profile.ps1 to powershell profile folder
ln -s $HOME/Github/installation-Setup/share/profile.ps1 $HOME/.config/powershell/profile.ps1
#Create symbolic link of ohmyposh to powershell profile folder
ln -s $HOME/Github/gist/ohmyposh/ohmyposhCustome.omp.json $HOME/.config/powershell/ohmyposhCustome.omp.json

#Install Powershell modules
/usr/bin/pwsh -NoProfile -c "& { Install-Module -Name Terminal-Icons -Scope CurrentUser -Force }"
/usr/bin/pwsh -NoProfile -c "& { Install-Module -Name PSReadLine -Scope CurrentUser -Force }"


#Add alias to update zoom meslo-fonts pwsh
echo '
alias \
  zoomUpdate="source $HOME/Github/gist/zoomInstaller/zoomInstaller.sh" \
  mesloUpdate="source $HOME/Github/gist/meslofontsInstaller/meslofontsInstaller.sh" \
  pwshUpdate="source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh"
' >> $HOME/.zshrc
