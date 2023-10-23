#Variables
if ($null -ne $PROFILE.CurrentUserAllHosts) { Set-Variable PROFILE -Value $PROFILE.CurrentUserAllHosts }
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)


#Import modules
Import-Module posh-git, PSReadLine, Terminal-Icons


#Remove python venv appending to the prompt
$Env:VIRTUAL_ENV_DISABLE_PROMPT = 1

#Add config file to oh-my-posh
oh-my-posh init pwsh --config "$PROFILE_FOLDER/.omp.json" | Invoke-Expression


#PSReadLineOption
Set-PSReadLineOption -HistorySavePath "$PROFILE_FOLDER/history.txt"
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows

#VSCode terminal is too small for ListView
if ($Env:TERM_PROGRAM -ne 'vscode') {
    Set-PSReadLineOption -PredictionViewStyle ListView
}

#Add custom powershell keybings
if (Test-Path "$PROFILE_FOLDER/keys.ps1") {
    . "$PROFILE_FOLDER/keys.ps1"
}



#####################################################################
#################### Specific to Windows systems ####################
#####################################################################

if (-not $IsWindows -and $PSVersionTable.PSVersion.Major -gt 5) {
    return
}


#Variables
Set-Variable WINGET_LOGS -Value "$Env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir"
Set-Variable WINGET_PACKAGES -Value "$Env:TEMP\Winget"


function Update-CaskaydiaCoveNF () {
    . "$Env:USERPROFILE\Github\gist\caskaydiaCove\caskaydiaCove.ps1"
}


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
