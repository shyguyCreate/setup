#!/bin/sh

# Check if mkfs commands exists
! command -v mkfs.fat > /dev/null 2>&1 && echo "Error: Dependency mkfs.fat command is not available" > /dev/tty && return 1
! command -v mkfs.ext4 > /dev/null 2>&1 && echo "Error: Dependency mkfs.ext4 command is not available" > /dev/tty && return 1

# Exit if DISK is empty
[ -z "$DISK" ] && echo "Error: Missing disk device, use DISK=/dev/your_disk" > /dev/tty && return 1
[ ! -e "$DISK" ] && echo "Error: Disk device does not exist, use DISK=/dev/your_disk" > /dev/tty && return 1

# Exit if ISO is empty
[ -z "$ISO" ] && echo "Error: Missing iso file, use ISO=path/to/archlinux-version-x86_64.iso" > /dev/tty && return 1
[ ! -f "$ISO" ] && echo "Error: Iso file does not exist, use ISO=path/to/archlinux-version-x86_64.iso" > /dev/tty && return 1

# Restore usb drive as an empty
wipefs --all -qf "${DISK}"

# Partition usb
printf "size=+2G,type=L,\\nsize=+,type=L\\n" | sfdisk -q "${DISK}"

# Format iso partition
mkfs.fat -F 32 "${DISK}1"
# Format other partition
mkfs.ext4 -q -F "${DISK}2"

# Mount iso volume
mount "${DISK}1" /mnt

# Extract the iso image to mount
bsdtar -x -f "$ISO" -C /mnt

# Umount iso volume
umount /mnt
