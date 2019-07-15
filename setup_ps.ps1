Copy-Item -Path "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE
Copy-Item -Path "$PSScriptRoot\_vsvimrc" -Destination "$env:USERPROFILE\_vsvimrc"
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Update-Module PowerShellGet -Scope CurrentUser -Force
Remove-Module PowerShellGet
Import-Module PowerShellGet
Install-Module posh-git -AllowClobber -Scope CurrentUser -Force
Install-Module ZLocation -AllowClobber -Scope CurrentUser -Force
Install-Module MonitorFactory -Scope CurrentUser -Force
# Install-Module Watch-PerfCounte -Scope CurrentUser
# Install-Module Posh-SS -Scope CurrentUser
Install-Module InvokeBuild -Scope CurrentUser -Force
Install-Module Pscx -AllowClobber -Scope CurrentUser -Force
Install-Module PSReadLine -AllowClobber -Scope CurrentUser -Force -AllowPrerelease
Install-Module Get-ChildItemColor -Scope CurrentUser 
