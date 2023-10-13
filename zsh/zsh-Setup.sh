#!/bin/sh

#Add config dir for zsh
ZDOTDIR="$HOME/.config/zsh"
mkdir -p "$ZDOTDIR"
#Add config file to change ZDOTDIR
[ -f /etc/zsh/zshenv ] && grep -qxF "export ZDOTDIR=\$HOME/.config/zsh" /etc/zsh/zshenv || echo "export ZDOTDIR=\$HOME/.config/zsh" | sudo tee -a /etc/zsh/zshenv > /dev/null

#Function to shallow clone a repo
git_clone_shallow_repo()
{
    repoOwner="$1"
    repoName="$2"
    [ -d "$ZDOTDIR/$repoName" ] || git clone --depth=1 "https://github.com/$repoOwner/$repoName.git" "$ZDOTDIR/$repoName"
}

#Add zsh plugins
git_clone_shallow_repo zsh-users zsh-completions
git_clone_shallow_repo zsh-users zsh-autosuggestions
git_clone_shallow_repo zsh-users zsh-syntax-highlighting
git_clone_shallow_repo zsh-users zsh-history-substring-search
git_clone_shallow_repo romkatv   powerlevel10k

#Remove git clone shallow function
unset -f git_clone_shallow_repo

#Change default shell to zsh
[ "$(basename "$SHELL")" != "zsh" ] && chsh -s "$(which zsh)"

#Directory of this repository
zshFilesDir="$HOME/Github/machine-Setup/zsh"
if [ -d "$zshFilesDir" ] &&  [ -n "$(ls -A "$zshFilesDir")" ]; then

    #Get all files inside zsh folder
    for file in "$zshFilesDir/"*; do

        #Save file with same name but in ZDOTDIR and a backup
        zdotFile="$ZDOTDIR/$(basename "$file")"
        backup="$zdotFile.bak"

        #Copy file if not in directory or are different from one another
        #And use diff output to make a backup if files are different
        #Backup file will be overwritten when a newer diff is found
        test -f "$zdotFile" \
            && _diff=$(command diff -u "$file" "$zdotFile") \
            || command cp "$file" "$zdotFile" \
            && [ -n "$_diff" ] \
            && echo "$_diff" > "$backup" \
            && echo "Backup was created for $(basename "$file")"
    done

    #Remove foreach variables
    unset zdotFile backup _diff
fi

#Remove zsh repo directory variable
unset zshFilesDir
