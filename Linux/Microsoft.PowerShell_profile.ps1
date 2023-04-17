#Aliases

#GNOME Apps
#Set-Alias notepad -Value gnome-text-editor
#Set-Alias explorer -Value nautilus
#KDE Apps
Set-Alias notepad -Value kate
Set-Alias explorer -Value dolphin

#Variables
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)


#Terminal Icons
Import-Module -Name Terminal-Icons

#PSReadLine
Import-Module PSReadLine

#PSReadLineOption
Set-PSReadLineOption -HistorySavePath "$PROFILE_FOLDER/ConsoleHost_history.txt"
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows
if($Env:TERM_PROGRAM -ne 'vscode'){
    Set-PSReadLineOption -PredictionViewStyle ListView
}

#Set-PSReadLineKeyHandler with keys in Windows folder
. $Env:HOME/Github/installation-Setup/Linux/Get-PSReadLineKeyHandler.ps1


#OH-MY-POSH
oh-my-posh init pwsh --config "$PROFILE_FOLDER/ohmyposhCustome.omp.json" | Invoke-Expression
