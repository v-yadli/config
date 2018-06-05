$env = Get-ItemProperty -Path HKCU:\Environment
$p = $env.Path
$newPaths = ("C:\Program Files\CMake\bin",
             "C:\tools\neovim\Neovim\bin")

$conda_candidate_paths = ('C:\tools\Anaconda3', 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\Anaconda3_64')

$conda_path = $null
foreach($cp in $conda_candidate_paths) {
    if ([System.IO.Directory]::Exists($cp)) {
        $conda_path = $cp
        $newPaths += $conda_path
        $newPaths += "$conda_path\Scripts"
        Write-Host "Found anaconda at $conda_path"
        break
    }
}

if(!$p.EndsWith(";")) { $p = "$p;" }

foreach($np in $newPaths)
{
    if(!$p.Contains($np))
    {
        Write-Host "Adding $np to Path"
        $p = $p + "$np;"
    }
}

Function Set-EnvironmentVariable([string] $key, [string] $val)
{
    Write-Host "Updating HKCU:\Environment: $key = $val"
    Set-ItemProperty -Path HKCU:\Environment -Name $key -Value $val
}

Set-EnvironmentVariable -key Path -val $p
if ($conda_path -ne $null) {
    Set-EnvironmentVariable -key PYTHON_INCLUDE -val "$conda_path\include"
    Set-EnvironmentVariable -key PYTHON_LIB -val "$conda_path\lib"
}
# Set-EnvironmentVariable -key HTTP_PROXY -val "127.0.0.1:1080"
# Set-EnvironmentVariable -key HTTPS_PROXY -val "127.0.0.1:1080"
