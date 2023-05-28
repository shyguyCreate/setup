#Check if script is run as admin
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Start-Process powershell.exe "-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command { Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/shyguyCreate/install-Scripts/main/Windows/installSetup.ps1).Content }" -Verb RunAs
    return
}

#ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force


#Script variables
$fontsDir="$Env:USERPROFILE\Downloads\CascadiaCode"
$githubDir="$Env:USERPROFILE\Github"
$repoDir="$githubDir\install-Scripts"
$powershellDir="$Env:USERPROFILE\Documents\WindowsPowerShell"
$pwshDir="$Env:USERPROFILE\Documents\PowerShell"


#Install Powershell modules
powershell.exe -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"
pwsh.exe -NoProfile -c "& { Install-Module -Name posh-git,PSReadLine,Terminal-Icons -Scope CurrentUser -Force }"


#Download CascadiaCode Nerd Fonts
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip" -OutFile "$fontsDir.zip"
#Remove font folder if exist
if (Test-Path $fontsDir) { Remove-Item $fontsDir -Recurse }
#Extract fonts
Expand-Archive -Path "$fontsDir.zip" -DestinationPath "$fontsDir"
#Keep only normal fonts
Remove-Item -Path "$fontsDir\*" -Exclude "CaskaydiaCoveNerdFont-*.ttf"
#Open fonts directory
explorer.exe $fontsDir


#Make directory for Github and gists
New-Item -Path "$githubDir\gist" -ItemType Directory -Force > $null
#Clone git repository
git clone https://github.com/shyguyCreate/install-Scripts.git $repoDir


#Make folders for profiles
New-Item -Path $powershellDir,$pwshDir -ItemType Directory -Force > $null

#Create symbolic link of profile script to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$repoDir\Windows\profile.ps1" -Path $powershellDir,$pwshDir -Name "profile.ps1" -Force > $null
#Create symbolic link of ohmyposh config file to powershell profile folder
New-Item -ItemType SymbolicLink -Value "$repoDir\share\ohmyposh.omp.json" -Path $powershellDir,$pwshDir -Name "ohmyposh.omp.json" -Force > $null
