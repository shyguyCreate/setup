#!/bin/sh

# Script variables
NEWUSER="shyguy"
KEYBOARD_LAYOUT="latam"
KEYBOARD_VARIANT="deadtilde"

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

# https://wiki.archlinux.org/title/Sudo#Example_entries
# Allow wheel group to run sudo without password
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) ALL/# %wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# https://wiki.archlinux.org/title/Users_and_groups#User_management
# Add new user
id -u "$NEWUSER" > /dev/null 2>&1 || useradd -m -G wheel "$NEWUSER"

# Save user HOME variable
# shellcheck disable=SC2016
USERHOME="$(getent passwd "$NEWUSER" | cut -d ':' -f 6)"

# https://github.com/Jguer/yay#Installation
# Install yay from AUR
pacman -S --needed git base-devel >> /pacman-output.log 2>> /pacman-error.log
if pacman -Q yay > /dev/null 2>&1; then
    runuser -l "$NEWUSER" -c "cd /tmp && git clone -q https://aur.archlinux.org/yay-bin.git; cd yay-bin && makepkg -si --needed --noconfirm" >> /yay-output.log 2>> /yay-error.log
fi

# Install packages inside csv file
curl -s -o /tmp/pkgs.csv.tmp https://raw.githubusercontent.com/shyguyCreate/setup/main/pkgs.csv
tail -n +2 /tmp/pkgs.csv.tmp | cut -d ',' -f -2 > /tmp/pkgs.csv
while IFS=, read -r tag program; do
    case "$tag" in
        "A") runuser -l "$NEWUSER" -c "yay -S --needed --noconfirm $program" >> /yay-output.log 2>> /yay-error.log ;;
        *) pacman -S --needed --noconfirm $program >> /pacman-output.log 2>> /pacman-error.log ;;
    esac
done < /tmp/pkgs.csv

# https://wiki.archlinux.org/title/Doas#Configuration
# Add config file to access root
echo 'permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel' > /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

# https://git-scm.com/docs/git-config#Documentation/git-config.txt-initdefaultBranch
# Set main as the default branch name
git config --system init.defaultBranch main

# https://wiki.archlinux.org/title/Uncomplicated_Firewall#Installation
systemctl --quiet disable iptables.service
systemctl --quiet disable ip6tables.service
systemctl --quiet enable ufw.service
ufw enable

# https://wiki.archlinux.org/title/LightDM#Enabling_LightDM
# Enable lightdm
systemctl --quiet enable lightdm.service

# https://wiki.archlinux.org/title/Cron#Activation_and_autostart
# Enable cron service
systemctl --quiet enable cronie.service

# https://wiki.archlinux.org/title/Docker#Installation
# Enable docker daemon
systemctl --quiet enable docker.socket
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
# Run docker as a non-root user
getent group docker > /dev/null 2>&1 || groupadd docker
id -nG "$NEWUSER" | grep -qw docker || usermod -aG docker "$NEWUSER"

# https://wiki.archlinux.org/title/CUPS#Socket_activation
# Enable cups socket
systemctl --quiet enable cups.socket
# https://wiki.archlinux.org/title/CUPS#Printer_discovery
# Disable built-in mDNS service
systemctl --quiet disable systemd-resolved.service
# https://wiki.archlinux.org/title/Avahi#Hostname_resolution
# Enable avahi with hostname resolution
systemctl --quiet enable avahi-daemon.service
sed -i 's/hosts: mymachines resolve/hosts: mymachines mdns_minimal [NOTFOUND=return] resolve/' /etc/nsswitch.conf

# https://wiki.archlinux.org/title/Libinput#Via_Xorg_configuration_file
# Add tap to click, natural scrolling, and increased mouse speed
mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/30-touchpad.conf << EOF
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
        Option "NaturalScrolling" "on"
        Option "AccelSpeed" "0.25"
EndSection
EOF

# https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Using_X_configuration_files
# Change Xorg keyboard layout
mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/00-keyboard.conf << EOF
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbModel" "pc105"
        Option "XkbLayout" "$KEYBOARD_LAYOUT"
        Option "XkbVariant" "$KEYBOARD_VARIANT"
EndSection
EOF

# https://wiki.archlinux.org/title/File_manager_functionality#Use_PCManFM_to_get_thumbnails_for_other_file_types
# Get thumbnail preview for PDFs
mkdir -p /usr/share/thumbnailers
cat > /usr/share/thumbnailers/imagemagick-pdf.thumbnailer << EOF
[Thumbnailer Entry]
TryExec=convert
Exec=convert %i[0] -background "#FFFFFF" -flatten -thumbnail %s %o
MimeType=application/pdf;application/x-pdf;image/pdf;
EOF

# https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
# Change zsh dotfiles to ~/.config/zsh
# shellcheck disable=SC2016
echo 'export ZDOTDIR=$HOME/.config/zsh' > /etc/zsh/zshenv

# https://wiki.archlinux.org/title/Command-line_shell#Changing_your_default_shell
# Change new user default shell
[ "$(getent passwd "$NEWUSER" | awk -F: '{print $NF}')" = "/usr/bin/zsh" ] || chsh -s /usr/bin/zsh "$NEWUSER" > /dev/null

# https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
# Copy dotfiles from repo to HOME
runuser -l "$NEWUSER" << 'EOF'
git clone -q --bare https://github.com/shyguyCreate/dotfiles.git "$HOME/.dotfiles" --depth 1
dotfiles(){ git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $@; }
dotfiles config --local status.showUntrackedFiles no
cd "$HOME" && mkdir -p .dotfiles-backup
dotfiles checkout 2>&1 | grep "\s\s*\." | awk '{print $1}' | sed 's|[^/]*$||' | sort -u | xargs -I {} mkdir -p ".dotfiles-backup/{}"
dotfiles checkout 2>&1 | grep "\s\s*\." | awk '{print $1}' | xargs -I {} mv {} ".dotfiles-backup/{}"
dotfiles checkout -f
EOF

# Configure vscodium with scripts
curl -s --output-dir /tmp -O https://gist.githubusercontent.com/shyguyCreate/4ab7e85477f6bcd2dd58aad3914861a8/raw/code-setup
chmod +x /tmp/code-setup && runuser -l "$NEWUSER" -c "/tmp/code-setup -c codium"

# https://wiki.archlinux.org/title/cron#Running_X.org_server-based_applications
# Add cron job for battery notifications
echo "* * * * * . $USERHOME/.Xenv && $USERHOME/.local/bin/battery-notify" | crontab -u "$NEWUSER" -

# https://wiki.archlinux.org/title/udev#Triggering_desktop_notifications_from_a_udev_rule
# Send notification when plugged
mkdir -p /etc/udev/rules.d
cat > /etc/udev/rules.d/99-battery-notify-$NEWUSER.rules << EOF
ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", \\
RUN+="/usr/bin/su $NEWUSER -c '. $USERHOME/.Xenv && $USERHOME/.local/bin/battery-notify'"

ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", \\
RUN+="/usr/bin/su $NEWUSER -c '. $USERHOME/.Xenv && $USERHOME/.local/bin/battery-notify'"
EOF

# https://wiki.archlinux.org/title/Sudo#Example_entries
# Allow wheel to run sudo entering password
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
