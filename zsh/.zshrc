#Load zsh modules
autoload -U colors && colors
zmodload -i zsh/terminfo
zmodload -i zsh/datetime

#Define ZDOTDIR if it wasn't
ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}


#Set an update file and the current date in unix time
updatePlugins="$ZDOTDIR/.update-plugins"
todayDate=$(( EPOCHSECONDS / 60 / 60 / 24 ))

#Update zsh plugins by counting the number of days since last update
if [ ! -f "$updatePlugins" ] || (( ( $todayDate - $(cat "$updatePlugins") ) >= 7 ))
then
    #Function to shallow update a repo
    git_update_shallow_repo()
    {
        local repoDir="$1"
        [ -d "$repoDir/.git" ] && git -C "$repoDir" fetch --depth 1 -q && git -C "$repoDir" reset --hard FETCH_HEAD -q
    }

    #Update zsh plugins
    echo "Updating zsh plugins..."
    git_update_shallow_repo "$ZDOTDIR/zsh-completions"
    git_update_shallow_repo "$ZDOTDIR/zsh-autosuggestions"
    git_update_shallow_repo "$ZDOTDIR/zsh-syntax-highlighting"
    git_update_shallow_repo "$ZDOTDIR/zsh-history-substring-search"
    git_update_shallow_repo "$ZDOTDIR/powerlevel10k"

    #Send time to update file
    echo $todayDate >! "$updatePlugins"

    #Remove git update shallow function
    unset -f git_update_shallow_repo

    echo "Finished!"
fi

#Remove variables from the update of plugins
unset updatePlugins todayDate


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


#History file configuration options
HISTSIZE=10000
HISTFILE="$ZDOTDIR/.zhistory"
SAVEHIST=5000


#Check for zsh script and source it
check_and_source_script()
{
    local zshScript="$1"
    [ -f "$zshScript" ] && source "$zshScript"
}

#Source zsh config files
check_and_source_script "$ZDOTDIR/.setopt.zsh"
check_and_source_script "$ZDOTDIR/.zstyle.zsh"
check_and_source_script "$ZDOTDIR/.keys.zsh"
check_and_source_script "$ZDOTDIR/.alias.zsh"


#Add zsh-completions to fpath
[ -d "$ZDOTDIR/zsh-completions/src" ] && fpath=("$ZDOTDIR/zsh-completions/src" $fpath)

#Load completion module
autoload -Uz compinit
zmodload -i zsh/complist
compinit


#Start zsh plugins
check_and_source_script "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
check_and_source_script "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
check_and_source_script "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
check_and_source_script "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme"

#Add config file to powerlevel10k
check_and_source_script "$ZDOTDIR/.p10k.zsh"

#Remove variables from the update of plugins
unset -f check_and_source_script


#Check existence of repo
gh_install="$HOME/Github/gh-install"
if [ -d "$gh_install" ]
then
    alias gh-install="$gh_install/gh-install.sh"
fi
unset gh_install
