Set-ExecutionPolocy Bypass -Scope Process -Force
Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y 7zip
choco install -y Sudo
choco install -y adb
choco install -y ag
choco install -y altdrag
choco install -y arduino
choco install -y autohotkey
choco install -y cmder
choco install -y colortool
choco install -y curl
choco install -y dia
choco install -y everything
choco install -y foobar2000
choco install -y fzf
choco install -y gimp
choco install -y git
choco install -y ilspy
choco install -y inkscape
choco install -y linqpad
choco install -y microsoft-teams
choco install -y neovim
choco install -y nextcloud-client
choco install -y nuget.commandline
choco install -y racket
choco install -y sharpkeys
choco install -y sqlite
choco install -y sumatrapdf.install
choco install -y swig
choco install -y sysinternals
choco install -y waterfox
choco install -y wget
choco install -y windirstat

Copy-Item -Path '$PSScriptRoot\Microsoft.PowerShell_profile.ps1' -Destination $PROFILE
Install-Module posh-git -AllowClobber
Install-Module ZLocation -AllowClobber
Install-Module Watch-PerfCounter
Import-Module $PSScriptRoot\Select-ColorScheme.psm1
# 125
# colortool -b '$PSScriptRoot\iTerm2-Color-Schemes\schemes\purplepeter.itermcolors'
# 161
colortool -b '$PSScriptRoot\iTerm2-Color-Schemes\schemes\OneHalfDark.itermcolors'

