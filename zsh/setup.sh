#!/bin/sh

# Change default shell to zsh
[ "$(basename "$(grep "$USER" /etc/passwd)")" != "zsh" ] && chsh -s "$(which zsh)"

# Add config dir for zsh
ZDOTDIR="$HOME/.config/zsh"
[ ! -d "$ZDOTDIR" ] && mkdir -p "$ZDOTDIR"
# Change zsh dotfiles to ~/.config/zsh
[ ! -f /etc/zsh/zshenv ] || grep -qxF "export ZDOTDIR=\$HOME/.config/zsh" /etc/zsh/zshenv \
    || [ ! -f "$HOME/.zshenv" ] || grep -qxF "export ZDOTDIR=\$HOME/.config/zsh" "$HOME/.zshenv" \
    || echo "export ZDOTDIR=\$HOME/.config/zsh" >> "$HOME/.zshenv"

# Function to shallow clone a repo
git_clone_shallow_repo()
{
    repoOwner="$1"
    repoName="$2"
    [ -d "$ZDOTDIR/$repoName" ] || git clone --depth=1 "https://github.com/$repoOwner/$repoName.git" "$ZDOTDIR/$repoName"
}

# Add zsh plugins
git_clone_shallow_repo zsh-users zsh-completions
git_clone_shallow_repo zsh-users zsh-autosuggestions
git_clone_shallow_repo zsh-users zsh-syntax-highlighting
git_clone_shallow_repo zsh-users zsh-history-substring-search
git_clone_shallow_repo romkatv   powerlevel10k

# Get all zsh files
for zshSetupFile in "$(dirname "$0")"/.z* "$(dirname "$0")"/.*.zsh; do

    # Save file with same name but in ZDOTDIR and a backup
    zshFile="$ZDOTDIR/$(basename "$zshSetupFile")"
    backup="$zshFile.bak"

    # Copy file if not in directory or are different from one another
    # And use diff output to make a backup if files are different
    # Backup file will be overwritten when a newer diff is found
    test -f "$zshFile" \
        && _diff_=$(command diff -u "$zshFile" "$zshSetupFile") \
        || command cp "$zshSetupFile" "$zshFile" \
        && [ -n "$_diff_" ] \
        && echo "$_diff_" > "$backup" \
        && echo "Backup was created for $(basename "$zshFile")"
done
