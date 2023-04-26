# Installation-Setup
### **Setup for Linux**
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Linux/installationSetup.sh)"
```

### **Setup for Windows**
Make sure your system has permission for running scripts. Enter this in your powershell terminal.
> Set-ExecutionPolicy RemoteSigned
```
Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Windows/installationSetup.ps1).Content
```

### **Installation of WSL**
```
Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Windows/WSL/ubuntuInstallation.ps1).Content
```

### **Setup for Ubuntu WSL**
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Windows/WSL/ubuntuSetup.sh)"
```
