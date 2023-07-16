bindkey -e

# Home key
bindkey '^[[7~' beginning-of-line
bindkey '^[[H' beginning-of-line
[[ "${terminfo[khome]}" != "" ]] && bindkey "${terminfo[khome]}" beginning-of-line

# End key
bindkey '^[[8~' end-of-line
bindkey '^[[F' end-of-line
[[ "${terminfo[kend]}" != "" ]] && bindkey "${terminfo[kend]}" end-of-line

# Insert key
bindkey '^[[2~' overwrite-mode

# Delete key
bindkey '^[[3~' delete-char

# Left arrow
bindkey '^[[D'  backward-char

# Right arrow
bindkey '^[[C'  forward-char

# Ctrl + Left arrow
bindkey '^[[1;5D' backward-word

# Ctrl + Right arrow
bindkey '^[[1;5C' forward-word

# Up arrow
bindkey '^[[A' history-substring-search-up			
[[ "${terminfo[kcuu1]}" != "" ]] && bindkey "$terminfo[kcuu1]" history-substring-search-up

# Down arrow
bindkey '^[[B' history-substring-search-down
[[ "${terminfo[kcud1]}" != "" ]] && bindkey "$terminfo[kcud1]" history-substring-search-down

# Page up key
bindkey '^[[5~' history-beginning-search-backward
[[ "${terminfo[kpp]}" != "" ]] && bindkey "$terminfo[kpp]" history-beginning-search-backward

# Page down key
bindkey '^[[6~' history-beginning-search-forward
[[ "${terminfo[knp]}" != "" ]] && bindkey "$terminfo[knp]" history-beginning-search-forward

# Backspace key
bindkey '^?' backward-delete-char

# Supr key
bindkey '^[[3~' delete-char
[[ "${terminfo[kdch1]}" != "" ]] && bindkey "$terminfo[kdch1]" delete-char

# Ctrl + Backspace
bindkey '^H' backward-kill-word

# Ctrl + Supr
bindkey '^[[3;5~' kill-word

# Enter key
bindkey '^M' accept-line

# Ctrl + l
bindkey '^L' clear-screen

# Ctrl + z
bindkey '^Z' undo

# Shift + Tab
bindkey '^[[Z' reverse-menu-complete
[[ "${terminfo[kcbt]}" != "" ]] && bindkey "$terminfo[kcbt]" reverse-menu-complete

# Esc key
bindkey '^[' kill-whole-line
