#Variables
#Set-Variable PROFILE -Value $PROFILE.CurrentUserAllHosts
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)


#Import modules
Import-Module PSReadLine
Import-Module posh-git
Import-Module Terminal-Icons


#PSReadLineOption
Set-PSReadLineOption -HistorySavePath "$PROFILE_FOLDER/ConsoleHost_history.txt"
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows
if($Env:TERM_PROGRAM -ne 'vscode'){
    Set-PSReadLineOption -PredictionViewStyle ListView
}

#Set-PSReadLineKeyHandler with keys in share folder
. $Env:HOME/Github/installation-Scripts/share/keyHandler.ps1


#OH-MY-POSH
oh-my-posh init pwsh --config "$PROFILE_FOLDER/ohmyposh.omp.json" | Invoke-Expression

function Update-OhMyPosh
{
    #Create directory for ohmyposh installation
    mkdir -p $HOME/.local/bin
    #Update ohmyposh
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin
}
