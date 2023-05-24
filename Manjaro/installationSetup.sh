#Update system
sudo pacman -Syyu

#Install GUI for printer
sudo pacman -S system-config-printer --needed
#Add printer support for USB
sudo pacman -S cups cups-pdf --needed
sudo systemctl enable --now cups
#Add wireless printer support
sudo pacman -S avahi nss-mdns --needed
sudo systemctl enable avahi-daemon.service
#Enable Avahi support for hostname resolution
echo -e '\nEdit /etc/nsswitch.conf and change the hosts line to look like this:
"hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns"'


#Install git and add user name and email
sudo pacman -S git github-cli --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com


#Make directory for Github and gists
mkdir -p $HOME/Github/gist
#Clone git repository from this script
git clone https://github.com/shyguyCreate/installation-Scripts.git $HOME/Github/installation-Scripts
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


#Install yay to check updates for packages installed manually
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
#Add alias to update meslo-fonts
echo 'alias mesloUpdate="source $HOME/Github/gist/meslofontsInstaller/meslofontsInstaller.sh"' >> $HOME/.zshrc

#Install zoom from script
source $HOME/Github/gist/zoomInstaller/zoomInstaller.sh
#Add alias to update zoom
echo 'alias zoomUpdate="source $HOME/Github/gist/zoomInstaller/zoomInstaller.sh"' >> $HOME/.zshrc
