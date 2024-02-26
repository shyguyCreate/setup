# Arch installation

Follow the [installation guide](https://wiki.archlinux.org/title/Installation_guide#Pre-installation) in the Arch wiki until you complete the section of [booting from the ISO](https://wiki.archlinux.org/title/Installation_guide#Boot_the_live_environment). Now, inside the live session, do the following:

---

Connect to [wireless internet](https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet) using [iwctl](https://wiki.archlinux.org/title/Iwd#iwctl)

```
iwctl
[iwd]# device list
[iwd]# device  _device_  set-property Powered on        # if powered off
[iwd]# adapter _adapter_ set-property Powered on        # if powered off
[iwd]# station _device_ scan                            # scan for networks
[iwd]# station _device_ get-networks                    # list networks
[iwd]# station _device_ connect _SSID_internet_name_    # connect to network
[iwd]# station device show                              # display the connection state
[iwd]#  ( Ctrl+d )                                      # exit
```

---

Run installation script

```
curl -O https://raw.githubusercontent.com/shyguyCreate/setup/main/install.sh
. install.sh
```

---

[Change root into new system](https://wiki.archlinux.org/title/Installation_guide#Chroot)

```
arch-chroot /mnt
```

---

Run setup script (**must be run as root**)

```
curl -O https://raw.githubusercontent.com/shyguyCreate/setup/main/setup.sh
. setup.sh > output.txt 2> error.txt
```

**Note:** run `sed -i 's/\<shyguy\>/your_username/g' setup.sh` to set a custom username before running the script

---

[Set the root password](https://wiki.archlinux.org/title/Installation_guide#Root_password)

```
passwd
```

Set the user password _(**Note:** change shyguy with your username if you change it in the previous step)_

```
passwd shyguy
```

---

[Reboot the system](https://wiki.archlinux.org/title/Installation_guide#Reboot)

1. Exit chroot: `exit`
2. Unmount disk: `umount -R /mnt`
3. Reboot system: `reboot`

---

Connect to wireless internet using [Network Manger](https://wiki.archlinux.org/title/NetworkManager#Usage)

```
nmtui
```
