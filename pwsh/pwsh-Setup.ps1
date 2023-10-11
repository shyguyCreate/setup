#Path to dir of profile script
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
#Make profile folder
New-Item -Path $PROFILE_FOLDER -ItemType Directory -Force > $null


#Checks if module is installed
function Install-NewModule ([string[]] $Name) {
    foreach ($_name in $Name) {
        if (-not (Get-InstalledModule | Where-Object { $_.Name -eq $_name })) {
            Install-Module -Name $_name -Scope CurrentUser -Force
        }
    }
}

#Install Powershell modules
Install-NewModule -Name posh-git, PSReadLine, Terminal-Icons


#Directory of this repository
Set-Variable -Name pwshFilesDir -Value ([IO.Path]::Combine("$HOME", "Github", "machine-Setup", "pwsh"))
if (Test-Path $pwshFilesDir/*) {
    #Configure powershell with config files
    Get-ChildItem -Path $pwshFilesDir -Force | 
        ForEach-Object {    
            Copy-Item -Path $_ -Destination $PROFILE_FOLDER -Force > $null
        }
}
