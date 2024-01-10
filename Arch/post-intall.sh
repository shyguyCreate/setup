#!/bin/sh

# https://wiki.archlinux.org/title/NetworkManager#Usage
# Connect to wireless internet
nmcli device wifi list
nmcli device wifi connect _SSID_internet_name_ password _password_
nmcli connection show
nmcli device
# Check internet connection
ping archlinux.org

# https://wiki.archlinux.org/title/Man_page#Installation
# https://wiki.archlinux.org/title/GNU#Texinfo
# Add manuals
pacman -S --needed --noconfirm man-db man-pages texinfo

# https://wiki.archlinux.org/title/PipeWire
# https://wiki.archlinux.org/title/PulseAudio#Graphical
# Add audio support and GUI
pacman -S --needed --noconfirm pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack pavucontrol

# https://wiki.archlinux.org/title/PC_speaker#Globally
# Remove beep
rmmod pcspkr snd_pcsp
echo 'blacklist pcspkr' >> /etc/modprobe.d/nobeep.conf
echo 'blacklist snd_pcsp' >> /etc/modprobe.d/nobeep.conf

# Allow wheel to run sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
