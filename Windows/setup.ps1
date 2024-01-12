#ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

#Install programs
winget install -e --id Git.Git -s winget
winget install -e --id GitHub.cli -s winget
winget install -e --id Microsoft.PowerShell -s winget
winget install -e --id JanDeDobbeleer.OhMyPosh -s winget
winget install -e --id VSCodium.VSCodium -s winget
winget install -e --id Google.Chrome -s winget
winget install -e --id Microsoft.WindowsTerminal -s winget
winget install -e --id KeePassXCTeam.KeePassXC -s winget
winget install -e --id Microsoft.PowerToys -s winget
winget install -e --id Meltytech.Shotcut -s winget
winget install -e --id Zoom.Zoom -s winget

#Function to clone a repo or update it with pull
function Start-GitCloneOrPull ($repoDir, $url) {
    if (-not (Test-Path "$repoDir\.git" -PathType Container)) {
        git clone "$url" "$repoDir"
    }
    else {
        git -C "$repoDir" pull -q
    }
}

#Make directory for Github and gists
New-Item -Path "$Env:USERPROFILE\Github\gist" -ItemType Directory -Force > $null

#Set main as initial branch for git
git config --global init.defaultBranch main

#Clone git repository from this script
$machineSetup = "$Env:USERPROFILE\Github\machine-Setup"
Start-GitCloneOrPull "$machineSetup" https://github.com/shyguyCreate/machine-Setup.git

#Configure powershell and pwsh
powershell.exe -NoProfile -File "$machineSetup\pwsh\setup.ps1"
pwsh.exe -NoProfile -File "$machineSetup\pwsh\setup.ps1"

#Clone gist repo of caskaydiacove installer
$caskaydiaCove = "$Env:USERPROFILE\Github\gist\caskaydiaCove"
Start-GitCloneOrPull "$caskaydiaCove" https://gist.github.com/9e2772a51ef16bc59e697877de88fffc.git

#Install CaskaydiaCove Nerd Font
"$caskaydiaCove\caskaydiaCove.ps1"

#Clone gist repo of codium settings
codiumSettings="$HOME/Github/gist/codium-Settings"
Start-GitCloneOrPull "$codiumSettings" https://gist.github.com/efcf9345431ca9e4d3eb2faaa6b71564.git

#Configure codium through script
"$codiumSettings/.config.ps1"
