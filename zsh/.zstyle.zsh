#Highlight selection in menu complete
zstyle ':completion:*' menu select

#Accept only match without double tab
zstyle ':completion:*' accept-exact true

#Use completion cache
zstyle ':completion:*' use-cache true

#Make matches case-insensitive
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

#Reload new executables in path
zstyle ':completion:*' rehash true

#Add . and .. directories to matches
zstyle ':completion:*' special-dirs true

#Use same ls colors for completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"