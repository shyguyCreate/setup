#Search for the item in the history that starts with the current input when no ListView
if ("InlineView" -eq (Get-PSReadLineOption | Select-Object -ExpandProperty PredictionViewStyle))
{
    Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward

    #Add key binding to only move forward one word in suggestion
    Set-PSReadLineKeyHandler -Key Ctrl+RightArrow `
                             -BriefDescription NextWordAndAcceptNextSuggestionWord `
                             -LongDescription "Move cursor to the next word or accept the next word in suggestion when it's at the end of current editing line" `
                             -ScriptBlock {
        param($key, $arg)

        $line = $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($cursor -lt $line.Length) {
            [Microsoft.PowerShell.PSConsoleReadLine]::NextWord($key, $arg)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
        }
    }
}


#Add key binding to delete matching quotes or braces with backspace
Set-PSReadLineKeyHandler -Chord Backspace `
                         -BriefDescription SmartBackspace `
                         -LongDescription "Delete previous char or matching quotes and braces" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $cursor = $null
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
Set-PSReadLineKeyHandler -Key Ctrl+q,Alt+q `
                         -BriefDescription SaveToHistory `
                         -LongDescription "Save current line in history but do not execute" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}


#Add key binding to insert matching quotes
Set-PSReadLineKeyHandler -Chord '"',"'" `
                         -BriefDescription SmartQuotes `
                         -LongDescription "Insert matching quotes" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $cursor = $selectionStart = $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
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
Set-PSReadLineKeyHandler -Chord '{' `
                         -BriefDescription SmartBraces `
                         -LongDescription "Insert matching braces" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $cursor = $selectionStart = $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    if ($selectionStart -ne -1)
    {
      #Text is selected, wrap it in braces
      [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '{' + $line.SubString($selectionStart, $selectionLength) + '}')
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    elseif ($line[$cursor] -match '\S')
    {
        #Add another brace if next character is the same char
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('{')
    }
    else {
        #Insert matching braces, move cursor in between
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('{}')
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

#Add key binding to insert matching parentheses
Set-PSReadLineKeyHandler -Chord '(' `
                         -BriefDescription SmartParentheses `
                         -LongDescription "Insert matching parentheses" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $cursor = $selectionStart = $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    if ($selectionStart -ne -1)
    {
      #Text is selected, wrap it in parentheses
      [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    elseif ($line[$cursor] -match '\S')
    {
        #Add another brace if next character is the same char
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
    }
    else {
        #Insert matching parentheses, move cursor in between
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('()')
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

#Add key binding to insert matching brackets
Set-PSReadLineKeyHandler -Chord '[' `
                         -BriefDescription SmartBrackets `
                         -LongDescription "Insert matching brackets" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $cursor = $selectionStart = $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    if ($selectionStart -ne -1)
    {
      #Text is selected, wrap it in brackets
      [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '[' + $line.SubString($selectionStart, $selectionLength) + ']')
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    elseif ($line[$cursor] -match '\S')
    {
        #Add another brace if next character is the same char
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('[')
    }
    else {
        #Insert matching brackets, move cursor in between
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('[]')
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}
