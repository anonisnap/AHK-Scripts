#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

CoordMode, Mouse, Screen

MsgBox % "Window Size Finder Loaded"
^i:: ; Ctrl + I
KeyWait, Control
KeyWait, I

WinGetPos, X, Y, Width, Height, A
MsgBox, 4, Mouse, Move Mouse to %X%`, %Y%?
IfMsgBox, Yes
    MouseMove, X, Y
X2 := X + Width
Y2 := Y + Height
MsgBox, 4, Mouse, Move Mouse to %X2%, %Y2%?
IfMsgBox, Yes
    MouseMove, X+Width, Y+Height