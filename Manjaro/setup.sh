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

#Install image and video editor
sudo pacman -S gimp shotcut --needed

#Install media player and recorder
sudo pacman -S vlc obs-studio --needed

#Function to clone a repo or update it with pull
git_clone_or_pull_repo()
{
    repoDir="$1"
    url="$2"
    if [ ! -d "$repoDir/.git" ]; then
        git clone "$url" "$repoDir"
    else
        git -C "$repoDir" pull -q
    fi
}

#Install git gh and set username email and initial branch
sudo pacman -S git --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com
git config --global init.defaultBranch main

#Make directory for Github and gists
mkdir -p "$HOME/Github/gist"
#Clone git repository of this script
machineSetup="$HOME/Github/machine-Setup"
git_clone_or_pull_repo "$machineSetup" https://github.com/shyguyCreate/machine-Setup.git

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
git_clone_or_pull_repo "$installPrograms" https://github.com/shyguyCreate/install-Programs.git

#Install all programs inside git repo
for script in "$installPrograms"/*; do
    "$script"
done

#Clone gist repo of codium settings
codiumSettings="$HOME/Github/gist/codium-Settings"
git_clone_or_pull_repo "$codiumSettings" https://gist.github.com/efcf9345431ca9e4d3eb2faaa6b71564.git

#Configure codium through script
"$codiumSettings/.config.sh"

#Configure pwsh
pwsh -NoProfile -File "$machineSetup/pwsh/pwsh-Setup.ps1"

#Remove git clone/pull function
unset -f git_clone_or_pull_repo
