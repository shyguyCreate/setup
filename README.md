# Install-Scripts

## Setup for Linux

### Setup for Manjaro
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/machine-Setup/main/Manjaro/setup.sh)"
```
> ***Advice:*** if your device has a **Broadcom wireless network device** and needs drivers for it, check the scripts inside the [BroadcomWireless folder](./Drivers/BroadcomWireless). If you are not sure about your device, run this in your terminal `lspci | grep network -i`.

------------------------

## Setup for Windows

*This script needs to be run with admin priviledges.*
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/machine-Setup/main/Windows/setup.ps1).Content
```

### Install Ubuntu for WSL
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/machine-Setup/main/WSL/ubuntuInstall.ps1).Content
```

### Setup Ubuntu for WSL
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/machine-Setup/main/WSL/ubuntuSetup.sh)"
```
