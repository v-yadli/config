$env = Get-ItemProperty -Path HKCU:\Environment
$p = $env.Path

$newPaths = (
        "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin",
        "C:\tools\neovim\Neovim\bin",
        "C:\tools\Anaconda3\Scripts",
        "C:\tools\Anaconda3"
        )

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
Set-EnvironmentVariable -key PYTHON_INCLUDE -val "C:\tools\Anaconda3\include"
Set-EnvironmentVariable -key PYTHON_LIB -val "C:\tools\Anaconda3\include"
