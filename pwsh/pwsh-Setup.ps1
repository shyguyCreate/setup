#Path to dir of profile script
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
#Make profile folder
New-Item -Path $PROFILE_FOLDER -ItemType Directory -Force > $null


#Checks if module is installed
function Install-NewModule ([string[]] $Name)
{
    foreach ($_name in $Name)
    {
        if (-not (Get-InstalledModule | Where-Object {$_.Name -eq $_name}))
        {
            Install-Module -Name $_name -Scope CurrentUser -Force
        }
    }
}

#Install Powershell modules
Install-NewModule -Name posh-git,PSReadLine,Terminal-Icons


#Directory of this repository
Set-Variable -Name machineSetup -Value ([IO.Path]::Combine("$HOME","Github","machine-Setup"))
if (-not (Test-Path "$machineSetup/.git" -PathType Container)) {
    git clone https://github.com/shyguyCreate/machine-Setup.git "$machineSetup"
} else {
    git -C "$machineSetup" pull -q
}

#Configure powershell with config files
Get-ChildItem -Path ([IO.Path]::Combine("$machineSetup","pwsh")) -Force | Copy-Item -Destination $PROFILE_FOLDER -Force > $null
