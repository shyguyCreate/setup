#!/bin/sh

#Update system
sudo pacman -Syyu

#Install doas (alternative to sudo)
sudo pacman -S opendoas
#Add config file to access root
[ -f /etc/doas.conf ] && grep -qxF "permit :wheel" /etc/doas.conf || echo "permit :wheel" | sudo tee -a /etc/doas.conf > /dev/null


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
sudo pacman -S git --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com
git config --global init.defaultBranch main


#Make directory for Github and gists
mkdir -p "$HOME/Github/gist"
#Clone git repository from this script
machineSetup="$HOME/Github/machine-Setup"
git clone https://github.com/shyguyCreate/machine-Setup.git "$machineSetup"


#Install GUI for printer
sudo pacman -S system-config-printer --needed
#Add printer support for USB
sudo pacman -S cups cups-pdf --needed
sudo systemctl enable --now cups
#Add wireless printer support
sudo pacman -S avahi nss-mdns --needed
sudo systemctl enable avahi-daemon.service
#Enable Avahi support for hostname resolution
sudo patch --no-backup-if-mismatch --merge -sd /etc < "$machineSetup/share/nsswitch.conf.diff"


#Install zsh
sudo pacman -S zsh --needed
#And uninstall plugins
sudo pacman -Rns manjaro-zsh-config zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-theme-powerlevel10k

#Configure zsh
. "$machineSetup/zsh/zsh-Setup.sh"

#Clone install-Programs repo
installPrograms="$HOME/Github/install-Programs"
git clone https://github.com/shyguyCreate/install-Programs.git "$installPrograms"

#Install all programs inside git repo
for script in "$installPrograms"/*; do
    chmod +x "$script"; "$script"
done


#Configure pwsh
pwsh -NoProfile -File "$machineSetup/pwsh/pwsh-Setup.ps1"
