;Yadli shell -- Server Edition

^!q::
y_ToggleWindowBoarder()
return

^!f::
WinGetPos, Xpos, Ypos, Width, Height, A
If (Xpos < 1830)
{
    ; Left part
    WinMove, A, , 88, 0, 1830, 1080
}else {
    ; Right part
    WinMove, A, , 1920, 0, 1080, 1080
}

return

y_ToggleWindowBoarder()
{
    SetTitleMatchMode, 2
    WinGet Style, Style, A
    if(Style & 0xC40000) {
        WinSet, Style, -0xC40000, A
    } else {
        WinSet, Style, +0xC40000, A
    }
    return
}

