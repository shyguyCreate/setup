#Requires -RunAsAdministrator

#ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

#Install Powershell modules
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force


#Download CascadiaCode Nerd Fonts
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip" -OutFile "$Env:USERPROFILE\Downloads\CascadiaCode.zip"
#Remove font folder if exist
if (Test-Path "$Env:USERPROFILE\Downloads\CascadiaCode") { Remove-Item "$Env:USERPROFILE\Downloads\CascadiaCode" -Recurse }
#Extract fonts
Expand-Archive -Path "$Env:USERPROFILE\Downloads\CascadiaCode.zip" -DestinationPath "$Env:USERPROFILE\Downloads\CascadiaCode"
#Open fonts to install them
Invoke-Item -Path "$Env:USERPROFILE\Downloads\CascadiaCode\CaskaydiaCoveNerdFont-*.ttf"


#Make directory for Github and gists
New-Item -Path "$Env:USERPROFILE\Github\gist" -ItemType Directory -Force > $null
#Clone git repository
git clone https://github.com/shyguyCreate/installation-Scripts.git "$Env:USERPROFILE\Github\installation-Scripts"


#Make folders for profiles
New-Item -Path "$Env:USERPROFILE\Documents\WindowsPowerShell" -ItemType Directory -Force > $null
New-Item -Path "$Env:USERPROFILE\Documents\PowerShell" -ItemType Directory -Force > $null

#Create symbolic link of profile script to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\installation-Scripts\Windows\profile.ps1" -Path "$Env:USERPROFILE\Documents\WindowsPowerShell\profile.ps1" -Force > $null
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\installation-Scripts\Windows\profile.ps1" -Path "$Env:USERPROFILE\Documents\PowerShell\profile.ps1" -Force > $null


#OH-MY-POSH
winget install JanDeDobbeleer.OhMyPosh -s winget
#Get ohmyposh config from gist
git clone https://gist.github.com/387ff25579b25bff63a6bc1a7635be27.git "$Env:USERPROFILE\Github\gist\ohmyposh"

#Create symbolic link of ohmyposh config file to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\gist\ohmyposh\ohmyposhCustome.omp.json" -Path "$Env:USERPROFILE\Documents\WindowsPowerShell\ohmyposhCustome.omp.json" -Force > $null
New-Item -ItemType SymbolicLink -Value "$Env:USERPROFILE\Github\gist\ohmyposh\ohmyposhCustome.omp.json" -Path "$Env:USERPROFILE\Documents\PowerShell\ohmyposhCustome.omp.json" -Force > $null
