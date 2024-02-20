#!/bin/sh

# Install important packages
pacman -S --needed --noconfirm base-devel linux-headers

# https://wiki.archlinux.org/title/Installation_guide#Boot_loader
# https://wiki.archlinux.org/title/GRUB#Installation
pacman -S --needed --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# Select default option after N seconds
sed -i 's/GRUB_TIMEOUT=./GRUB_TIMEOUT=2/' /etc/default/grub
# https://wiki.archlinux.org/title/GRUB#Generate_the_main_configuration_file
grub-mkconfig -o /boot/grub/grub.cfg

# https://wiki.archlinux.org/title/NetworkManager#Installation
# Add network manager and GUI
pacman -S --needed --noconfirm networkmanager network-manager-applet
systemctl enable NetworkManager

# https://wiki.archlinux.org/title/broadcom_wireless#Driver_selection
# Check if Broadcom drivers are needed
[ -n "$(lspci -d 14e4:)" ] && pacman -S --needed --noconfirm broadcom-wl-dkms

# https://wiki.archlinux.org/title/Installation_guide#Time
ln -sf /usr/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc

# https://wiki.archlinux.org/title/Installation_guide#Localization
sed -i 's/^#en_US/en_US/g' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=la-latin1' > /etc/vconsole.conf

# https://wiki.archlinux.org/title/Installation_guide#Network_configuration
echo 'arch' > /etc/hostname

# https://wiki.archlinux.org/title/PC_speaker#Globally
# Remove beep
rmmod pcspkr snd_pcsp
echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf
echo 'blacklist snd_pcsp' >> /etc/modprobe.d/nobeep.conf

# https://wiki.archlinux.org/title/Doas#Installation
# Install doas (alternative to sudo)
pacman -S --needed --noconfirm opendoas
# https://wiki.archlinux.org/title/Doas#Configuration
# Add config file to access root
echo 'permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel' > /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

# Install bash utilities
pacman -S --needed --noconfirm bash-completion bash-language-server

# Install zsh
pacman -S --needed --noconfirm zsh
# https://wiki.archlinux.org/title/XDG_Base_Directory#Hardcoded
# Change zsh dotfiles to ~/.config/zsh
echo "export ZDOTDIR=\$HOME/.config/zsh" > /etc/zsh/zshenv

# https://wiki.archlinux.org/title/Users_and_groups#User_management
# Add new user
useradd -m -G wheel -s /usr/bin/zsh shyguy

# https://wiki.archlinux.org/title/Sudo#Example_entries
# Allow wheel to run sudo without password
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) ALL/# %wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Save user HOME
HOME_user="$(runuser -l shyguy -c 'echo "$HOME"')"

# Install zip compression and decompression
pacman -S --needed --noconfirm zip unzip

# https://wiki.archlinux.org/title/Man_page#Installation
# https://wiki.archlinux.org/title/GNU#Texinfo
# Install manuals
pacman -S --needed --noconfirm man-db man-pages texinfo

# https://wiki.archlinux.org/title/PipeWire
# Add audio support
pacman -S --needed --noconfirm pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack
# https://wiki.archlinux.org/title/PulseAudio#Graphical
# Install GUI for audio mixer
pacman -S --needed --noconfirm pavucontrol

# https://wiki.archlinux.org/title/Xorg#Installation
# Install Xorg
pacman -S --needed --noconfirm xorg-server
# https://wiki.archlinux.org/title/Xorg#Driver_installation
# Install intel video drivers
lspci -v | grep -A1 -e VGA -e 3D | grep -qi intel && pacman -S --needed --noconfirm xf86-video-intel mesa vulkan-intel
# https://wiki.archlinux.org/title/Xorg#Running
# https://wiki.archlinux.org/title/Xinit#Installation
# Add starx
pacman -S --needed --noconfirm xorg-init

# https://wiki.archlinux.org/title/Xfce#Installation
pacman -S --needed --noconfirm \
    exo \
    garcon \
    thunar \
    thunar-volman \
    tumbler \
    xfce4-panel \
    xfce4-power-manager \
    xfce4-session \
    xfce4-settings \
    xfce4-terminal \
    xfconf \
    xfdesktop \
    xfwm4
pacman -S --needed --noconfirm \
    mousepad \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    xfce4-notifyd
# https://wiki.archlinux.org/title/Xfce#Starting
# https://wiki.archlinux.org/title/Xinit#xinitrc
runuser -l shyguy -c "echo 'exec startxfce4' > '$HOME_user/.xinitrc'"

# https://wiki.archlinux.org/title/LightDM#Installation
# Install lightdm
pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter
# https://wiki.archlinux.org/title/LightDM#Enabling_LightDM
# Enable lightdm
systemctl enable lightdm.service
# https://wiki.archlinux.org/title/LightDM#Optional_configuration_and_tweaks
# Install lightdm GUI
pacman -S --needed --noconfirm lightdm-gtk-greeter-settings

# https://wiki.archlinux.org/title/List_of_applications/Security#Screen_lockers
# Install screen lockers
pacman -S --needed --noconfirm light-locker

# https://wiki.archlinux.org/title/CUPS#Installation
# Add printer support
pacman -S --needed --noconfirm cups cups-pdf
# https://wiki.archlinux.org/title/CUPS#Socket_activation
# Enable cups socket
systemctl enable cups.socket
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
# Enable avahi
pacman -S --needed --noconfirm nss-mdns
systemctl enable avahi-daemon.service
sed -i 's/hosts: mymachines resolve \[!UNAVAIL=return\] files myhostname dns/hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns/' /etc/nsswitch.conf
# https://wiki.archlinux.org/title/CUPS#GUI_applications
# Install GUI for printer
pacman -S --needed --noconfirm system-config-printer

# https://wiki.archlinux.org/title/Docker#Installation
# Install docker (engine, compose, and buildx)
pacman -S --needed --noconfirm docker docker-compose docker-buildx
# Enable docker daemon
systemctl enable docker.socket
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
# Run docker as a non-root user
groupadd docker
usermod -aG docker shyguy

# Install git and gh
pacman -S --needed --noconfirm git github-cli
# https://git-scm.com/docs/git-config#Documentation/git-config.txt---system
# https://git-scm.com/docs/git-config#Documentation/git-config.txt-initdefaultBranch
# Set main as the default branch name
git config --system init.defaultBranch main

# Make directory for Github and gists
runuser -l shyguy -c "mkdir -p '$HOME_user/Github/gist'"

# Clone git repository of this script
machineSetup="$HOME_user/Github/machine-Setup"
runuser -l shyguy -c "git clone https://github.com/shyguyCreate/machine-Setup.git '$machineSetup'"

# Configure user environment
runuser -l shyguy -c "command cp -r '$machineSetup/.config' '$HOME_user'"
runuser -l shyguy -c "command cp -r '$machineSetup/.local' '$HOME_user'"

# Add zsh plugins
runuser -l shyguy -c ". '$HOME_user/.config/zsh/.zplugins'"

# Clone gh-pkgs repo
gh_pkgs="$HOME_user/Github/gh-pkgs"
runuser -l shyguy -c "git clone https://github.com/shyguyCreate/gh-pkgs.git '$gh_pkgs'"

# Install packages with gh-pkgs
runuser -l shyguy -c "'$gh_pkgs/gh-pkgs.sh' install codium mesloLGS shellcheck shfmt"

# Clone codium settings from gist
codiumSettings="$HOME_user/Github/gist/codium-Settings"
runuser -l shyguy -c "git clone https://gist.github.com/efcf9345431ca9e4d3eb2faaa6b71564.git '$codiumSettings'"

# Configure codium
runuser -l shyguy -c 'curl -s https://api.github.com/repos/foxundermoon/vs-shell-format/releases/latest | grep "\"browser_download_url.*/shell-format-.*\.vsix\"" | cut -d \" -f 4 | xargs curl -LOs'
runuser -l shyguy -c 'find . -name "shell-format-*.vsix" -exec codium --install-extension '{}' \; -exec rm -f '{}' \;'
runuser -l shyguy -c ". '$codiumSettings/.config.sh'"

# https://wiki.archlinux.org/title/redshift#Installation
# Install screen color temperature adjuster
pacman -S --needed --noconfirm redshift
# https://bbs.archlinux.org/viewtopic.php?id=177473https://bbs.archlinux.org/viewtopic.php?id=177473
# Fix redshift not autostarting
[ ! -f /usr/lib/systemd/user/redshift.service ] \
    || grep -q 'Environment=DISPLAY=:0' /usr/lib/systemd/user/redshift.service \
    || sed -i 's/\[Service\]/[Service]\nEnvironment=DISPLAY=:0/' /usr/lib/systemd/user/redshift.service
# https://wiki.archlinux.org/title/redshift#Autostart
# Enable redshift user unit service
runuser -l shyguy -c "systemctl --user enable redshift.service"

# https://github.com/Jguer/yay#Installation
# Install yay from AUR
runuser -l shyguy -c "cd '$HOME_user' && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --needed --noconfirm"
# Clean yay clone
[ -d "$HOME_user/yay" ] && rm -rf "$HOME_user/yay"

# Install onlyoffice desktop
runuser -l shyguy -c "yay -S --needed --noconfirm onlyoffice-bin"

# https://wiki.archlinux.org/title/File_manager_functionality#Mounting
# Add mount support for mobile devices
pacman -S --needed --noconfirm gvfs gvfs-mtp gvfs-gphoto2 gvfs-afc

# https://wiki.archlinux.org/title/Desktop_notifications
# Add support for desktop notifications
pacman -S --needed --noconfirm libnotify dunst adwaita-icon-theme

# https://wiki.archlinux.org/title/Keyboard_shortcuts#Xorg
# Install program to map keys
pacman -S --needed --noconfirm sxhkd
# https://wiki.archlinux.org/title/Sxhkd#Configuration
# Install KEYSYM reader
pacman -S --needed --noconfirm xorg-xev

# https://wiki.archlinux.org/title/List_of_applications/Internet#Web_browsers
# Install web browser
pacman -S --needed --noconfirm firefox

# https://wiki.archlinux.org/title/List_of_applications/Security#Password_managers
# Install password manager
pacman -S --needed --noconfirm keepassxc

# https://wiki.archlinux.org/title/List_of_applications/Multimedia#Graphical_image_viewers
# Install image viewer
pacman -S --needed --noconfirm viewnior
# https://wiki.archlinux.org/title/List_of_applications/Multimedia#Raster_graphics_editors
# Install image editor
pacman -S --needed --noconfirm gimp

# https://wiki.archlinux.org/title/List_of_applications/Multimedia#Video_players
# Install video player
pacman -S --needed --noconfirm vlc
# https://wiki.archlinux.org/title/List_of_applications/Multimedia#Video_editors
# Install video editor
pacman -S --needed --noconfirm shotcut

# https://wiki.archlinux.org/title/Screen_capture#maim
# Install cli screenshot tool with window and clipboard support
pacman -S --needed --noconfirm maim xdotool xclip
# https://wiki.archlinux.org/title/Screen_capture#Screencast_software
# Install screen recorder
pacman -S --needed --noconfirm obs-studio

# https://wiki.archlinux.org/title/List_of_applications/Utilities#Task_managers
# Install cli and GUI task manager
pacman -S --needed --noconfirm htop xfce4-taskmanager

# https://wiki.archlinux.org/title/List_of_applications/Utilities#Archive_managers
# Install archive manager
pacman -S --needed --noconfirm engrampa

# https://wiki.archlinux.org/title/List_of_applications/Other#Application_launchers
# Install application launcher and bind to windows/super key
pacman -S --needed --noconfirm rofi xcape

# https://wiki.archlinux.org/title/Clipboard#Managers
# Install GUI clipboard manager
pacman -S --needed --noconfirm clipcat

# https://wiki.archlinux.org/title/Fzf#Installation
# Install command-line fuzzy finder
pacman -S --needed --noconfirm fzf

# https://wiki.archlinux.org/title/Sudo#Example_entries
# Allow wheel to run sudo entering password
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
