# Installation-Setup
### **Setup for Manjaro**
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Manjaro/installationSetup.sh)"
```

### **Setup for Windows**
Make sure to run this with admin priviledges to create symlinks.
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/Windows/installationSetup.ps1).Content
```

### **Installation of Ubuntu WSL**
```
Set-ExecutionPolicy RemoteSigned -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/WSL/ubuntuInstallation.ps1).Content
```

### **Setup for Ubuntu WSL**
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/shyguyCreate/installation-Setup/main/WSL/ubuntuSetup.sh)"
```
