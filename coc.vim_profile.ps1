if (Get-Module PSReadline -ErrorAction "SilentlyContinue") {
    Set-PSReadlineOption -ExtraPromptLineCount 1
}

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
    if ($Env:CONDA_PROMPT_MODIFIER) {
        Write-Host -NoNewline -ForegroundColor "DarkGray" " $($Env:CONDA_PROMPT_MODIFIER)"
    }
    Microsoft.PowerShell.Utility\Write-Host "`nλ " -NoNewLine -ForegroundColor "DarkGray"
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

# Functions can be made constant only at creation time
# ReadOnly at least requires `-force` to be overwritten
Set-Item -Path function:\prompt  -Value $Prompt  # -Options ReadOnly

Import-Module ZLocation
Import-Module Pscx
Import-Module MonitorFactory
Import-Module Get-ChildItemColor
# Import-Module 'C:\ProgramData\chocolatey\lib\git-status-cache-posh-client\tools\git-status-cache-posh-client-1.0.0\GitStatusCachePoshClient.psm1'

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadlineKeyHandler -Key Alt+f -Function NextWord
Set-PSReadlineKeyHandler -Key Alt+b -Function BackwardWord
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadlineKeyHandler -Key Ctrl+n -Function NextHistory
Set-PSReadlineKeyHandler -Key Ctrl+p -Function PreviousHistory

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$VcpkgModpath = '~\git\vcpkg\scripts\posh-vcpkg'
if (Get-Item $VcpkgModpath -ErrorAction SilentlyContinue) {
    Import-Module $VcpkgModpath
}else{
    Write-Host -ForegroundColor Yellow "vcpkg integration module not found at $VcpkgModpath"
}

New-Alias -Name vim -Value 'nvr -l'
New-Alias -Name vi -Value 'nvr -l'
New-Alias -Name gvim -Value 'nvr -l'
Set-Alias -Name Expand-Archive -Value Microsoft.PowerShell.Archive\Expand-Archive
Set-Alias -Name ls -Value Get-ChildItemColor -Option AllScope

