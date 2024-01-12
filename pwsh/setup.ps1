# Directory of profile script
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
# Make profile folder
New-Item -Path $PROFILE_FOLDER -ItemType Directory -Force > $null

# Check if module is installed if not install Powershell modules
foreach ($_module_ in @("posh-git", "PSReadLine", "Terminal-Icons")) {
    if (-not (Get-InstalledModule | Where-Object { $_.Name -eq $_module_ })) {
        Install-Module -Name $_module_ -Scope CurrentUser -Force
    }
}

# Get all pwsh files
Get-ChildItem -Path $PSScriptRoot -Exclude setup.ps1 -Force |
    ForEach-Object {
        Write-Output $_
        # Save file with same name but in PROFILE_FOLDER and a backup
        $pwshSetupFile = $_.FullName
        $pwshFile = [IO.Path]::Combine("$PROFILE_FOLDER", "$(Split-Path $pwshSetupFile -Leaf)")
        $backup = "${pwshFile}.bak"
        $_diff_ = ""

        #Test if pwsh file exists
        if (Test-Path $pwshFile -PathType Leaf) {
            # Use Compare-Object output to make a backup
            $_diff_ = Compare-Object (Get-Content $pwshFile) (Get-Content $pwshSetupFile) | ForEach-Object { "$($_.SideIndicator) $($_.InputObject)" }

            if (-not [string]::IsNullOrEmpty($_diff_)) {
                # Backup file will be overwritten when a newer difference is found
                Set-Content -Value $_diff_ -Path $backup
                Write-Host "Backup was created for $(Split-Path $pwshFile -Leaf)"
            }
            else {
                return
            }
        }
        # Copies files to PROFILE_FOLDER
        Copy-Item -Path $pwshSetupFile -Destination $pwshFile -Force > $null
    }
