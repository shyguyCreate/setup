#Path to dir of profile script
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
#Make profile folder
New-Item -Path $PROFILE_FOLDER -ItemType Directory -Force > $null


#Checks if module is installed if not install Powershell modules
foreach ($_module in @("posh-git", "PSReadLine", "Terminal-Icons")) {
    if (-not (Get-InstalledModule | Where-Object { $_.Name -eq $_module })) {
        Install-Module -Name $_module -Scope CurrentUser -Force
    }
}


#Directory of this repository
$pwshFilesDir = [IO.Path]::Combine("$HOME", "Github", "machine-Setup", "pwsh")
if (Test-Path $pwshFilesDir/*) {

    #Configure powershell with config files
    Get-ChildItem -Path $pwshFilesDir -Force |
        ForEach-Object {

            #Save file with same name but in ZDOTDIR and a backup
            $pwshFile = [IO.Path]::Combine("$PROFILE_FOLDER", "$(Split-Path $_ -Leaf)")
            $backup = "${pwshFile}.bak"

            #Scriptblock that copies files to PROFILE_FOLDER
            $copyPwshFile = { Copy-Item -Path $_ -Destination $pwshFile -Force > $null }

            if (Test-Path $pwshFile -PathType Leaf) {
                #Use Compare-Object output to make a backup
                $_diff = Compare-Object (Get-Content $pwshFile) (Get-Content $_) | ForEach-Object { "$($_.SideIndicator) $($_.InputObject)" }
                if (-not [string]::IsNullOrEmpty($_diff)) {
                    #Backup file will be overwritten when a newer difference is found
                    Set-Content -Value $_diff -Path $backup
                    Write-Host "Backup was created for $(Split-Path $_ -Leaf)"
                    #Copy file if are different from one another
                    Invoke-Command -ScriptBlock $copyPwshFile
                }
            }
            else {
                #Run script block that copy the file
                Invoke-Command -ScriptBlock $copyPwshFile
            }
        }

    #Remove foreach variables
    Remove-Variable pwshFile, backup, copyPwshFile
}

#Remove pwsh repo directory variable
Remove-Variable pwshFilesDir
