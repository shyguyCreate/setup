# Installation-Setup
### **Setup for Linux**
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Linux/installationSetup.sh)"
```

### **Setup for Windows**
Make sure to run this with admin priviledges to create symlinks.
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Windows/installationSetup.ps1).Content
```

### **Installation of WSL**
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Windows/WSL/ubuntuInstallation.ps1).Content
```

### **Setup for Ubuntu WSL**
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Windows/WSL/ubuntuSetup.sh)"
```
