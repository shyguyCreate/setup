#Variables
if ($null -ne $PROFILE.CurrentUserAllHosts) { Set-Variable PROFILE -Value $PROFILE.CurrentUserAllHosts }
Set-Variable PROFILE_FOLDER -Value (Split-Path $PROFILE -Parent)


#Import modules
Import-Module posh-git,PSReadLine,Terminal-Icons


#OH-MY-POSH
oh-my-posh init pwsh --config "$PROFILE_FOLDER/.omp.json" | Invoke-Expression


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
    Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward

    #Add key binding to only move forward one word in suggestion
    Set-PSReadLineKeyHandler -Key RightArrow `
                         -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
                         -LongDescription "Move cursor one character to the right or accept the next word in suggestion when it's at the end of current editing line" `
                         -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($cursor -lt $line.Length)
        {
            [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
        }
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
        }
    }

    #Add key binding to enter suggestion with End key
    Set-PSReadLineKeyHandler -Key End `
                         -BriefDescription EndOfLineAndAcceptSuggestion `
                         -LongDescription "Move cursor to the end or accept suggestion when it's at the end of current editing line" `
                         -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($cursor -lt $line.Length)
        {
            [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine($key, $arg)
        }
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
        }
    }
}


#Add key binding to insert matching quotes
Set-PSReadLineKeyHandler -Chord '"',"'" `
                         -BriefDescription SmartInsertQuotes `
                         -LongDescription "Insert matching quotes" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    if ($selectionStart -ne -1)
    {
      #Text is selected, wrap it in quotes
      [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $key.KeyChar)
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    elseif ($line[$cursor-1],$line[$cursor] -match '\S')
    {
        #Add another quotes if next character is the same char
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($key.KeyChar)
    }
    else {
        #Insert matching quotes, move cursor in between
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

#Add key binding to insert matching braces
Set-PSReadLineKeyHandler -Chord '(','{','[' `
                         -BriefDescription SmartInsertBraces `
                         -LongDescription "Insert matching braces" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $closeChar = switch ($key.KeyChar) {
        '(' { [char]')'; break }
        '{' { [char]'}'; break }
        '[' { [char]']'; break }
    }

    if ($selectionStart -ne -1)
    {
      #Text is selected, wrap it in braces
      [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    elseif ($line[$cursor] -match '\S')
    {
        #Add another brace if next character is the same char
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($key.KeyChar)
    }
    else {
        #Insert matching braces, move cursor in between
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

#Add key binding to delete matching quotes or braces with backspace
Set-PSReadLineKeyHandler -Chord Backspace `
                         -BriefDescription SmartBackspace `
                         -LongDescription "Delete previous char or matching quotes and braces" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -le 0) {
        return
    }

    if ($cursor -lt $line.Length)
    {
        $toMatch = switch ($line[$cursor]) {
            '"' { [char]'"'; break }
            "'" { [char]"'"; break }
            ')' { [char]'('; break }
            ']' { [char]'['; break }
            '}' { [char]'{'; break }
        }

        if ($line[$cursor-1] -eq $toMatch) {
            #Remove char in cursor if equal to match
            [Microsoft.PowerShell.PSConsoleReadLine]::DeleteChar($key, $arg)
        }
    }
    #Delete char before cursor (like normal backspace)
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
}

#Add key binding to delete save current line in history without executing
Set-PSReadLineKeyHandler -Key F12 `
                         -BriefDescription SaveToHistory `
                         -LongDescription "Save current line in history but do not execute" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}


############# Specific to Windows systems ####################
if (($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) -and (Test-Path "$PROFILE_FOLDER\profileMS.ps1"))
{
    . "$PROFILE_FOLDER\profileMS.ps1"
}
