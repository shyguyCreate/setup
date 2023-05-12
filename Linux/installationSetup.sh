################ GET ALL PACKAGES AND DEPENDECIES FOR BROADCOM WIFI DRIVER ################

#Create directories for pacman cache and db
#mkdir -p /tmp/blankdb $HOME/BroadcomPackages

#Rename pacman CacheDir to force download of all packages and dependecies
#sudo mv $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/}) $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/}Tmp)

#Print kernel release to know what linux-headers to install
#uname -r

#Print network controller to know what wifi driver to install (for this case broadcom)
#lspci | grep network -i

#Download all packages and dependecies for broadcom wifi driver inside custom CacheDir
#sudo pacman -Syw --cachedir $HOME/BroadcomPackages --dbpath /tmp/blankdb base-devel linux-headers broadcom-wl-dkms

#Revert rename of pacman CacheDir
#sudo mv $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/}Tmp) $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/})

###########################################################################################


#Install downloaded packages and dependecies
sudo pacman -U $HOME/BroadcomPackages/*[^sig] --needed

#Remove modules and load wl for broadcom wifi driver and update dependencies
sudo rmmod b43 ssb
sudo modprobe wl
sudo depmod -a


#Update system
sudo pacman -Syu


#Install GUI for printer
sudo pacman -S system-config-printer --needed
#Add printer support for USB
sudo pacman -S cups cups-pdf --needed
sudo systemctl enable --now cups
#Add wireless printer support
sudo pacman -S avahi nss-mdns --needed
sudo systemctl enable avahi-daemon.service
#Enable Avahi support for hostname resolution
echo 'Edit /etc/nsswitch.conf and change the hosts line to look like this:
"hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns"'


#Install git and add user name and email
sudo pacman -S git --needed
git config --global user.name shyguyCreate
git config --global user.email 107062289+shyguyCreate@users.noreply.github.com


#Get yay to install google-chrome
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -S google-chrome


#Install zsh
sudo pacman -S zsh --needed
#Install zsh plugins
sudo pacman -S zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search --needed


#Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
#Show Oh-My-Zsh prompt (in Manjaro)
echo 'Comment this lines from /usr/share/zsh/manjaro-zsh-prompt to show Oh-My-Zsh prompt
      source /usr/share/zsh/p10k-portable.zsh
      source /usr/share/zsh/p10k.zsh'
#Combine zshrc files
if [ -f ~/.zshrc.pre-oh-my-zsh ]; then
    mv ~/.zshrc ~/.zshrc.oh-my-zsh && cat ~/.zshrc.pre-oh-my-zsh ~/.zshrc.oh-my-zsh > ~/.zshrc
fi


#Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#Change ZSH_THEME in zshrc
echo 'Change ZSH_THEME in zshrc to "powerlevel10k/powerlevel10k"'


#Download Meslo Nerd Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip -O $HOME/Downloads/Meslo.zip
#Remove font folder if exist and Extract fonts
rm -rf $HOME/Downloads/Meslo  &&  mkdir -p $_  &&  ark -b $HOME/Downloads/Meslo.zip --destination $_
#Install fonts globally
sudo mkdir -p /usr/local/share/fonts/Meslo && sudo cp $HOME/Downloads/Meslo/MesloLGSNerdFont-*.ttf $_


#Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#Write brew lines to .zshrc
echo '
#BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#BREW COMPLETION
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi
' >> $HOME/.zshrc
#Use brew in the same session without reloading
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)


#Install github cli
brew install go gh


#Install snap
sudo pacman -S snapd --needed
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap


#Install vscode
sudo snap install code --classic


#Install powershell
sudo snap install powershell --classic
mkdir -p $HOME/.config/powershell

#Make directory for Github and gists
mkdir -p $HOME/Github/gist
#Clone git repository from this script
git clone https://github.com/shyguyCreate/installation-Setup.git $HOME/Github/installation-Setup

#Create symbolic link to powershell profile file
ln -s $HOME/Github/installation-Setup/Linux/profile.ps1 $HOME/.config/powershell/profile.ps1

#Install Oh-My-Posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh
#Get ohmyposh config from gist
git clone https://gist.github.com/387ff25579b25bff63a6bc1a7635be27.git $HOME/Github/gist/ohmyposh
#Create symbolic link of ohmyposh to powershell profile file
ln -s $HOME/Github/gist/ohmyposh/ohmyposhCustome.omp.json $HOME/.config/powershell/ohmyposhCustome.omp.json

#Install Powershell modules
pwsh -NoProfile -c "& { Install-Module -Name Terminal-Icons -Scope CurrentUser -Force }"
pwsh -NoProfile -c "& { Install-Module -Name PSReadLine -Scope CurrentUser -Force }"


#Install bash-language-server for bash completion inside text editors
sudo pacman -S bash-language-server --needed
#Install aditional software
sudo pacman -S firefox onlyoffice-desktopeditors vlc obs-studio gimp shotcut --needed

#Clone zoomInstaller gist
git clone https://gist.github.com/fdec7db1dfe9588c0c3d735d142fcf41.git $HOME/Github/gist/zoomInstaller
#Install zoom from script
source $HOME/Github/gist/zoomInstaller/zoomInstaller.sh
#Add alias to update zoom
echo "
alias zoomUpdate='source \$HOME/Github/gist/zoomInstaller/zoomInstaller.sh'
" >> $HOME/.zshrc
