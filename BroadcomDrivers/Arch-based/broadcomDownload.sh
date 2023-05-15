################ GET ALL PACKAGES AND DEPENDECIES FOR BROADCOM WIFI DRIVER ################

#Variables
tmpDir=/tmp/blankdb
packagesDir=$HOME/BroadcomPackages
cacheDir=$(echo ${$(pacman -v 2>/dev/null | grep Cache | awk '{print $3}')%/})

#Create directories for pacman cache and db
mkdir -p $tmpDir $packagesDir

#Rename pacman CacheDir to force download of all packages and dependecies
sudo mv $cacheDir ${cacheDir}Tmp

#Print network controller to know what wifi driver to install
lspci | grep network -i

#Print kernel release to know what linux-headers to install
uname -r

#Download all packages and dependecies for broadcom wifi driver inside custom CacheDir
sudo pacman -Syyw --cachedir $packagesDir --dbpath $tmpDir base-devel linux-headers broadcom-wl-dkms

#Revert rename of pacman CacheDir
sudo mv ${cacheDir}Tmp $cacheDir

###########################################################################################
