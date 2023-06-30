#!/bin/sh

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
sudo pacman -S git --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com
git config --global init.defaultBranch main


#Make directory for Github and gists
mkdir -p "$HOME/Github/gist"
#Clone git repository from this script
installScripts="$HOME/Github/install-Scripts"
git clone https://github.com/shyguyCreate/install-Scripts.git "$installScripts"


#Install GUI for printer
sudo pacman -S system-config-printer --needed
#Add printer support for USB
sudo pacman -S cups cups-pdf --needed
sudo systemctl enable --now cups
#Add wireless printer support
sudo pacman -S avahi nss-mdns --needed
sudo systemctl enable avahi-daemon.service
#Enable Avahi support for hostname resolution
sudo patch --no-backup-if-mismatch --merge -sd /etc < "$installScripts/Arch-based/nsswitch.conf.diff"


#Install zsh and plugins
sudo pacman -S zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search --needed
#Change default shell to zsh
[ "$(basename "$SHELL")" != "zsh" ] && chsh -s "$(which zsh)"

#Install powerlevel10k and configure it
sudo pacman -S zsh-theme-powerlevel10k --needed
patch -sd "$HOME" < "$installScripts/Manjaro/.zshrc.diff"
cp "$installScripts/share/.p10k.zsh" "$HOME"
patch -sd "$HOME" < "$installScripts/share/.p10k.zsh.diff"


#Clone install-Programs repo
installPrograms="$HOME/Github/install-Programs"
git clone https://github.com/shyguyCreate/install-Programs.git "$installPrograms"

#Install all programs inside git repo
for script in "$installPrograms"/*; do
    chmod +x "$script"; "$script"
done


#Install Powershell modules
pwsh -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"

#Create directory for pwsh profile folder
mkdir -p "$HOME/.config/powershell"
#Create symbolic link of profile.ps1 to powershell profile folder
ln -sf "$installScripts/share/profile.ps1" "$HOME/.config/powershell/profile.ps1"
#Create symbolic link of ohmyposh to powershell profile folder
ln -sf "$installScripts/share/ohmyposh.omp.json" "$HOME/.config/powershell/ohmyposh.omp.json"
