#Path to dir of profile script
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
#Make profile folder
New-Item -Path $PROFILE_FOLDER -ItemType Directory -Force > $null


#Install Powershell modules
Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force


#Directory of this repository
Set-Variable -Name machineSetup -Value ([IO.Path]::Combine("$HOME","Github","machine-Setup"))

if (Test-Path $machineSetup -PathType Container)
{
    #Create symbolic link of profile script to powershell profile folder
    New-Item -ItemType SymbolicLink -Value ([IO.Path]::Combine("$machineSetup","pwsh","profile.ps1")) -Path $PROFILE_FOLDER -Name "profile.ps1" -Force > $null
    #Create symbolic link of ohmyposh config file to powershell profile folder
    New-Item -ItemType SymbolicLink -Value ([IO.Path]::Combine("$machineSetup","pwsh",".omp.json")) -Path $PROFILE_FOLDER -Name ".omp.json" -Force > $null

    if ($IsWindows)
    {
        #Create symbolic link of profileMS script to powershell profile folder
        New-Item -ItemType SymbolicLink -Value ([IO.Path]::Combine("$machineSetup","pwsh","profileMS.ps1")) -Path $PROFILE_FOLDER -Name "profileMS.ps1" -Force > $null
    }
}
