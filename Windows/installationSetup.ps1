#ExecutionPolicy
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser


#Terminal Icons
Install-Module -Name Terminal-Icons

#PSReadLine
Install-Module -Name PSReadLine -Force

#OH-MY-POSH
winget install oh-my-posh -s winget


#NerdFonts
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip" -OutFile "$Env:USERPROFILE\Downloads\CascadiaCode.zip"
Expand-Archive -Path "$Env:USERPROFILE\Downloads\CascadiaCode.zip" -DestinationPath "$Env:USERPROFILE\Downloads\CascadiaCode"
Invoke-Item -Path "$Env:USERPROFILE\Downloads\CascadiaCode\Caskaydia Cove Nerd Font Complete Windows Compatible *.otf"
