#Download latest zoom version and pass to specific file for cases when file already exist
wget https://zoom.us/client/latest/zoom_x86_64.pkg.tar.xz -O $HOME/Downloads/zoom_x86_64.pkg.tar.xz

#Install zoom
sudo pacman -U $HOME/Downloads/zoom_x86_64.pkg.tar.xz
