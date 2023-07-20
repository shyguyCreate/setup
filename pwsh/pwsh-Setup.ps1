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

if (Test-Path $machineSetup -PathType Container)
{
    #Copy profile script to powershell profile folder
    Copy-Item -Path ([IO.Path]::Combine("$machineSetup","pwsh","profile.ps1")) -Destination $PROFILE_FOLDER -Force > $null
    #Copy ohmyposh config file to powershell profile folder
    Copy-Item -Path ([IO.Path]::Combine("$machineSetup","pwsh",".omp.json")) -Destination $PROFILE_FOLDER -Force > $null
    #Copy keys file to powershell profile folder
    Copy-Item -Path ([IO.Path]::Combine("$machineSetup","pwsh","keys.ps1")) -Destination $PROFILE_FOLDER -Force > $null
}
