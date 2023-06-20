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
$githubDir="$Env:USERPROFILE\Github"
$repoDir="$githubDir\install-Scripts"
$powershellDir="$Env:USERPROFILE\Documents\WindowsPowerShell"
$pwshDir="$Env:USERPROFILE\Documents\PowerShell"


#Install Powershell modules
powershell.exe -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"
pwsh.exe -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"


#Make directory for Github and gists
New-Item -Path "$githubDir\gist" -ItemType Directory -Force > $null
#Clone git repository
git clone https://github.com/shyguyCreate/install-Scripts.git $repoDir


#Make folders for profiles
New-Item -Path $powershellDir,$pwshDir -ItemType Directory -Force > $null

#Create symbolic link of profile script to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$repoDir\share\profile.ps1" -Path $powershellDir,$pwshDir -Name "profile.ps1" -Force > $null
#Create symbolic link of ohmyposh config file to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$repoDir\share\ohmyposh.omp.json" -Path $powershellDir,$pwshDir -Name "ohmyposh.omp.json" -Force > $null


#Clone gist to download CaskaydiaCove Nerd Fonts
git clone https://gist.github.com/3efd051938218c9cb947af4354b70111.git "$githubDir\gist\caskaydiaCove-Downloader"
#Run gist script
. "$githubDir\gist\caskaydiaCove-Downloader\caskaydiaCove-Downloader.ps1"
