Import-Module ZLocation
Import-Module Pscx
Import-Module Get-ChildItemColor

Set-Alias -Name Expand-Archive -Value Microsoft.PowerShell.Archive\Expand-Archive
Set-Alias -Name ls -Value Get-ChildItemColor -Option AllScope

. .\Common.ps1
