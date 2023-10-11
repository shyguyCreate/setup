#ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

#Install programs
winget install -e --id Git.Git -s winget
winget install -e --id Microsoft.PowerShell -s winget
winget install -e --id JanDeDobbeleer.OhMyPosh -s winget


#Function to clone a repo or update it with pull
function Git-CloneOrPull ($repoDir, $url) {
    if (-not (Test-Path "$repoDir\.git" -PathType Container)) {
        git clone "$url" "$repoDir"
    }
    else {
        git -C "$repoDir" pull -q
    }
}


#Make directory for Github and gists
New-Item -Path "$Env:USERPROFILE\Github\gist" -ItemType Directory -Force > $null
#Clone git repository from this script
$machineSetup = "$Env:USERPROFILE\Github\machine-Setup"
Git-CloneOrPull "$machineSetup" https://github.com/shyguyCreate/machine-Setup.git


#Install Powershell modules
powershell.exe -NoProfile -File "$machineSetup\pwsh\pwsh-Setup.ps1"
pwsh.exe -NoProfile -File "$machineSetup\pwsh\pwsh-Setup.ps1"


#Install CaskaydiaCove Nerd Font
$caskaydiaCove = "$Env:USERPROFILE\Github\gist\caskaydiaCove"
Git-CloneOrPull "$caskaydiaCove" https://gist.github.com/9e2772a51ef16bc59e697877de88fffc.git
. "$caskaydiaCove\caskaydiaCove.ps1"
