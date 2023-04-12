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
Set-PSReadLineOption -PredictionViewStyle InlineView

#PSReadLineKeyHandler
Set-PSReadLineKeyHandler -Key Ctrl+h -Function BackwardDeleteChar
Set-PSReadLineKeyHandler -Key Ctrl+End -Function ForwardDeleteInput
Set-PSReadLineKeyHandler -Key Ctrl+Delete -Function KillWord
Set-PSReadLineKeyHandler -Key Ctrl+Spacebar -Function MenuComplete
Set-PSReadLineKeyHandler -Key PageDown -Function ScrollDisplayDown
Set-PSReadLineKeyHandler -Key Ctrl+PageDown -Function ScrollDisplayDownLine
Set-PSReadLineKeyHandler -Key PageUp -Function ScrollDisplayUp
Set-PSReadLineKeyHandler -Key Ctrl+PageUp -Function ScrollDisplayUpLine
#Alternatives
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+m -Function MenuComplete


#OH-MY-POSH
oh-my-posh init pwsh --config "$PROFILE_FOLDER/ohmyposhCustome.omp.json" | Invoke-Expression
