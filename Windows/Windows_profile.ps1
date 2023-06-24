#Variables
Set-Variable WINGET_LOGS -Value "$Env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir"
Set-Variable WINGET_PACKAGES -Value "$Env:TEMP\Winget"


#winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}


Update-CaskaydiaCoveNF ([switch] $Force)
{
    #Checks if the CaskaydiaCoveNF var exist to reduce number of calls to github api
    if ($Force -or ($null -eq $CaskaydiaCoveNF))
    {
        $CaskaydiaCoveNF = `
        (Invoke-WebRequest https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest).Content -split ',' |
        Select-String "tag_name" |
        ForEach-Object { $_.ToString().Split('"')[3] }
    }

    #Start installation if variable is not equal to env variable
    if ($Force -or ($CaskaydiaCoveNF -ne $Env:CaskaydiaCoveNF))
    {
        #Path to downloaded fonts
        $fontsDir="$Env:USERPROFILE\Downloads\CascadiaCode"

        #Download CaskaydiaCove Nerd Fonts
        Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip" -OutFile "$fontsDir.zip"

        #Remove font folder if exist
        if (Test-Path $fontsDir) { Remove-Item $fontsDir -Recurse }

        #Extract fonts
        Expand-Archive -Path "$fontsDir.zip" -DestinationPath "$fontsDir"

        #Keep only normal fonts
        Remove-Item -Path "$fontsDir\*" -Exclude "CaskaydiaCoveNerdFont-*.ttf"

        #Open fonts directory
        explorer.exe $fontsDir

        #Set CaskaydiaCoveNF env variable for next script calls
        [System.Environment]::SetEnvironmentVariable('CaskaydiaCoveNF',$CaskaydiaCoveNF,'User')
        #Set CaskaydiaCoveNF env variable to current process
        [System.Environment]::SetEnvironmentVariable('CaskaydiaCoveNF',$CaskaydiaCoveNF,'Process')
    }
    else {
        Write-Host "CaskaydiaCove Nerd Fonts are up to date."
    }
}
