#!/bin/sh

# Check if mkfs commands exists
! command -v mkfs.fat > /dev/null 2>&1 && echo "Error: Dependency mkfs.fat command is not available" && return 1
! command -v mkfs.ext4 > /dev/null 2>&1 && echo "Error: Dependency mkfs.ext4 command is not available" && return 1

# Exit if USB is invalid
[ -z "$USB" ] && echo "Error: Missing USB device, use USB=/dev/your_usb" && return 1
[ ! -e "$USB" ] && echo "Error: USB device does not exist, use USB=/dev/your_usb" && return 1
printf '%s' "$USB" | rev | cut -c 1 | grep -q '[0-9]' && echo "Error: USB seems to be a partition, use USB=/dev/your_usb" && return 1

# Exit if ISO is invalid
[ -z "$ISO" ] && echo "Error: Missing ISO file, use ISO=path/to/archlinux-version-x86_64.iso" && return 1
[ ! -f "$ISO" ] && echo "Error: ISO file does not exist, use ISO=path/to/archlinux-version-x86_64.iso" && return 1
! bsdtar -t -f "$ISO" > /dev/null 2>&1 && echo "Error: Unrecognized archive format, use ISO=path/to/archlinux-version-x86_64.iso" && return 1

# Restore usb drive as an empty
wipefs --all -qf "${USB}"

# Partition usb
printf "size=+2G,type=L,\\nsize=+,type=L\\n" | sfdisk -q "${USB}"

############ ISO ############

# Format iso partition
echo "Formatting boot partition..."
mkfs.fat -F 32 "${USB}1"

# Mount iso volume
mount "${USB}1" /mnt

# Extract iso image to mount
echo "Copying ISO to USB..."
bsdtar -x -f "${ISO}" -C /mnt

# Umount iso volume
umount /mnt

########## STORAGE ##########

# Format storage partition
echo "Formatting storage partition..."
mkfs.ext4 -q -F "${USB}2"

# Mount storage volume
mount "${USB}2" /mnt

# Copy scripts to storage volume
echo "Adding scripts to USB..."
curl -s --output-dir /mnt -O https://raw.githubusercontent.com/shyguyCreate/setup/main/install.sh
curl -s --output-dir /mnt -O https://raw.githubusercontent.com/shyguyCreate/setup/main/setup.sh

# Umount storage volume
umount /mnt
