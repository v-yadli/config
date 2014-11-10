;BinShell

Process, Priority,, High
^!f::
TilingManager()
return

TilingManager()
{
    WinGetPos, Xpos, Ypos, Width, Height, A
    If(XPos <= 1000) {
        if( YPos < 600)
            WinMove, A, , 0, 0, 1000,600
        else
            WinMove, A, , 0, 600, 1000,600
    }
    else If (Xpos > 1000 AND XPos < 1920) {
        if( YPos < 600)
            WinMove, A, , 1000, 0, 920,600
        else
            WinMove, A, , 1000, 600, 920,600
    }else if (XPos >= 1920 AND XPos <= 2760) {
        if( YPos < 525)
            WinMove, A, , 1920, 0, 840,525
        else
            WinMove, A, , 1920, 525, 840,525
    }else {
        if( YPos < 525)
            WinMove, A, , 2760, 0, 840,525
        else
            WinMove, A, , 2760, 525, 840,525
    }
    return
}


