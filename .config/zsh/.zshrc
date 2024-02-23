# Print help message if tmp file and script exist
if [ ! -f /tmp/.zplugins ] && [ -f "$ZDOTDIR/.zplugins" ]; then
    printf "Update zsh plugins with 'source \$ZDOTDIR/.zplugins'\n\n"
    touch /tmp/.zplugins
fi

# Load zsh modules
autoload -U colors && colors
zmodload -i zsh/terminfo
zmodload -i zsh/datetime

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History file configuration options
export HISTSIZE=10000
export HISTFILE="$HOME/.local/state/zsh/history"
export SAVEHIST=5000

# Add zsh-completions to fpath
[ -d "$ZDOTDIR/zsh-completions/src" ] && fpath=("$ZDOTDIR/zsh-completions/src" $fpath)

# Load completion module
autoload -Uz compinit
zmodload -i zsh/complist
compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

# Check for zsh script and source it
source_script() {
    [ -f "$1" ] && source "$1"
}

# Source zsh config files
source_script "$ZDOTDIR/.setopt"
source_script "$ZDOTDIR/.zstyle"
source_script "$ZDOTDIR/.bindkey"
source_script "$ZDOTDIR/.alias"

# Load zsh plugins
source_script "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_script "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source_script "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
source_script "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme"

# Source powerlevel10k config file
source_script "$ZDOTDIR/.p10k.zsh"

# Remove source function
unset -f source_script
