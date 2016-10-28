REM run with elevated cmd
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco install -y Sudo
choco install -y vim
choco install -y owncloud-client
choco install -y mattermost-desktop
choco install -y git
choco install -y ag
choco install -y 7zip
choco install -y autohotkey
choco install -y autoit
choco install -y sumatrapdf.install
choco install -y tortoisehg
choco install -y everything
choco install -y firefox
choco install -y adblockplusie
choco install -y flashplayerplugin
choco install -y altdrag
choco install -y dia
choco install -y emacs
choco install -y k-litecodecpackmega
choco install -y gimp
choco install -y inkscape
choco install -y visualstudio2013ultimate --execution-timeout 300000
choco install -y visualstudio2015enterprise --execution-timeout 300000
choco install -y visualstudio2013-sdk
choco install -y nuget.commandline
choco install -y notepadplusplus
choco install -y sysinternals
choco install -y cmder
choco install -y hdtune
choco install -y adb
choco install -y nodejs
choco install -y python2
choco install -y curl
choco install -y wget
choco install -y windbg
choco install -y ilspy
choco install -y f.lux
choco install -y jdk8
choco install -y linqpad
choco install -y racket
choco install -y sbcl
choco install -y androidstudio
REM choco install -y startkiller
choco install -y windirstat
choco install -y sqlite
REM choco install -y wilma
REM choco install -y slack
choco install -y reshack
choco install -y VisualStudioCode
REM TODO packages maintained by v-yadli
choco install -y cytoscape
choco install -y wechat
choco install -y netease-cloudmusic

refreshenv
npm install -g json
