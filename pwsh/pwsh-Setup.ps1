#Path to dir of profile script
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
#Make profile folder
New-Item -Path $PROFILE_FOLDER -ItemType Directory -Force > $null


#Checks if module is installed if not install Powershell modules
foreach ($_module_ in @("posh-git", "PSReadLine", "Terminal-Icons")) {
    if (-not (Get-InstalledModule | Where-Object { $_.Name -eq $_module_ })) {
        Install-Module -Name $_module_ -Scope CurrentUser -Force
    }
}
Remove-Variable _module_


#Directory of this repository
$pwshFilesDir = [IO.Path]::Combine("$HOME", "Github", "machine-Setup", "pwsh")
if (Test-Path $pwshFilesDir/*) {

    #Configure powershell with config files
    Get-ChildItem -Path $pwshFilesDir -Force |
        ForEach-Object {

            #Save file with same name but in PROFILE_FOLDER and a backup
            $pwshSetupFile = $_.FullName
            $pwshFile = [IO.Path]::Combine("$PROFILE_FOLDER", "$(Split-Path $pwshSetupFile -Leaf)")
            $backup = "${pwshFile}.bak"
            $_diff_ = ""

            #Scriptblock that copies files to PROFILE_FOLDER
            $copyPwshSetupFile = { Copy-Item -Path $pwshSetupFile -Destination $pwshFile -Force > $null }

            if (Test-Path $pwshFile -PathType Leaf) {
                #Use Compare-Object output to make a backup
                $_diff_ = Compare-Object (Get-Content $pwshFile) (Get-Content $pwshSetupFile) | ForEach-Object { "$($_.SideIndicator) $($_.InputObject)" }

                if (-not [string]::IsNullOrEmpty($_diff_)) {
                    #Backup file will be overwritten when a newer difference is found
                    Set-Content -Value $_diff_ -Path $backup
                    Write-Host "Backup was created for $(Split-Path $pwshFile -Leaf)"
                    Invoke-Command -ScriptBlock $copyPwshSetupFile
                }
            }
            else {
                #Run script block that copy the file
                Invoke-Command -ScriptBlock $copyPwshSetupFile
            }
        }

    #Remove foreach variables
    Remove-Variable pwshSetupFile, pwshFile, backup, copyPwshSetupFile, _diff_
}

#Remove pwsh repo directory variable
Remove-Variable pwshFilesDir
