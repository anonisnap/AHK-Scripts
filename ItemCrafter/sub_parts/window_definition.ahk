; ========================================================
; Script: Window Definition
; Desc: A script for defining the Window Location and
;       Window Size in a WindowInformation object.
;       Should allow for window title to be specified
; Author: anonisnap | andreasxoungandersen@gmail.com
; Last Updated
;   Date: 11 / 4 - 2021
;   Time: 2:01 am
; ========================================================

#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; WindowDefinition Object, specifying location and size
Class WindowDefinition {
    WindowName {
        get {
            return this.WindowName
        }
    }
    X {
        get {
            return this.X
        }
    }
    Y {
        get {
            return this.Y
        }
    }
    W {
        get {
            return this.W
        }
    }
    H {
        get {
            return this.H
        }
    }
    ; New(int x, int y, int w, int h)
    __New(name, x := 0, y := 0, w := 0, h := 0) {
        this.WindowName := name
        this.X := x
        this.Y := y
        this.W := w
        this.H := h
    }

    ActiveWindow() {
        ; MsgBox, 0, DEBUG, Creating a Window Definition`, looking for %window_identifier%, 10
        WinGetActiveStats, name, w, h, x, y
        ; MsgBox, 0, DEBUG, Found Window at %x%`, %y%, 10
        window := new WindowDefinition(name, x, y, w, h)
        return window
    }

    ToString() {
        msg := "Window: " this.WindowName "`nAt: " this.x ", " this.y "`nSize: " this.w " x " this.h
        return msg
    }
}


startup_message = Get the Name, Location, and Size of the currently active window`nType _w to start
MsgBox, 0, Startup, %startup_message%, 10

:*?0:_w::
    window := WindowDefinition.ActiveWindow()
    string := window.ToString()
    MsgBox, 0, Info, %string%, 10
Return
