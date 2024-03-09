# Arch Installation

Follow the [installation guide](https://wiki.archlinux.org/title/Installation_guide#Pre-installation) in the Arch wiki until you complete the section of [booting from the ISO](https://wiki.archlinux.org/title/Installation_guide#Boot_the_live_environment). Now, inside the live session, do the following:

---

Connect to [wireless internet](https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet) using [iwctl](https://wiki.archlinux.org/title/Iwd#iwctl)

```
iwctl
[iwd]# device list                                # list wifi devices
[iwd]# device  _device_  set-property Powered on  # turn on device
[iwd]# adapter _adapter_ set-property Powered on  # turn on adapter
[iwd]# station _device_ scan                      # scan for networks
[iwd]# station _device_ get-networks              # list networks
[iwd]# station _device_ connect _SSID_            # connect to network
[iwd]# station device show                        # display connection state
[iwd]#  ( Ctrl+d )                                # exit
```

---

Run installation script[^1]

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

[Set the root password](https://wiki.archlinux.org/title/Installation_guide#Root_password)

```
passwd
```

---

Run setup script[^1]<br>
<sub>**Note:** to change username, modify variables inside the script</sub>

```
curl -O https://raw.githubusercontent.com/shyguyCreate/setup/main/setup.sh
. setup.sh > output.txt 2> error.txt
```

---

Set the user password<br>
<sub>**Note:** change shyguy with your username if you change it in the script</sub>

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

[^1]: Script assumes that is running as root.
