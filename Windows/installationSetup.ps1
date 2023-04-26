#ExecutionPolicy
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser


#NerdFonts
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip" -OutFile "$Env:USERPROFILE\Downloads\CascadiaCode.zip"
Expand-Archive -Path "$Env:USERPROFILE\Downloads\CascadiaCode.zip" -DestinationPath "$Env:USERPROFILE\Downloads\CascadiaCode"
Invoke-Item -Path "$Env:USERPROFILE\Downloads\CascadiaCode\Caskaydia Cove Nerd Font Complete Windows Compatible *.otf"


#Make directory for Github and gists
New-Item -Path "$Env:USERPROFILE\Github\gist" -ItemType Directory
#Clone git repository
git clone https://github.com/shyguyCreate/installation-Setup.git "$Env:USERPROFILE\Github\installation-Setup"

#Make folders for profiles
New-Item -Path "$Env:USERPROFILE\Documents\WindowsPowerShell" -ItemType Directory
New-Item -Path "$Env:USERPROFILE\Documents\PowerShell" -ItemType Directory

#Create symbolic link to powershell profile file
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\installation-Setup\Windows\Profile.ps1" -Path "$Env:USERPROFILE\Documents\WindowsPowerShell\Profile.ps1"
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\installation-Setup\Windows\Profile.ps1" -Path "$Env:USERPROFILE\Documents\PowerShell\Profile.ps1"


#OH-MY-POSH
winget install JanDeDobbeleer.OhMyPosh -s winget
#Get ohmyposh config from gist
git clone https://gist.github.com/387ff25579b25bff63a6bc1a7635be27.git "$Env:USERPROFILE\Github\gist\ohmyposh"
#Create symbolic link of ohmyposh to powershell profile file
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\gist\ohmyposh\ohmyposhCustome.omp.json" -Path "$Env:USERPROFILE\Documents\WindowsPowerShell\ohmyposhCustome.omp.json"
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\gist\ohmyposh\ohmyposhCustome.omp.json" -Path "$Env:USERPROFILE\Documents\PowerShell\ohmyposhCustome.omp.json"


#Install Powershell modules
Install-Module -Name Terminal-Icons -Scope CurrentUser
Install-Module -Name PSReadLine -Force -Scope CurrentUser
