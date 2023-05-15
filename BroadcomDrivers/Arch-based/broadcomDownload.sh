################ GET ALL PACKAGES AND DEPENDECIES FOR BROADCOM WIFI DRIVER ################

#Create directories for pacman cache and db
mkdir -p /tmp/blankdb $HOME/BroadcomPackages

#Rename pacman CacheDir to force download of all packages and dependecies
sudo mv $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/}) $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/}Tmp)

#Print network controller to know what wifi driver to install
lspci | grep network -i

#Print kernel release to know what linux-headers to install
uname -r

#Download all packages and dependecies for broadcom wifi driver inside custom CacheDir
sudo pacman -Syyw --cachedir $HOME/BroadcomPackages --dbpath /tmp/blankdb base-devel linux-headers broadcom-wl-dkms

#Revert rename of pacman CacheDir
sudo mv $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/}Tmp) $(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/})

###########################################################################################