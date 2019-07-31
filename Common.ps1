<#
This scriptblock runs every time the prompt is returned.
Explicitly use functions from MS namespace to protect from being overridden in the user session.
Custom prompt functions are loaded in as constants to get the same behaviour
#>
[ScriptBlock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE
    $host.UI.RawUI.WindowTitle = Microsoft.PowerShell.Management\Split-Path $pwd.ProviderPath -Leaf
    $Host.UI.RawUI.ForegroundColor = "White"
    Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
    Microsoft.PowerShell.Utility\Write-Host " :: [ $([System.DateTime]::Now) ]" -NoNewLine -ForegroundColor Yellow
    checkGit($pwd.ProviderPath)
    if ($Env:CONDA_PROMPT_MODIFIER) {
        Write-Host -NoNewline -ForegroundColor "DarkGray" " $($Env:CONDA_PROMPT_MODIFIER)"
    }
    Microsoft.PowerShell.Utility\Write-Host "`n>>" -NoNewLine -ForegroundColor "DarkGray"
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

# Functions can be made constant only at creation time
# ReadOnly at least requires `-force` to be overwritten
Set-Item -Path function:\prompt  -Value $Prompt  # -Options ReadOnly

Function Set-NeovimLocation([string]$Path)
{
    if ($Path -eq "") {
        $Path = Get-Location
    }
    & nvr -c "cd $Path"
}

New-Alias -Name vim -Value 'nvr -l'
New-Alias -Name vi -Value 'nvr -l'
New-Alias -Name gvim -Value 'nvr -l'


if (Get-Module PSReadline -ErrorAction "SilentlyContinue") {
    Set-PSReadlineOption -ExtraPromptLineCount 1

    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
    Set-PSReadlineKeyHandler -Key Alt+f -Function NextWord
    Set-PSReadlineKeyHandler -Key Alt+b -Function BackwardWord
    Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
    Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine
    Set-PSReadlineKeyHandler -Key Ctrl+n -Function NextHistory
    Set-PSReadlineKeyHandler -Key Ctrl+p -Function PreviousHistory
}

Function Pull-Profile()
{
    $profileDir = (Get-Item $PROFILE).Directory
    $configDir = "~\config\"
    Push-Location $configDir
    git pull
    $scripts = Get-ChildItem $configDir *.ps1
    foreach($s in $scripts)
    {
        Copy-Item -Path "$s.FullName" -Destination "$profileDir"
    }
    Pop-Location
    . $PROFILE
    Write-Host "New profile loaded."
}

Function Push-Profile()
{
    $profileDir = (Get-Item $PROFILE).Directory
    $configDir = (Get-Item "~\git\config\")
    $scripts = Get-ChildItem $profileDir *.ps1
    foreach($s in $scripts)
    {
        Write-Host "Writing" $s.FullName "to" $configDir
        Copy-Item -Path $s.FullName -Destination $configDir
    }
    Push-Location $configDir
    git add -A
    git commit -m "update ps1 profile"
    git push
    Pop-Location
}
