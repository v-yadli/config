;Yadli shell -- Customizations of Windows Shell all in one

;The configuration:
;1080p landscape primary screen
;1080p portrait secondary screen

;primary screen used for RDP
;secondary screen split into 3 parts:
;top parts are docked local windows
;middle part host extended remote desktop
;bottom part host local start menu

;;;;;;;;;;;;Initialization;;;;;;;;;;;;;

HSHELL_WINDOWDESTROYED     :=  2
HSHELL_ACTIVATESHELLWINDOW :=  3

HSHELL_WINDOWACTIVATED     :=  4
HSHELL_GETMINRECT          :=  5
HSHELL_REDRAW              :=  6
HSHELL_TASKMAN             :=  7
HSHELL_LANGUAGE            :=  8
HSHELL_SYSMENU             :=  9
HSHELL_ENDTASK             :=  10

HSHELL_ACCESSIBILITYSTATE  :=   11
HSHELL_APPCOMMAND          :=  12

HSHELL_WINDOWREPLACED      :=  13
HSHELL_WINDOWREPLACING     :=  14

HSHELL_MONITORCHANGED      :=  16

Process, Priority,, High
Gui +LastFound  ; Make the GUI window the last found window for use by the line below.
DllCall( "RegisterShellHookWindow", UInt, WinExist() )
MsgHandle := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgHandle, "ShellMessageHandler" )
return

ShellMessageHandler( wParam, lParam )
{
    If (wParam = 1) ;HSHELL_WINDOWCREATED       :=  1
    {
        WinGetTitle, Title, ahk_id %lParam%
        If ( Title = "graph014 - Remote Desktop Connection" )
        {
            ExpandWorkstationRDPSession(lParam)
        }Else
        {
            WinSet, AlwaysOnTop, On, A
            If ( Title = "Virtual Dimension" )
                y_PlaceVDWindow()
        }
    }
    return
}

ExpandWorkstationRDPSession( hwnd )
{
    WinGet Style, Style, ahk_id %hwnd%
    WinSet, Style, -0xC40000, ahk_id %hwnd%
    return
}

IsWorkstationRDPSession()
{
    WinGetTitle, Title, A
    if(Title = "graph014 - Remote Desktop Connection")
        return true
    else
        return false
}

IsVirtualDimension()
{
    WinGetTitle, Title, A
    If(Title = "Virtual Dimension")
        return true
    else
        return false
}

^!q::
if(IsWorkstationRDPSession()){
    Send ^!q
    return
}else if(IsVirtualDimension())
{
    y_DisableWindowBoarder()
}else
    y_ToggleWindowBoarder()
return

^!f::
if(IsWorkstationRDPSession())
    Send ^!f
else if (IsVirtualDimension())
    y_PlaceVDWindow()
else
    y_PlaceWindow()
return

y_PlaceVDWindow()
{
    y_DisableWindowBoarder()
    WinMove, A, , 1921, 1080, 1080, 24
}

y_PlaceWindow()
{
    WinGetPos, Xpos, Ypos, Width, Height, A
        If (Xpos = 1920 AND YPos = -658)
        {
            ;Top dock, moving to pinned middle dock
                WinMove, A, , 1920, 0, 1080,1080
                WinSet, AlwaysOnTop, On, A
        }else if (XPos = 1920 AND YPos = 0)
        {
            ;Middle dock, release it to the center of main screen
                WinMove, A, , 389, 215, 1077, 708
                WinSet, AlwaysOnTop, On, A
        }else{
            ;Central focus or somewhere else, put it back to the dock area
                WinMove, A, , 1920, -658, 1080, 658
                WinSet, AlwaysOnTop, Off, A
        }
    return
}

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

y_DisableWindowBoarder()
{
    SetTitleMatchMode, 2
    WinGet Style, Style, A
    if(Style & 0xC40000) {
        WinSet, Style, -0xC40000, A
    }
    return
}
