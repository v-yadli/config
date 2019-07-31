$gitLoaded = $false
function Import-Git($Loaded){
    if($Loaded) { return }
    $GitModule = Get-Module -Name Posh-Git -ListAvailable
    if($GitModule){
        Import-Module Posh-Git > $null
    } else {
        Write-Warning "Missing git support, install posh-git with 'Install-Module posh-git'."
    }
    # Make sure we only run once by alawys returning true
    return $true
}

function checkGit($Path) {
    if (Test-Path -Path (Join-Path $Path '.git') ) {
        $gitLoaded = Import-Git $gitLoaded
        Write-VcsStatus
        return
    }
    $SplitPath = split-path $path
    if ($SplitPath) {
        checkGit($SplitPath)
    }
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
    Write-Host "Cleanup..."
    Remove-Item $tmpfile
    Write-Host "Done!"
}

Import-Module ZLocation
Import-Module Pscx
Import-Module MonitorFactory
Import-Module Get-ChildItemColor
# Import-Module 'C:\ProgramData\chocolatey\lib\git-status-cache-posh-client\tools\git-status-cache-posh-client-1.0.0\GitStatusCachePoshClient.psm1'

$timestamp_file = "$PSScriptRoot\repo_update.txt" 
$update_timestamp = Get-Item $timestamp_file -ErrorAction SilentlyContinue
if ($update_timestamp) { $update_timestamp = [System.DateTime]::Parse((Get-Content $update_timestamp)) }
else                   { $update_timestamp = [System.DateTime]::MinValue }

$now = [System.DateTime]::Now
if ($now - $update_timestamp -gt [System.TimeSpan]::FromDays(1)) {
    Set-Content $timestamp_file -Value $now
    $myrepos = "GraphMachine","fvim","coc-fsharp","config","nvim","coc-powershell"
    $myrepos | ForEach-Object {
        Write-Host -ForegroundColor Green "Updating repository $_"
        $job = Start-Job {
            Push-Location
            z $args[0] -WarningAction Stop
            git pull
            Pop-Location
        } -ArgumentList $_
        return $job
    } | Wait-Job | Receive-Job
    Get-Job | Stop-Job
}


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

Set-Alias -Name Expand-Archive -Value Microsoft.PowerShell.Archive\Expand-Archive
Set-Alias -Name ls -Value Get-ChildItemColor -Option AllScope

. $PSScriptRoot\Common.ps1
