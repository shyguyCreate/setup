# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

HISTSIZE=10000
HISTFILE="$ZDOTDIR/.zhistory"
SAVEHIST=5000


autoload -U colors && colors
zmodload -i zsh/terminfo
zmodload -i zsh/datetime


#Update zsh plugins by counting the num of days since last update
if [ ! -f "$ZDOTDIR/.update-plugins" ] || (( 7 < ( $(( EPOCHSECONDS / 60 / 60 / 24 )) - $(cat "$ZDOTDIR/.update-plugins") ) ))
then
  function git_update_shallow_repo() {
    [ -d "$1/.git" ] && git -C "$1" fetch --depth 1 -q && git -C "$1" reset --hard FETCH_HEAD -q
  }
  git_update_shallow_repo "$ZDOTDIR/zsh-completions"
  git_update_shallow_repo "$ZDOTDIR/zsh-autosuggestions"
  git_update_shallow_repo "$ZDOTDIR/zsh-syntax-highlighting"
  git_update_shallow_repo "$ZDOTDIR/zsh-history-substring-search"
  git_update_shallow_repo "$ZDOTDIR/powerlevel10k"

  echo $(( EPOCHSECONDS / 60 / 60 / 24 )) >! "$ZDOTDIR/.update-plugins"

  unset -f git_update_shallow_repo
fi


#Add custom zsh setopts
[ -f "$ZDOTDIR/.setopt.zsh" ] && source "$ZDOTDIR/.setopt.zsh"
#Add custom zsh styles
[ -f "$ZDOTDIR/.zstyle.zsh" ] && source "$ZDOTDIR/.zstyle.zsh"
#Add custom key bindings
[ -f "$ZDOTDIR/.keys.zsh" ] && source "$ZDOTDIR/.keys.zsh"
#Add custom alias
[ -f "$ZDOTDIR/.alias.zsh" ] && source "$ZDOTDIR/.alias.zsh"


#Add zsh-completions to fpath
[ -d "$ZDOTDIR/zsh-completions/src" ] && fpath=("$ZDOTDIR/zsh-completions/src" $fpath)

autoload -Uz compinit
zmodload -i zsh/complist
compinit


#Start zsh plugins
[ -f "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && source "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"


#Start powerlevel10k theme
[ -f "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme" ] && source "$ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme"

#Add config file to powerlevel10k
[ -f "$ZDOTDIR/.p10k.zsh" ] && source "$ZDOTDIR/.p10k.zsh"


if [ -d "$HOME/Github/install-Programs" ]
then
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
        alias "update-$(basename "${script%.sh}")"="$script"
      else
        alias "update-$(basename "${script%.sh}")"=". $script"
      fi
  done
fi
