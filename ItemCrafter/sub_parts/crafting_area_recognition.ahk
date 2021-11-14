; ========================================================
; Script: Crafting Area Recognition
; Desc: A script for recognising the crafting area
; Author: anonisnap | andreasyoungandersen@gmail.com
; Last Updated
;   Date: 6 November 2021
;   Time: 3:40am
; ========================================================

#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; WindowDefinition Object, specifying location and size
Class WindowClass {
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
        window := new WindowClass(name, x, y, w, h)
        return window
    }

    ToString() {
        msg := "Window: " this.WindowName "`nAt: " this.x ", " this.y "`nSize: " this.w " x " this.h
        return msg
    }
}

Class SimpleVector2Class {
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

    __New(x, y) {
        this.X := x
        this.Y := y
    }

    Multiply(k) {
        if (k is Number) {
            MsgBox % "k was a number, " k
            this.X *= k
            this.Y *= k
        } else {
            MsgBox, 0, Error, Value of k was not a Number, 5 
        }
    }

    AddVector2(ByRef v) {
        if (SimpleVector2Class.IsVector(v)) {
            this.X += v.X
            this.Y += v.Y
        } else {
            MsgBox, 0, Error, Value`, v`, was not recognized as a Vector2, 5
        }
    }

    IsVector(v) {
        x := v.X
        y := v.Y
        if (x is not number) {
            MsgBox % "Vector x is not a number (" x ")" 
            return false 
        }

        if (y is not number) {
            MsgBox % "Vector y is not a number (" y ")" 
            return false
        }
        return true
    }

    ToString() {
        string := "V2(" this.X ", " this.Y ")"
        return string
    }
}



VectorTest() {
    v1 := new SimpleVector2Class(4, 7)
    v2 := new SimpleVector2Class(2, 9)
    multiplier := 8

    v1_string := v1.ToString()
    v2_string := v2.ToString()
    MsgBox, 0, DEBUG, %v1_string%, 2
    MsgBox, 0, DEBUG, %v2_string%, 2

    v1.AddVector2(v2)
    v1_string := v1.ToString()
    MsgBox, 0, DEBUG, %v1_string%, 2

    v2.Multiply(multiplier)
    v2_string := v2.ToString()
    MsgBox, 0, DEBUG, %v2_string%, 2

    v2.Multiply("g")
    v2_string := v2.ToString()
    MsgBox, 0, DEBUG, %v2_string%, 2
}

; TESTING AREA

VectorTest()

MoveMouseTo(ByRef vector) {
    if (SimpleVector2Class.IsVector(vector)) {
        x := vector.X
        y := vector.Y
        ; MsgBox, 0, DEBUG, Moving mouse to %x%`, %y%, 5
        MouseMove, x, y, , 
    } else {
        MsgBox, 0, Error, value was not recognized as a valid Vector
    }
}

MoveMouse(ByRef vector) {
    if (SimpleVector2Class.IsVector(vector)) {
        x := vector.X
        y := vector.Y
        MouseMove, x, y, , R
    } else {
        MsgBox, 0, Error, value was not recognized as a valid Vector
    }
}

GUI_SCALE := 2
offset := GUI_SCALE * (16 + 2)

:*?0:_gui::
    window := WindowClass.ActiveWindow()
    location := new SimpleVector2Class(window.X, window.Y)
    center_of_window := new SimpleVector2Class(window.W, window.H)
    center_of_window.Multiply(0.5)

    ; center_of_window_string := center_of_window.ToString()
    ; MsgBox, 0, Info, %center_of_window_string%, 5

    location.AddVector2(center_of_window)
    MoveMouseTo(location)

    ; string := window.ToString()
    ; MsgBox, 0, Info, %string%, 10
Return

:*?:_u::
    offset_vector := new SimpleVector2Class(0, -offset)
    offset_vector_string := "Offset Vector: " offset_vector.ToString()
    ; MsgBox, 0, Info, %offset_vector_string%, 5
    MoveMouse(offset_vector)
Return

:*?:_d::
    offset_vector := new SimpleVector2Class(0, offset)
    offset_vector_string := "Offset Vector: " offset_vector.ToString()
    ; MsgBox, 0, Info, %offset_vector_string%, 5
    MoveMouse(offset_vector)
Return

:*?:_l::
    offset_vector := new SimpleVector2Class(-offset, 0)
    offset_vector_string := "Offset Vector: " offset_vector.ToString()
    ; MsgBox, 0, Info, %offset_vector_string%, 5
    MoveMouse(offset_vector)
Return

:*?:_r::
    offset_vector := new SimpleVector2Class(offset, 0)
    offset_vector_string := "Offset Vector: " offset_vector.ToString()
    ; MsgBox, 0, Info, %offset_vector_string%, 5
    MoveMouse(offset_vector)
Return