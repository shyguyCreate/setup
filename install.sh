#!/bin/sh

# Script variables
KEYBOARD_LAYOUT="la-latin1"

# Exit if DISK is empty
[ -z "$DISK" ] && echo "Error: Missing disk device, use DISK=/dev/your_disk" > /dev/tty && return 1
[ ! -e "$DISK" ] && echo "Error: Disk device does not exist, use DISK=/dev/your_disk" > /dev/tty && return 1

# https://wiki.archlinux.org/title/Installation_guide#Set_the_console_keyboard_layout_and_font
# Set keyboard layout (latam latin)
loadkeys "$KEYBOARD_LAYOUT"

# https://wiki.archlinux.org/title/Installation_guide#Update_the_system_clock
# Activate network time synchronization
timedatectl set-ntp true

# https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks
# Partition disk
printf "size=+1G,type=L\\nsize=+5G,type=L\\nsize=+,type=L\\n" | sfdisk -q "${DISK}"

# https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions
# Format root partition
mkfs.ext4 "${DISK}3"
# Format boot partition
mkfs.fat -F 32 "${DISK}1"
# Format swap partition
mkswap "${DISK}2"

# https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems
# Mount root volume
mount "${DISK}3" /mnt
# Mount boot partition
mount --mkdir "${DISK}1" /mnt/boot
# Enable swap partition
swapon "${DISK}2"

# https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages
# Install packages in new system
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers nano vim

# https://wiki.archlinux.org/title/Installation_guide#Fstab
# Define disk partitions
genfstab -U /mnt >> /mnt/etc/fstab

# Copy script to DISK
[ -f /root/usb/setup.sh ] && cp /root/usb/setup.sh /mnt/setup.sh
