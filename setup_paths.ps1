$env = Get-ItemProperty -Path HKCU:\Environment
$p = $env.Path

#todo find out where is anaconda

$newPaths = (
        #"C:\tools\Anaconda3\Scripts",
        #"C:\tools\Anaconda3",
        "C:\Program Files\CMake\bin",
        "C:\tools\neovim\Neovim\bin"
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
#Set-EnvironmentVariable -key PYTHON_INCLUDE -val "C:\tools\Anaconda3\include"
#Set-EnvironmentVariable -key PYTHON_LIB -val "C:\tools\Anaconda3\lib"
# Set-EnvironmentVariable -key HTTP_PROXY -val "127.0.0.1:1080"
# Set-EnvironmentVariable -key HTTPS_PROXY -val "127.0.0.1:1080"
