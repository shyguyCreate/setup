################ INSTALL PACKAGES AND DEPENDECIES FOR BROADCOM WIFI DRIVER ################

#Variables
packagesDir=$HOME/BroadcomPackages

#Test if packages from the preinstall script are in this machine
if [[ -d $packagesDir ]]
then
  #Install downloaded packages as dependecies
  sudo pacman -U $packagesDir/*.tar.zst --asdeps --needed
fi

#Check if device has broadcom wireless network device
if [[ $(lspci -d 14e4:) != '' ]]
then  
  #Remove modules, load wl module and update dependencies
  (lsmod | grep -wq b34) && sudo rmmod b43
  (lsmod | grep -wq ssb) && sudo rmmod ssb
  (lsmod | grep -wq wl)  || sudo modprobe wl
  sudo depmod -a
fi

###########################################################################################
