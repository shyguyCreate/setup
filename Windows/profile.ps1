#Aliases
Set-Alias onedrive -Value "$Env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"

#Variables
#Set-Variable PROFILE -Value $PROFILE.CurrentUserAllHosts
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
Set-Variable WINGET_LOGS -Value "$Env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir"
Set-Variable WINGET_PACKAGES_TEMP -Value "$Env:TEMP\Winget"
Set-Variable WINGET_DB_FILE -Value "$Env:ProgramFiles\WindowsApps\Microsoft.Winget.Source_*_neutral_8wekyb3d8bbwe\Public"


#Terminal Icons
Import-Module -Name Terminal-Icons

#PSReadLine
Import-Module PSReadLine

#PSReadLineOption
Set-PSReadLineOption -HistorySavePath "$PROFILE_FOLDER\ConsoleHost_history.txt"
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows
if($Env:TERM_PROGRAM -ne 'vscode'){
    Set-PSReadLineOption -PredictionViewStyle ListView
}


#OH-MY-POSH
oh-my-posh init `
    $(if ($PSVersionTable.PSVersion.Major -gt 5) { "pwsh" } else { "powershell" }) `
        --config "$PROFILE_FOLDER\ohmyposhCustome.omp.json" | Invoke-Expression


#winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

#Get-PSReadLineKeyHandler output to file in Linux folder
Get-PSReadLineKeyHandler | ForEach-Object { 
    Write-Output ("Set-PSReadLineKeyHandler " + $_.Key + " " + $_.Function) 
} | Out-File "$Env:USERPROFILE\Github\installation-Setup\share\Get-PSReadLineKeyHandler.ps1"
