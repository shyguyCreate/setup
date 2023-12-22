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

#Install firefox with AAC and MP3 support
sudo pacman -S firefox gstreamer --needed

#Install office suite
sudo pacman -S onlyoffice-desktopeditors --needed

#Install password manager
sudo pacman -S keepassxc --needed

#Install image and video editor
sudo pacman -S gimp shotcut --needed

#Install media player and recorder
sudo pacman -S vlc obs-studio --needed

#Install docker (engine, compose, and buildx)
sudo pacman -S docker docker-compose docker-buildx --needed

#Enable and start docker daemon
sudo systemctl enable docker.socket
sudo systemctl start docker.socket

#Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker "$USER"

#Function to clone a repo or update it with pull
git_clone_or_pull_repo()
{
    local repoDir="$1"
    local url="$2"
    if [ ! -d "$repoDir/.git" ]; then
        git clone "$url" "$repoDir"
    else
        git -C "$repoDir" pull -q
    fi
}

#Make directory for Github and gists
mkdir -p "$HOME/Github/gist"

#Install git
sudo pacman -S git --needed
#Set main initial branch for git
git config --global init.defaultBranch main

#Clone git repository of this script
machineSetup="$HOME/Github/machine-Setup"
git_clone_or_pull_repo "$machineSetup" https://github.com/shyguyCreate/machine-Setup.git

#Install GUI for printer
sudo pacman -S system-config-printer --needed
#Add printer support for USB
sudo pacman -S cups cups-pdf --needed
sudo systemctl enable cups
sudo systemctl start cups
#Add wireless printer support
sudo pacman -S avahi nss-mdns --needed
sudo systemctl enable avahi-daemon.service
#Enable Avahi support for hostname resolution
sudo patch --no-backup-if-mismatch --merge -sd /etc < "$machineSetup/share/nsswitch.conf.diff"

#Install zsh
sudo pacman -S zsh --needed
#Configure zsh
. "$machineSetup/zsh/zsh-Setup.sh"

#Clone gh-pkgs repo
gh_pkgs="$HOME/Github/gh-pkgs"
git_clone_or_pull_repo "$gh_pkgs" https://github.com/shyguyCreate/gh-pkgs.git

#Install programs with gh-pkgs
"$gh_pkgs/gh-pkgs.sh" install codium gh mesloLGS oh-my-posh pwsh shellcheck shfmt

#Clone gist repo of codium settings
codiumSettings="$HOME/Github/gist/codium-Settings"
git_clone_or_pull_repo "$codiumSettings" https://gist.github.com/efcf9345431ca9e4d3eb2faaa6b71564.git

#Configure codium through script
"$codiumSettings/.config.sh"

#Configure pwsh
pwsh -NoProfile -File "$machineSetup/pwsh/pwsh-Setup.ps1"

#Remove git clone/pull function
unset -f git_clone_or_pull_repo
