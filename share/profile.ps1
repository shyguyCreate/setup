#Variables
#Set-Variable PROFILE -Value $PROFILE.CurrentUserAllHosts
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)


#Import modules
Import-Module posh-git,PSReadLine,Terminal-Icons


#OH-MY-POSH
oh-my-posh init pwsh --config "$PROFILE_FOLDER/ohmyposh.omp.json" | Invoke-Expression


function Update-OhMyPosh
{
    if ( $IsLinux )
    {
        curl -s https://ohmyposh.dev/install.sh | bash -s
    }
    if ( $IsWindows )
    {
        winget upgrade JanDeDobbeleer.OhMyPosh -s winget
    }
    if ( $IsMacOS )
    {
        brew update && brew upgrade oh-my-posh
    }
}


#PSReadLineOption
Set-PSReadLineOption -HistorySavePath "$PROFILE_FOLDER/ConsoleHost_history.txt"
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows

#VSCode terminal is too small for ListView
if($Env:TERM_PROGRAM -ne 'vscode')
{
    Set-PSReadLineOption -PredictionViewStyle ListView
}
#Search for the item in the history that starts with the current input when no ListView
if ("InlineView" -eq (Get-PSReadLineOption | Select-Object -ExpandProperty PredictionViewStyle))
{
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}


#Add key binding to insert paired quotes
Set-PSReadLineKeyHandler -Chord '"',"'" `
                         -BriefDescription SmartInsertQuote `
                         -LongDescription "Insert paired quotes" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    
    if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
        #Add another quote if next character is also a quote
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($key.KeyChar)
    }
    else {
        #Insert matching quotes, move cursor to be in between the quotes
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}

#Add key binding to insert matching braces
Set-PSReadLineKeyHandler -Key '(','{','[' `
                         -BriefDescription SmartInsertBraces `
                         -LongDescription "Insert matching braces" `
                         -ScriptBlock {
    param($key, $arg)

    $closeChar = switch ($key.KeyChar)
    {
        '(' { [char]')'; break }
        '{' { [char]'}'; break }
        '[' { [char]']'; break }
    }

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)

}

Set-PSReadLineKeyHandler -Key Backspace `
                         -BriefDescription SmartBackspace `
                         -LongDescription "Delete previous character or matching quotes and braces" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $toMatch = switch ($line[$cursor])
    {
            '"' { [char]'"'; break }
            "'" { [char]"'"; break }
            ')' { [char]'('; break }
            ']' { [char]'['; break }
            '}' { [char]'{'; break }
    }

    if ($line[$cursor-1] -eq $toMatch)
    {
        #Remove char before cursor and in cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
    }
    else
    {
        #Delete char in cursor (like normal backspace)
        [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
    }
}


############# Specific to Windows systems ####################
if ( -not $IsWindows ) {
    return
}

#Variables
Set-Variable WINGET_LOGS -Value "$Env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir"
Set-Variable WINGET_PACKAGES_TEMP -Value "$Env:TEMP\Winget"


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
