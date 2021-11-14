#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Image Files
global cooked_chicken   := "images\cooked_chicken.png"
global raw_chicken      := "images\raw_chicken.png"
global feather          := "images\feather.png"
global egg              := "images\egg.png"
global chestplate       := "images\chestplate.png"

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

FindImage(ByRef image_file, x1:=0, y1:=0, x2:=-1, y2:=-1) {
    found := false
    if (x2 = -1 || y2 = -1){
        x2 := A_ScreenWidth
        y2 := A_ScreenHeight
    }
    ImageSearch, loc_x, loc_y, %x1%, %y1%, %x2%, %y2%, %image_file%
    if (ErrorLevel = 0) {
        found := true
    }
    result := {WasFound: found, X: loc_x, Y: loc_y}
    return result
}

; --------------------------------------
; Hotkey
; --------------------------------------
^i:: ; Ctrl + I
KeyWait Control
KeyWait i

location := FindImage(egg)
MsgBox % "Found: " location.WasFound
MouseMove, location.X + 16, location.Y + 16