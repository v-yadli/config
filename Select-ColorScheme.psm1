Function Select-ColorScheme($idx = 0)
{
    $schemes = Get-ChildItem -Path 'iTerm2-Color-Schemes\schemes\'
    Clear-Host
    Write-Output "====== Code display:"
    pygmentize.exe 'Select-ColorScheme.psm1'
    Write-Output "====== Error display:"
    Invoke-Command -ScriptBlock { Undefined-Command }
    $code = Get-ConsoleBuffer
    For (; ;) {
        $cscheme = $schemes[$idx]
        colortool -q -b $schemes[$idx].FullName
        Clear-Host
        Set-ConsoleBuffer $code
        Write-Output "====== Current scheme: $cscheme[$idx]"
        $key = [System.Console]::ReadKey().Key
        if ($key -eq [System.ConsoleKey]::LeftArrow) { $idx = $idx - 1}
        if ($key -eq [System.ConsoleKey]::RightArrow) { $idx = $idx + 1}
        if ($key -eq [System.ConsoleKey]::Enter) { break }
    }
}

Function Get-ConsoleBuffer()
{
# Grab the console screen buffer contents using the Host console API.
    $bufferWidth = $host.ui.rawui.BufferSize.Width
    $bufferHeight = $host.ui.rawui.CursorPosition.Y
    $rec = new-object System.Management.Automation.Host.Rectangle 0, 0, ($bufferWidth - 1), $bufferHeight
    [System.Management.Automation.Host.BufferCell[,]] $buffer = $host.ui.rawui.GetBufferContents($rec)
    return $buffer
}

Function Set-ConsoleBuffer($buf)
{
    $bufferWidth = $host.ui.rawui.BufferSize.Width
    $bufferHeight = ($buf.Count / $bufferWidth)
    $buffer = [System.Management.Automation.Host.BufferCell[,]]::New($bufferHeight, $bufferWidth)
    [int] $idx = 0;
    for($i = 0; $i -lt $bufferHeight; ++$i) {
        for($j = 0; $j -lt $bufferWidth; ++$j) {
            $buffer[$i, $j] = $buf[$idx]
            $idx++
        }
    }
    $point = new-object System.Management.Automation.Host.Coordinates 0, 0
    $host.ui.rawui.SetBufferContents($point, $buffer)
}
