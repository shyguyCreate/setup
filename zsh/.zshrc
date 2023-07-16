# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

HISTSIZE=10000
HISTFILE="$ZDOTDIR/.history"
SAVEHIST=10000

#Start zsh plugins
[ -d "$ZDOTDIR/zsh-completions/src" ] && fpath=("$ZDOTDIR/zsh-completions/src" $fpath)
[ -f "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && source "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
[ -f "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme" ] && source "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme"

#Add custom key bindings
[ -f "$ZDOTDIR/.keys.zsh" ] && source "$ZDOTDIR/.keys.zsh"
#Add custom alias
[ -f "$ZDOTDIR/.alias.zsh" ] && source "$ZDOTDIR/.alias.zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"


#Check updates for all programs in one function
installPrograms="$HOME/Github/install-Programs"
update-Programs()
{
    for script in "$installPrograms"/*.sh; do
        if [ -x $script ]; then
          "$script" $@
        else
          . "$script" $@
        fi
    done
}

#Add aliases for all programs inside repo
for script in "$installPrograms"/*.sh; do
    if [ -x $script ]; then
      alias "$(basename "${script%.sh}")-Update"="$script"
    else
      alias "$(basename "${script%.sh}")-Update"=". $script"
    fi
done
