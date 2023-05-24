# Installation-Scripts

## Setup for Linux

### Setup for Manjaro
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Scripts/main/Manjaro/installationSetup.sh)"
```
> ***Advice:*** if your device has a **Broadcom wireless network device** and needs drivers for it, check the scripts inside the [Arch-based folder](./BroadcomDrivers/Arch-based). If you are not sure about your device, run this in your terminal `lspci | grep network -i`.

#### Install powershell in Linux
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Scripts/main/share/pwshInstallation.sh)"
```

------------------------

## Setup for Windows

Make sure to run this with admin priviledges to create symlinks.
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Scripts/main/Windows/installationSetup.ps1).Content
```

### Installation of Ubuntu WSL
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Scripts/main/WSL/ubuntuInstallation.ps1).Content
```

### Setup for Ubuntu WSL
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Scripts/main/WSL/ubuntuSetup.sh)"
```
