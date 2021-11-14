#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

Method() {

    image := "..\tmp\arrow.png"

    ImageSearch, x, y, 0, 0, 1920, 1080, *16 *TransBlack %image% ;0x8B8B8B
    if (ErrorLevel = 0) {
        MsgBox, 0, info, Arrow was found at %x%`, %y%, 10
    } else {
        MsgBox, 0, error, Error Level: %ErrorLevel%, 10
    }
    return
}
^i:: ; Ctrl + I
    KeyWait, Control
    KeyWait, I
    Method()
Return