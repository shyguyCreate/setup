# Broadcom Package Driver for Arch-based distros

Scripts that download and install packages needed for **Broadcom wireless network device** based on information provided in the [Arch wiki](https://wiki.archlinux.org/title/broadcom_wireless).

***Note:*** the scripts are separate because packages are meant for an offline installation in another device.

> If you are looking to install the packages in the same device, run `sudo pacman -Sy base-devel linux-headers broadcom-wl-dkms` in the terminal.

### Download packages for driver
Packages are downloaded using `pacman` but not installed, instead they are saved to `$HOME/BroadcomPackages` to use them for an offline installation.
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Scripts/main/BroadcomDrivers/Arch-based/broadcomDownload.sh)"
```

### Install packages for driver
Packages are retrieved from `$HOME/BroadcomPackages` and installed using `pacman`. And modules are removed and loaded for the driver to work.
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Scripts/main/BroadcomDrivers/Arch-based/broadcomInstallation.sh)"
```
