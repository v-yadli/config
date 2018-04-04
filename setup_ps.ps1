Copy-Item -Path '$PSScriptRoot\Microsoft.PowerShell_profile.ps1' -Destination $PROFILE
Copy-Item -Path '$PSScriptRoot\_vsvimrc' -Destination '$env:USERPROFILE\_vsvimrc'
Install-Module posh-git -AllowClobber
Install-Module ZLocation -AllowClobber
# Install-Module Watch-PerfCounter
# Install-Module Posh-SSH
Install-Module InvokeBuild
