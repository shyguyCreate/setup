#Update system
sudo pacman -Syyu

#Install doas (alternative to sudo)
sudo pacman -S opendoas
#Add config file to access root
echo "permit :wheel" | sudo tee -a /etc/doas.conf > /dev/null


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


#Install git gh and set username email and initial branch
sudo pacman -S git github-cli --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com
git config --global init.defaultBranch main


#Make directory for Github and gists
mkdir -p $HOME/Github/gist
#Clone git repository from this script
git clone https://github.com/shyguyCreate/install-Scripts.git $HOME/Github/install-Scripts


#Install GUI for printer
sudo pacman -S system-config-printer --needed
#Add printer support for USB
sudo pacman -S cups cups-pdf --needed
sudo systemctl enable --now cups
#Add wireless printer support
sudo pacman -S avahi nss-mdns --needed
sudo systemctl enable avahi-daemon.service
#Enable Avahi support for hostname resolution
sudo patch --no-backup-if-mismatch --merge -sd /etc < $HOME/Github/install-Scripts/Manjaro/nsswitch.conf.diff


#Install zsh and plugins
sudo pacman -S zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search --needed
#Change default shell to zsh
[[ $(basename $SHELL) != "zsh" ]] && chsh -s $(which zsh)

#Install powerlevel10k and configure it
sudo pacman -S zsh-theme-powerlevel10k --needed
patch -sd $HOME < $HOME/Github/install-Scripts/Manjaro/.zshrc.diff
cp $HOME/Github/install-Scripts/share/.p10k.zsh $HOME
patch -sd $HOME < $HOME/Github/install-Scripts/share/.p10k.zsh.diff


#Clone, install and add alias to update vscodium
git clone https://gist.github.com/06679a4028cb574a946d026c713efa37.git $HOME/Github/gist/vscodiumInstaller
source $HOME/Github/gist/vscodiumInstaller/vscodiumInstaller.sh
echo 'alias codiumUpdate="source $HOME/Github/gist/vscodiumInstaller/vscodiumInstaller.sh"' >> $HOME/.zshrc

#Clone, install and add alias to update pwsh
git clone https://gist.github.com/86b8b157c90d6b2ebcb1eb98c4a701e8.git $HOME/Github/gist/pwshInstaller
source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh
echo 'alias pwshUpdate="source $HOME/Github/gist/pwshInstaller/pwshInstaller.sh"' >> $HOME/.zshrc

#Clone, install and add alias to update meslo-fonts
git clone https://gist.github.com/3174d5463d717f7d7a8c67e45cd914be.git $HOME/Github/gist/meslofontsInstaller
source $HOME/Github/gist/meslofontsInstaller/meslofontsInstaller.sh
echo 'alias mesloUpdate="source $HOME/Github/gist/meslofontsInstaller/meslofontsInstaller.sh"' >> $HOME/.zshrc

#Clone, install and add alias to update zoom
git clone https://gist.github.com/fdec7db1dfe9588c0c3d735d142fcf41.git $HOME/Github/gist/zoomInstaller
source $HOME/Github/gist/zoomInstaller/zoomInstaller.sh
echo 'alias zoomUpdate="source $HOME/Github/gist/zoomInstaller/zoomInstaller.sh"' >> $HOME/.zshrc


#Install Powershell modules
pwsh -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"


#Install ohmyposh
mkdir -p $HOME/.local/bin && curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin


#Create directory for pwsh profile folder
mkdir -p $HOME/.config/powershell
#Create symbolic link of profile.ps1 to powershell profile folder
ln -sf $HOME/Github/install-Scripts/share/profile.ps1 $HOME/.config/powershell/profile.ps1
#Create symbolic link of ohmyposh to powershell profile folder
ln -sf $HOME/Github/install-Scripts/share/ohmyposh.omp.json $HOME/.config/powershell/ohmyposh.omp.json
