Import-Module posh-git
Import-Module ZLocation
Import-Module PSColor
Import-Module Watch-PerfCounter
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler Ctrl+Backspace -Function BackwardKillWord
Set-PSReadlineKeyHandler Ctrl+LeftArrow -Function BackwardWord
Set-PSReadlineKeyHandler Ctrl+RightArrow -Function NextWord
