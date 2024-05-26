#!/bin/sh

# Script variables
KEYBOARD_LAYOUT="la-latin1"
CONSOLE_FONT="ter-122b"

# Exit if DISK is empty
[ -z "$DISK" ] && echo "Error: Missing DISK device, use DISK=/dev/your_disk" && return 1
[ ! -b "$DISK" ] && echo "Error: DISK does not exist, use DISK=/dev/your_disk" && return 1
[ "$(lsblk -dno type "$DISK")" != "disk" ] && echo "Error: DISK is not disk type, use DISK=/dev/your_disk" && return 1

# https://wiki.archlinux.org/title/Installation_guide#Set_the_console_keyboard_layout_and_font
# Set keyboard layout (latam latin)
loadkeys "$KEYBOARD_LAYOUT"
# Set different console font
setfont "$CONSOLE_FONT"

# https://wiki.archlinux.org/title/Installation_guide#Update_the_system_clock
# Activate network time synchronization
timedatectl set-ntp true

# Remove partition signatures
echo "Removing disk signatures..."
wipefs --all -q "${DISK}" || ! echo "Error ocurred!" || return 1

# https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks
# Partition disk
echo "Partitioning disk..."
printf "size=+1G,type=L\nsize=+5G,type=L\nsize=+,type=L\n" | sfdisk -q "${DISK}" || ! echo "Error ocurred!" || return 1

# https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions
# Format root partition
echo "Formatting root partition..."
mkfs.ext4 -q -F "${DISK}3"
# Format boot partition
echo "Formatting boot partition..."
mkfs.fat -F 32 "${DISK}1"
# Format swap partition
echo "Formatting swap partition..."
mkswap -q "${DISK}2"

# https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems
# Mount root volume
mount "${DISK}3" /mnt
# Mount boot partition
mount --mkdir "${DISK}1" /mnt/boot
# Enable swap partition
swapon "${DISK}2"

# https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages
# Install packages in new system
echo "Installing packages to new system..."
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers nano vim >> /root/pacstrap-output.log 2>> /root/pacstrap-error.log

# https://wiki.archlinux.org/title/Installation_guide#Fstab
# Define disk partitions
genfstab -U /mnt >> /mnt/etc/fstab

# Copy logs to DISK
echo "Copying logs to new system..."
cp /root/pacstrap-output.log /mnt/pacstrap-output.log
cp /root/pacstrap-error.log /mnt/pacstrap-error.log

# Add scripts to DISK
echo "Adding scripts to new system..."
curl -s --output-dir /mnt -O https://raw.githubusercontent.com/shyguyCreate/setup/main/install.sh
curl -s --output-dir /mnt -O https://raw.githubusercontent.com/shyguyCreate/setup/main/setup.sh
