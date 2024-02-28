#!/bin/sh

KEYBOARD_LAYOUT="la-latin1"

# https://wiki.archlinux.org/title/Installation_guide#Set_the_console_keyboard_layout_and_font
# Set keyboard layout (latam latin)
loadkeys $KEYBOARD_LAYOUT

# https://wiki.archlinux.org/title/Installation_guide#Update_the_system_clock
# Activate network time synchronization
timedatectl set-ntp true

# https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks
# Partition disk
printf "size=+1G,\\nsize=+5G,\\nsize=+\\n" | sfdisk /dev/sdX

# https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions
# Format root partition
mkfs.ext4 /dev/sdX3
# Format boot partition
mkfs.fat -F 32 /dev/sdX1
# Format swap partition
mkswap /dev/sdX2

# https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems
# Mount root volume
mount /dev/sdX3 /mnt
# Mount boot partition
mount --mkdir /dev/sdX1 /mnt/boot
# Enable swap partition
swapon /dev/sdX2

# https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages
# Install packages in new system
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers

# https://wiki.archlinux.org/title/Installation_guide#Fstab
# Define disk partitions
genfstab -U /mnt >> /mnt/etc/fstab
