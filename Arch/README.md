# Arch installation

To get the Arch ISO, refer to the [Installation guide](https://wiki.archlinux.org/title/Installation_guide#Pre-installation) in the Arch wiki.

Now, inside the USB live session, do the following:

---

https://wiki.archlinux.org/title/Installation_guide#Set_the_console_keyboard_layout_and_font

List available keyboard layouts

```
localectl list-keymaps
```

Set keyboard layout (latam latin)

```
loadkeys la-latin1
```

---

https://wiki.archlinux.org/title/Installation_guide#Verify_the_boot_mode

Verify UEFI

```
cat /sys/firmware/efi/fw_platform_size
```

---

https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet

Connect to wireless internet

```
iwctl
```

https://wiki.archlinux.org/title/Iwd#Connect_to_a_network

```
[iwd]# device list
[iwd]# device _device_ set-property Powered on   # if powered off
[iwd]# adapter _adapter_ set-property Powered on # if powered off
[iwd]# station _device_ scan
[iwd]# station _device_ get-networks
[iwd]# station _device_ connect _SSID_internet_name
[iwd]# station device show
[iwd]# Ctrl+d # exit
```

Check internet connection

```
ping archlinux.org
```

---

https://wiki.archlinux.org/title/Installation_guide#Update_the_system_clock

Activate network time synchronization

```
timedatectl set-ntp true
```

---

https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks

```
fdisk /dev/sdX
```

Partition disk

```
d     # delete partition (repeat multiple times)
n +1G # boot
n +5G # swap
n     # root
w     # write to disk
```

---

https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions

Format root partition

```
mkfs.mkfs.ext4 /dev/sdX3
```

https://wiki.archlinux.org/title/EFI_system_partition#Format_the_partition

Format boot partition

```
mkfs.fat -F 32 /dev/
```

https://wiki.archlinux.org/title/Swap#Swap_partition

Format swap partition

```
mkswap /dev/sdX2
```

---

https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems

Mount disk

```
mount /dev/sdX3 /mnt
mount --mkdir /dev/sdX1 /mnt/boot
swapon /dev/sdX2
```

---

https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages

Install packages in new system

```
pacstrap -K /mnt base linux linux-firmware
```

---

https://wiki.archlinux.org/title/Installation_guide#Fstab

Define disk partitions

```
genfstab -U /mnt >> /mnt/etc/fstab
```

---

https://wiki.archlinux.org/title/Installation_guide#Chroot
Change root into new system

```
arch-chroot /mnt
```

---

Run installation script (**must be run as root**)

```
curl -O https://raw.githubusercontent.com/shyguyCreate/machine-Setup/main/Arch/setup.sh
. setup.sh > output.txt 2> error.txt
```

**Note:** run `sed -i 's/\<shyguy\>/your_username/g' setup.sh` to set a custom username before running the script

---

https://wiki.archlinux.org/title/Installation_guide#Root_password

Add root password

```
passwd
```

Add user password

```
passwd shyguy
```

**Note:** change shyguy with your username if you change it in the previous step

---

https://wiki.archlinux.org/title/Installation_guide#Reboot

Exit from chroot

```
exit
```

Unmount disk

```
umount -R /mnt
```

Reboot system

```
reboot
```

---

https://wiki.archlinux.org/title/NetworkManager#Usage

Connect to wireless internet

```
nmtui
```

or

```
nmcli device wifi list
nmcli device wifi connect _SSID_internet_name_ password _password_
nmcli connection show
nmcli device
```

Check internet connection

```
ping archlinux.org
```
