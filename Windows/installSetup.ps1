#Check if script is run as admin
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Start-Process powershell.exe `
        '-NoProfile -NoLogo -NoExit -ExecutionPolicy RemoteSigned -Command "& { Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/install-Scripts/main/Windows/installSetup.ps1).Content }"' `
            -Verb RunAs
    return
}

#ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force


#Script variables
$repoDir="$Env:USERPROFILE\Github\install-Scripts"
$profilesDir="$Env:USERPROFILE\Documents\WindowsPowerShell","$Env:USERPROFILE\Documents\PowerShell"


#Install Powershell modules
powershell.exe -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"
pwsh.exe -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"


#Make directory for Github and gists
New-Item -Path "$Env:USERPROFILE\Github\gist" -ItemType Directory -Force > $null
#Clone git repository
git clone https://github.com/shyguyCreate/install-Scripts.git $repoDir


#Make folders for profiles
New-Item -Path $profilesDir -ItemType Directory -Force > $null

#Create symbolic link of profile script to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$repoDir\share\profile.ps1" -Path $profilesDir -Name "profile.ps1" -Force > $null
#Create symbolic link of Windows_profile script to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$repoDir\Windows\Windows_profile.ps1" -Path $profilesDir -Name "Windows_profile.ps1" -Force > $null
#Create symbolic link of ohmyposh config file to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$repoDir\share\ohmyposh.omp.json" -Path $profilesDir -Name "ohmyposh.omp.json" -Force > $null


#Install CaskaydiaCove Nerd Font
powershell.exe -c "& { Update-CaskaydiaCoveNF }"
