#!/bin/sh

# https://wiki.archlinux.org/title/Installation_guide#Set_the_console_keyboard_layout_and_font
# List available keyboard layouts
localectl list-keymaps
# Set keyboard layout (latam latin)
loadkeys la-latin1

# https://wiki.archlinux.org/title/Installation_guide#Verify_the_boot_mode
# Verify UEFI
cat /sys/firmware/efi/fw_platform_size

# https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet
# Connect to wireless internet
iwctl
# https://wiki.archlinux.org/title/Iwd#Connect_to_a_network
[iwd]# device list
[iwd]# device _device_ set-property Powered on   # if powered off
[iwd]# adapter _adapter_ set-property Powered on # if powered off
[iwd]# station _device_ scan
[iwd]# station _device_ get-networks
[iwd]# station _device_ connect _SSID_internet_name
[iwd]# station device show
[iwd]# Ctrl+d # exit
# Check internet connection
ping archlinux.org

# https://wiki.archlinux.org/title/Installation_guide#Update_the_system_clock
# Activate network time synchronization
timedatectl set-ntp true

# https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks
fdisk /dev/sdX
# Partition disk
d     # delete partition (repeat multiple times)
n +1G # boot
n +5G # swap
n     # root
w     # write to disk

# https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions
# Format root partition
mkfs.mkfs.ext4 /dev/sdX3
# https://wiki.archlinux.org/title/EFI_system_partition#Format_the_partition
# Format boot partition
mkfs.fat -F 32 /dev/
# https://wiki.archlinux.org/title/Swap#Swap_partition
# Format swap partition
mkswap /dev/sdX2

# https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems
mount /dev/sdX3 /mnt
mount --mkdir /dev/sdX1 /mnt/boot
swapon /dev/sdX2

# https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages
pacstrap -K /mnt base linux linux-firmware

# https://wiki.archlinux.org/title/Installation_guide#Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# https://wiki.archlinux.org/title/Installation_guide#Chroot
arch-chroot /mnt

# Install important packages
pacman -S --needed --noconfirm base-devel linux-headers

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
echo 'KEYMAP=de-latin1' > /etc/vconsole.conf

# https://wiki.archlinux.org/title/Installation_guide#Network_configuration
echo 'arch' > /etc/hostname

# https://wiki.archlinux.org/title/Installation_guide#Initramfs
mkinitcpio -P

# https://wiki.archlinux.org/title/Installation_guide#Boot_loader
# https://wiki.archlinux.org/title/GRUB#Installation
pacman -S --needed --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# https://wiki.archlinux.org/title/GRUB#Generate_the_main_configuration_file
sed -i 's/GRUB_TIMEOUT=./GRUB_TIMEOUT=2/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# https://wiki.archlinux.org/title/Installation_guide#Root_password
passwd

# https://wiki.archlinux.org/title/Installation_guide#Reboot
exit
umount -R /mnt
reboot
