#Check if script is run as admin
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Start-Process powershell.exe `
        '-NoProfile -NoLogo -NoExit -ExecutionPolicy RemoteSigned -Command "& { Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/machine-Setup/main/Windows/installSetup.ps1).Content }"' `
            -Verb RunAs
    return
}

#ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

#Install programs
winget install -e --id Git.Git -s winget
winget install -e --id Microsoft.PowerShell -s winget
winget install -e --id JanDeDobbeleer.OhMyPosh -s winget


#Make directory for Github and gists
New-Item -Path "$Env:USERPROFILE\Github\gist" -ItemType Directory -Force > $null
#Clone git repository from this script
$machineSetup="$Env:USERPROFILE\Github\machine-Setup"
git clone https://github.com/shyguyCreate/machine-Setup.git $machineSetup


#Install Powershell modules
powershell.exe -NoProfile -File "$machineSetup\pwsh\pwsh-Setup.ps1"
pwsh.exe -NoProfile -File "$machineSetup\pwsh\pwsh-Setup.ps1"


#Install CaskaydiaCove Nerd Font
powershell.exe -c "& { Update-CaskaydiaCoveNF }"
