if (Get-Module PSReadline -ErrorAction "SilentlyContinue") {
    Set-PSReadlineOption -ExtraPromptLineCount 1
}

function clone([string] $repo)
{
# a short repo notation
    if(-not $repo.Contains("git@") -and -not $repo.Contains("https"))
    {
        $user,$repo = $repo.Split('/')
        switch($user)
        {
            "yatli" {
                $repo = "git@github.com:$user/$repo"
            }
            "v-yadli" {
                $repo = "git@github.com:$user/$repo"
            }
            "researchpaper" {
                $repo = "git@gitlab.com:$user/$repo"
            }
            default {
                $repo = "https://github.com/$user/$repo"
            }
        }
    }
    git clone --recursive $repo
}

function Update-Neovim()
{
    $tmpfile = "$(New-TemporaryFile).zip"
    Write-Host "Downloading latest neovim..."
    Invoke-WebRequest -Uri https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip -OutFile $tmpfile
    Write-Host "Removing old installation..."
    Stop-Process -Name FVim -ErrorAction SilentlyContinue
    Stop-Process -Name nvim -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force -Path C:\tools\neovim\Neovim
    Write-Host "Installing..."
    Microsoft.PowerShell.Archive\Expand-Archive -Path $tmpfile -DestinationPath C:\tools\neovim
    Move-Item -Force C:\tools\neovim\Neovim\* C:\tools\neovim\
    Remove-Item -Path C:\tools\neovim\Neovim
    Write-Host "Cleanup..."
    Remove-Item $tmpfile
    Write-Host "Done!"
}

function Enter-VisualStudio2019()
{
  $vsPath = &(Join-Path ${env:ProgramFiles(x86)} '\\Microsoft Visual Studio\\Installer\\vswhere.exe') -property installationPath | Where-Object { $_ -like '*2019*' }
  Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
  Enter-VsDevShell -VsInstallPath $vsPath -DevCmdArguments "-arch=x64 -host_arch=x64"
}

function Enter-VisualStudio2019_x86()
{
  $vsPath = &(Join-Path ${env:ProgramFiles(x86)} '\\Microsoft Visual Studio\\Installer\\vswhere.exe') -property installationPath | Where-Object { $_ -like '*2019*' }
  Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
  Enter-VsDevShell -VsInstallPath $vsPath -DevCmdArguments "-arch=x86 -host_arch=x64"
}

<#
This scriptblock runs every time the prompt is returned.
Explicitly use functions from MS namespace to protect from being overridden in the user session.
Custom prompt functions are loaded in as constants to get the same behaviour
#>
[ScriptBlock]$Prompt = {
    gitFancyPrompt
}

# Functions can be made constant only at creation time
# ReadOnly at least requires `-force` to be overwritten
Import-Module $PSScriptRoot\be5prompt.psm1
Set-Item -Path function:\prompt  -Value $Prompt  # -Options ReadOnly

Import-Module ZLocation
Import-Module Pscx
Import-Module MonitorFactory
Import-Module Get-ChildItemColor
Import-Module Posh-Git
# Import-Module 'C:\ProgramData\chocolatey\lib\git-status-cache-posh-client\tools\git-status-cache-posh-client-1.0.0\GitStatusCachePoshClient.psm1'

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadlineKeyHandler -Key Alt+f -Function NextWord
Set-PSReadlineKeyHandler -Key Alt+b -Function BackwardWord
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadlineKeyHandler -Key Ctrl+n -Function NextHistory
Set-PSReadlineKeyHandler -Key Ctrl+p -Function PreviousHistory

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
     param($commandName, $wordToComplete, $cursorPosition)
         dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
         }
 }

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$VcpkgModpath = '~\git\vcpkg\scripts\posh-vcpkg'
if (Test-Path $VcpkgModpath) {
    Import-Module $VcpkgModpath
    New-Alias -Name vcpkg -Value '~\git\vcpkg\vcpkg.exe'
}

New-Alias -Name vim -Value nvim
New-Alias -Name vi -Value nvim
New-Alias -Name gvim -Value "C:\Tools\fvim\fvim.exe"
Set-Alias -Name Expand-Archive -Value Microsoft.PowerShell.Archive\Expand-Archive
Set-Alias -Name ls -Value Get-ChildItemColor -Option AllScope

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
