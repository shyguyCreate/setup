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
if (-not (Test-Path "$machineSetup\.git" -PathType Container)) {
    git clone https://github.com/shyguyCreate/machine-Setup.git "$machineSetup"
} else {
    git -C "$machineSetup" pull -q
}


#Install Powershell modules
powershell.exe -NoProfile -File "$machineSetup\pwsh\pwsh-Setup.ps1"
pwsh.exe -NoProfile -File "$machineSetup\pwsh\pwsh-Setup.ps1"


#Install CaskaydiaCove Nerd Font
$caskaydiaCove="$Env:USERPROFILE\Github\gist\caskaydiaCove"
if (-not (Test-Path "$caskaydiaCove\.git" -PathType Container)) {
    git clone https://gist.github.com/9e2772a51ef16bc59e697877de88fffc.git "$caskaydiaCove"
} else {
    git -C "$caskaydiaCove" pull -q
}
. "$caskaydiaCove\caskaydiaCove.ps1"
