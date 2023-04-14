#Aliases
Set-Alias arp-panel -Value appwiz.cpl
function arp-settings {Start-Process ms-settings:appsfeatures}  #only works if it is function
Set-Alias onedrive -Value "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"

#Variables
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)
Set-Variable OneDrive_PROFILE -Value "$env:USERPROFILE\OneDrive\Documents\WindowsPowerShell"
Set-Variable WINGET_LOGS -Value "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir"
Set-Variable WINGET_PACKAGES_TEMP -Value "$env:TEMP\Winget"
Set-Variable WINGET_DB_FILE -Value "$env:ProgramFiles\WindowsApps\Microsoft.Winget.Source_*_neutral_8wekyb3d8bbwe\Public"


#Terminal Icons
Import-Module -Name Terminal-Icons

#PSReadLine
Import-Module PSReadLine

#PSReadLineOption
Set-PSReadLineOption -HistorySavePath "$PROFILE_FOLDER\ConsoleHost_history.txt"
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows
if($env:TERM_PROGRAM -ne 'vscode'){
    Set-PSReadLineOption -PredictionViewStyle ListView
}


#OH-MY-POSH
oh-my-posh init `
    $(if ($PSVersionTable.PSVersion.Major -gt 5) { "pwsh" } else { "powershell" }) `
        --config "$OneDrive_PROFILE\ohmyposhCustome.omp.json" | Invoke-Expression


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
