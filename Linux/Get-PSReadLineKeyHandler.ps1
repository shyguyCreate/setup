Set-PSReadLineKeyHandler Enter AcceptLine
Set-PSReadLineKeyHandler Shift+Enter AddLine
Set-PSReadLineKeyHandler Backspace BackwardDeleteChar
Set-PSReadLineKeyHandler Ctrl+h BackwardDeleteChar
Set-PSReadLineKeyHandler Ctrl+Home BackwardDeleteInput
Set-PSReadLineKeyHandler Ctrl+Backspace BackwardKillWord
Set-PSReadLineKeyHandler Ctrl+w BackwardKillWord
Set-PSReadLineKeyHandler Ctrl+C Copy
Set-PSReadLineKeyHandler Ctrl+c CopyOrCancelLine
Set-PSReadLineKeyHandler Ctrl+x Cut
Set-PSReadLineKeyHandler Delete DeleteChar
Set-PSReadLineKeyHandler Ctrl+End ForwardDeleteInput
Set-PSReadLineKeyHandler Ctrl+Enter InsertLineAbove
Set-PSReadLineKeyHandler Shift+Ctrl+Enter InsertLineBelow
Set-PSReadLineKeyHandler Alt+d KillWord
Set-PSReadLineKeyHandler Ctrl+Delete KillWord
Set-PSReadLineKeyHandler Ctrl+v Paste
Set-PSReadLineKeyHandler Shift+Insert Paste
Set-PSReadLineKeyHandler Ctrl+y Redo
Set-PSReadLineKeyHandler Escape RevertLine
Set-PSReadLineKeyHandler Ctrl+z Undo
Set-PSReadLineKeyHandler Alt+. YankLastArg
Set-PSReadLineKeyHandler LeftArrow BackwardChar
Set-PSReadLineKeyHandler Ctrl+LeftArrow BackwardWord
Set-PSReadLineKeyHandler Home BeginningOfLine
Set-PSReadLineKeyHandler End EndOfLine
Set-PSReadLineKeyHandler RightArrow ForwardChar
Set-PSReadLineKeyHandler Ctrl+] GotoBrace
Set-PSReadLineKeyHandler Ctrl+RightArrow NextWord
Set-PSReadLineKeyHandler Ctrl+s ForwardSearchHistory
Set-PSReadLineKeyHandler F8 HistorySearchBackward
Set-PSReadLineKeyHandler Shift+F8 HistorySearchForward
Set-PSReadLineKeyHandler DownArrow NextHistory
Set-PSReadLineKeyHandler UpArrow PreviousHistory
Set-PSReadLineKeyHandler Ctrl+r ReverseSearchHistory
Set-PSReadLineKeyHandler Ctrl+@ MenuComplete
Set-PSReadLineKeyHandler Ctrl+Spacebar MenuComplete
Set-PSReadLineKeyHandler Tab TabCompleteNext
Set-PSReadLineKeyHandler Shift+Tab TabCompletePrevious
Set-PSReadLineKeyHandler F2 SwitchPredictionView
Set-PSReadLineKeyHandler Ctrl+l ClearScreen
Set-PSReadLineKeyHandler Alt+0 DigitArgument
Set-PSReadLineKeyHandler Alt+1 DigitArgument
Set-PSReadLineKeyHandler Alt+2 DigitArgument
Set-PSReadLineKeyHandler Alt+3 DigitArgument
Set-PSReadLineKeyHandler Alt+4 DigitArgument
Set-PSReadLineKeyHandler Alt+5 DigitArgument
Set-PSReadLineKeyHandler Alt+6 DigitArgument
Set-PSReadLineKeyHandler Alt+7 DigitArgument
Set-PSReadLineKeyHandler Alt+8 DigitArgument
Set-PSReadLineKeyHandler Alt+9 DigitArgument
Set-PSReadLineKeyHandler Alt+- DigitArgument
Set-PSReadLineKeyHandler PageDown ScrollDisplayDown
Set-PSReadLineKeyHandler Ctrl+PageDown ScrollDisplayDownLine
Set-PSReadLineKeyHandler PageUp ScrollDisplayUp
Set-PSReadLineKeyHandler Ctrl+PageUp ScrollDisplayUpLine
Set-PSReadLineKeyHandler F1 ShowCommandHelp
Set-PSReadLineKeyHandler Ctrl+Alt+? ShowKeyBindings
Set-PSReadLineKeyHandler Alt+h ShowParameterHelp
Set-PSReadLineKeyHandler Alt+? WhatIsKey
Set-PSReadLineKeyHandler Ctrl+a SelectAll
Set-PSReadLineKeyHandler Shift+LeftArrow SelectBackwardChar
Set-PSReadLineKeyHandler Shift+Home SelectBackwardsLine
Set-PSReadLineKeyHandler Shift+Ctrl+LeftArrow SelectBackwardWord
Set-PSReadLineKeyHandler Alt+a SelectCommandArgument
Set-PSReadLineKeyHandler Shift+RightArrow SelectForwardChar
Set-PSReadLineKeyHandler Shift+End SelectLine
Set-PSReadLineKeyHandler Shift+Ctrl+RightArrow SelectNextWord
Set-PSReadLineKeyHandler F3 CharacterSearch
Set-PSReadLineKeyHandler Shift+F3 CharacterSearchBackward
