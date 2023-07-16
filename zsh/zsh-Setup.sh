#!/bin/sh

#Add config dir for zsh
ZDOTDIR="$HOME/.config/zsh"
mkdir -p "$ZDOTDIR"
#Add config file to change ZDOTDIR
[ -f /etc/zsh/zshenv ] && grep -qxF "export ZDOTDIR=\$HOME/.config/zsh" /etc/zsh/zshenv || echo "export ZDOTDIR=\$HOME/.config/zsh" | sudo tee -a /etc/zsh/zshenv > /dev/null


#Add zsh plugins
git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-completions.git
git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git
git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git
git -C "$ZDOTDIR" clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git
git -C "$ZDOTDIR" clone --depth=1 https://github.com/romkatv/powerlevel10k.git

#Change default shell to zsh
[ "$(basename "$SHELL")" != "zsh" ] && chsh -s "$(which zsh)"


#Directory of this repository
machineSetup="$HOME/Github/machine-Setup"

if [ -d "$machineSetup" ]
then
    #Configure zsh with dot files
    cp "$machineSetup/zsh/.zshrc" "$ZDOTDIR"
    cp "$machineSetup/zsh/.keys.zsh" "$ZDOTDIR"
    cp "$machineSetup/zsh/.alias.zsh" "$ZDOTDIR"
    cp "$machineSetup/zsh/.p10k.zsh" "$ZDOTDIR"
    patch -sd "$ZDOTDIR" < "$machineSetup/zsh/.p10k.zsh.diff"
fi
