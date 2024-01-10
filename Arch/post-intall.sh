#!/bin/sh

# https://wiki.archlinux.org/title/NetworkManager#Usage
# Connect to wireless internet
nmtui
# or
nmcli device wifi list
nmcli device wifi connect _SSID_internet_name_ password _password_
nmcli connection show
nmcli device
# Check internet connection
ping archlinux.org

# https://wiki.archlinux.org/title/PC_speaker#Globally
# Remove beep
rmmod pcspkr snd_pcsp
echo 'blacklist pcspkr' >> /etc/modprobe.d/nobeep.conf
echo 'blacklist snd_pcsp' >> /etc/modprobe.d/nobeep.conf

# https://wiki.archlinux.org/title/sudo#Example_entries
# Allow wheel to run sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Update system
pacman -Syyu --noconfirm

# Install doas (alternative to sudo)
pacman -S --needed --noconfirm opendoas
# https://wiki.archlinux.org/title/Doas#Configuration
# Add config file to access root
echo 'permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel' > /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

#Install bash utilities
pacman -S --needed --noconfirm bash-completion bash-language-server

# Install zsh
pacman -S --needed --noconfirm zsh

# https://wiki.archlinux.org/title/Users_and_groups#User_management
# Add user
useradd -m -G wheel -s /usr/bin/zsh shyguy

# https://wiki.archlinux.org/title/Man_page#Installation
# https://wiki.archlinux.org/title/GNU#Texinfo
# Add manuals
pacman -S --needed --noconfirm man-db man-pages texinfo

# https://wiki.archlinux.org/title/PipeWire
# https://wiki.archlinux.org/title/PulseAudio#Graphical
# Add audio support and GUI
pacman -S --needed --noconfirm pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack pavucontrol

# https://wiki.archlinux.org/title/CUPS#Installation
# Add printer support
pacman -S --needed --noconfirm cups cups-pdf
# https://wiki.archlinux.org/title/CUPS#Socket_activation
# Enable/start cups
systemctl enable cups.socket
systemctl start cups.socket
# https://wiki.archlinux.org/title/CUPS#USB
# Add usb printer support
pacman -S --needed --noconfirm usbutils
# https://wiki.archlinux.org/title/CUPS#Network
# https://wiki.archlinux.org/title/Avahi#Installation
# Disable/stop built-in mDNS service
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved.service
# Add wireless printer support
pacman -S --needed --noconfirm avahi
# https://wiki.archlinux.org/title/Avahi#Hostname_resolution
# Enable/start avahi
pacman -S --needed --noconfirm nss-mdns
systemctl enable avahi-daemon.service
systemctl start avahi-daemon.service
sed -i 's/hosts: mymachines resolve \[!UNAVAIL=return\] files myhostname dns/hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns/' /etc/nsswitch.conf
# https://wiki.archlinux.org/title/CUPS#GUI_applications
#Install GUI for printer
pacman -S --needed --noconfirm system-config-printer

# https://wiki.archlinux.org/title/docker#Installation
#Install docker (engine, compose, and buildx)
pacman -S --needed --noconfirm docker docker-compose docker-buildx
# Enable/start docker daemon
systemctl enable docker.socket
systemctl start docker.socket
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
# Run docker as a non-root user
groupadd docker
usermod -aG docker shyguy

# Install git
pacman -S --needed --noconfirm git
# Set main initial branch for git
git config --global init.defaultBranch main

# Add user password
passwd shyguy
