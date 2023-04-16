#Change directory
Set-Location D:\

#Download Ubuntu.appx
Invoke-WebRequest -Uri "https://aka.ms/wslubuntu2204" -OutFile Ubuntu.appx

#Change to zip
Rename-Item .\Ubuntu.appx Ubuntu.zip

#Get zip contents to TMP folder
Expand-Archive .\Ubuntu.zip D:\UbuntuTMP

#Change to zip
Rename-Item (Get-Item .\UbuntuTMP\Ubuntu*x64*.appx).FullName Ubuntu_x64.zip

#Get zip contents to Ubuntu folder
Expand-Archive .\UbuntuTMP\Ubuntu_x64.zip D:\Ubuntu

#Delete zip file
Remove-Item .\Ubuntu.zip

#Delete TMP folder
Remove-Item .\UbuntuTMP -Recurse

#Execute exe file
Start-Process .\Ubuntu\ubuntu.exe
