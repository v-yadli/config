Copy-Item -Path "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE
Copy-Item -Path "$PSScriptRoot\_vsvimrc" -Destination "$env:USERPROFILE\_vsvimrc"
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module posh-git -AllowClobber -Force
Install-Module ZLocation -AllowClobber -Force
# Install-Module Watch-PerfCounter
# Install-Module Posh-SSH
Install-Module InvokeBuild -Force
Install-Module Pscx -AllowClobber -Force

