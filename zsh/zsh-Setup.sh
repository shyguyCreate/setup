#!/bin/sh

#Add config dir for zsh
ZDOTDIR="$HOME/.config/zsh"
mkdir -p "$ZDOTDIR"
#Add config file to change ZDOTDIR
[ -f /etc/zsh/zshenv ] && grep -qxF "export ZDOTDIR=\$HOME/.config/zsh" /etc/zsh/zshenv || echo "export ZDOTDIR=\$HOME/.config/zsh" | sudo tee -a /etc/zsh/zshenv > /dev/null


#Add zsh plugins
             [ -d "$ZDOTDIR/zsh-completions" ] || git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-completions.git
         [ -d "$ZDOTDIR/zsh-autosuggestions" ] || git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git
     [ -d "$ZDOTDIR/zsh-syntax-highlighting" ] || git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git
[ -d "$ZDOTDIR/zsh-history-substring-search" ] || git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git
               [ -d "$ZDOTDIR/powerlevel10k" ] || git -C "$ZDOTDIR" clone --depth=1 https://github.com/romkatv/powerlevel10k.git

#Change default shell to zsh
[ "$(basename "$SHELL")" != "zsh" ] && chsh -s "$(which zsh)"


#Directory of this repository
machineSetup="$HOME/Github/machine-Setup"

if [ -d "$machineSetup" ]
then
    #Configure zsh with dot files
    command ln -sf "$machineSetup/zsh/.zshrc" "$ZDOTDIR"
    command ln -sf "$machineSetup/zsh/.setopt.zsh" "$ZDOTDIR"
    command ln -sf "$machineSetup/zsh/.zstyle.zsh" "$ZDOTDIR"
    command ln -sf "$machineSetup/zsh/.keys.zsh" "$ZDOTDIR"
    command ln -sf "$machineSetup/zsh/.alias.zsh" "$ZDOTDIR"
    command cp "$machineSetup/zsh/.p10k.zsh" "$ZDOTDIR"
    command patch -sd "$ZDOTDIR" < "$machineSetup/zsh/.p10k.zsh.diff"
fi
