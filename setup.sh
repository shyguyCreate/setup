#!/bin/sh

# Script variables
NEWUSER="shyguy"

# https://wiki.archlinux.org/title/PC_speaker#Globally
# Remove beep sound
lsmod | grep -wq pcspkr && rmmod pcspkr
lsmod | grep -wq snd_pcsp && rmmod snd_pcsp
echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf
echo 'blacklist snd_pcsp' >> /etc/modprobe.d/nobeep.conf

# https://wiki.archlinux.org/title/Power_management#ACPI_events
# Ignore power/suspend/reboot/hibernate buttons
sudo sed -i 's/^#*HandlePowerKey=.*/HandlePowerKey=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/^#*HandleRebootKey=.*/HandleRebootKey=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/^#*HandleSuspendKey=.*/HandleSuspendKey=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/^#*HandleHibernateKey=.*/HandleHibernateKey=ignore/' /etc/systemd/logind.conf

# https://wiki.archlinux.org/title/Microcode
# Install processor microcode update
grep -q AuthenticAMD /proc/cpuinfo && pacman -S --needed --noconfirm amd-ucode
grep -q GenuineIntel /proc/cpuinfo && pacman -S --needed --noconfirm intel-ucode

# https://wiki.archlinux.org/title/Sudo#Example_entries
# Allow wheel group to run sudo without password
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) ALL/# %wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# https://wiki.archlinux.org/title/Users_and_groups#User_management
# Add new user
id -u "$NEWUSER" > /dev/null 2>&1 || useradd -m -G wheel "$NEWUSER"

# Save user HOME variable
# shellcheck disable=SC2016
USERHOME="$(runuser -l "$NEWUSER" -c 'echo $HOME')"

# https://github.com/Jguer/yay#Installation
# Install yay from AUR
pacman -S --needed --noconfirm git base-devel
USERYAYCACHE="$USERHOME/.cache/yay/yay-bin"
[ -d "$USERYAYCACHE" ] && [ "$(git -C "$USERYAYCACHE" config --get remote.origin.url 2> /dev/null)" != "https://aur.archlinux.org/yay-bin.git" ] && rm -rf "$USERYAYCACHE"
[ ! -d "$USERYAYCACHE" ] && runuser -l "$NEWUSER" -c "mkdir -p '$USERYAYCACHE' && git -C '$USERYAYCACHE' clone https://aur.archlinux.org/yay-bin.git ."
runuser -l "$NEWUSER" -c "cd '$USERYAYCACHE' && makepkg -si --needed --noconfirm"

# Install packages inside csv file
curl -s -o /tmp/pkgs.csv.tmp https://raw.githubusercontent.com/shyguyCreate/setup/main/pkgs.csv
tail -n +2 /tmp/pkgs.csv.tmp | cut -d ',' -f -2 > /tmp/pkgs.csv
while IFS=, read -r tag program; do
    case "$tag" in
        "A") yay -S --needed --noconfirm $program ;;
        *) pacman -S --needed --noconfirm $program ;;
    esac
done < /tmp/pkgs.csv

# https://wiki.archlinux.org/title/Command-line_shell#Changing_your_default_shell
# Change new user default shell
[ "$(getent passwd "$NEWUSER" | awk -F: '{print $NF}')" = "/usr/bin/zsh" ] || chsh -s /usr/bin/zsh "$NEWUSER" > /dev/null

# https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
# Change zsh dotfiles to ~/.config/zsh
# shellcheck disable=SC2016
echo 'export ZDOTDIR=$HOME/.config/zsh' > /etc/zsh/zshenv

# https://git-scm.com/docs/git-config#Documentation/git-config.txt-initdefaultBranch
# Set main as the default branch name
git config --system init.defaultBranch main

# Make directory for Github and gists
runuser -l "$NEWUSER" -c "mkdir -p '$USERHOME/Github/gist'"

# Clone git repository of this script
setupREPO="$USERHOME/Github/setup"
runuser -l "$NEWUSER" -c "git clone https://github.com/shyguyCreate/setup.git '$setupREPO'"

# Clone dotfiles repository
dotfilesREPO="$USERHOME/Github/dotfiles"
runuser -l "$NEWUSER" -c "git clone https://github.com/shyguyCreate/dotfiles.git '$dotfilesREPO'"
# Copy dotfiles to user home directory
[ -f "$dotfilesREPO/push.sh" ] && runuser -l "$NEWUSER" -c "chmod +x '$dotfilesREPO/push.sh' && '$dotfilesREPO/push.sh'"

# Clone zsh plugins in ~/.config/zsh
[ -f "$USERHOME/.config/zsh/.zplugins" ] && runuser -l "$NEWUSER" -c ". '$USERHOME/.config/zsh/.zplugins'"

# Install mesloLGS fonts for powerlevel10k
runuser -l "$NEWUSER" -c "yay -S --needed --noconfirm ttf-meslo-nerd-font-powerlevel10k"

# https://wiki.archlinux.org/title/Doas#Configuration
# Add config file to access root
echo 'permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel' > /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

# https://wiki.archlinux.org/title/Xorg#Driver_installation
# Install intel video drivers if needed
lspci -v | grep -A1 -e VGA -e 3D | grep -qi intel && pacman -S --needed --noconfirm xf86-video-intel mesa vulkan-intel

# https://wiki.archlinux.org/title/LightDM#Enabling_LightDM
# Enable lightdm
systemctl enable lightdm.service

# Install shell script analysis tool
runuser -l "$NEWUSER" -c "yay -S --needed --noconfirm shellcheck-bin"

# https://wiki.archlinux.org/title/Cron#Activation_and_autostart
# Enable cron service
systemctl enable cronie.service

# https://wiki.archlinux.org/title/List_of_applications/Utilities#Integrated_development_environments
# Install vscodium
runuser -l "$NEWUSER" -c "yay -S --needed --noconfirm vscodium-bin"
# Configure vscodium with scripts
runuser -l "$NEWUSER" -c "curl -s --output-dir /tmp -O https://gist.githubusercontent.com/shyguyCreate/4ab7e85477f6bcd2dd58aad3914861a8/raw/code-setup"
runuser -l "$NEWUSER" -c "chmod +x /tmp/code-setup && /tmp/code-setup -c codium"

# https://wiki.archlinux.org/title/List_of_applications/Documents#Office_suites
# Install onlyoffice desktop
runuser -l "$NEWUSER" -c "yay -S --needed --noconfirm onlyoffice-bin"

# Enable docker daemon
systemctl enable docker.socket
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
# Run docker as a non-root user
getent group docker > /dev/null 2>&1 || groupadd docker
id -nG "$NEWUSER" | grep -qw docker || usermod -aG docker "$NEWUSER"

# https://wiki.archlinux.org/title/CUPS#Socket_activation
# Enable cups socket
systemctl enable cups.socket
# https://wiki.archlinux.org/title/CUPS#Printer_discovery
# Disable built-in mDNS service
systemctl disable systemd-resolved.service
# https://wiki.archlinux.org/title/Avahi#Hostname_resolution
# Enable avahi with hostname resolution
systemctl enable avahi-daemon.service
sed -i 's/hosts: mymachines resolve/hosts: mymachines mdns_minimal [NOTFOUND=return] resolve/' /etc/nsswitch.conf

# https://wiki.archlinux.org/title/Sudo#Example_entries
# Allow wheel to run sudo entering password
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
