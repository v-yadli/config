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
        If (0 < RegExMatch( Title , "graph014.*Remote Desktop Connection") )
        {
            ExpandWorkstationRDPSession(lParam)
        }Else If ( 0 < RegExMatch( Title , "v-yadli.*Remote Desktop Connection") )
        {
            ExpandWorkstationRDPSession(lParam)
            ;WinMove, ahk_id %lParam%, , 1920, -706, 1080, 706
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
    if(0 < RegExMatch( Title , "graph014.*Remote Desktop Connection"))
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
else
    y_PlaceWindow()
return

^!d::
y_ToggleAlwaysOnTop()
return

y_ToggleAlwaysOnTop()
{
    WinExist("A")
    WinSet, AlwaysOnTop, Toggle, A
    WinGet, always_on_top_val, ExStyle, A
    WinGetTitle, Title, A
    if (always_on_top_val & 0x8) { ; 0x8 is WS_EX_TOPMOST. 
        TrayTip, YadliShell, %Title% always on top ON, 1
    }else {
        TrayTip, YadliShell, %Title% always on top OFF, 1
    }
    ;WinHide, A
    ;WinShow, A
}

y_PlaceWindow()
{
    WinGetPos, Xpos, Ypos, Width, Height, A
    If (Xpos = 1913 AND YPos = -732 )
    {
        ;Top dock, moving to pinned middle dock
        ;Preset for Win8: 
        ;WinMove, A, , 1920, 0, 1080, 1030
        ;Preset for Win10:
        WinMove, A, , 1913, 0, 1093, 1102
    }else if (XPos = 1913 AND YPos = 0)
    {
        ;Middle dock, release it to the center of main screen
        WinMove, A, , 389, 215, 1077, 708
        ;WinSet, AlwaysOnTop, On, A
    }else{
        ;Central focus or somewhere else, put it back to the dock area
        ;Preset for Win8: 
        ;WinMove, A, , 1920, -706, 1080, 706
        ;Preset for Win10:
        WinMove, A, , 1913, -732, 1093, 740
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
