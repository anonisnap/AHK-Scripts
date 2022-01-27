#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

class Vector {
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

    AddVector(v) {
        this.X += v.X
        this.Y += v.Y
    }

    Multiply(k) {
        this.X *= k
        this.Y *= k
    }
}

Gui, head:new, , You
Gui, head:-Border
Gui, head:+AlwaysOnTop
Gui, head:Color, 00BBFF

global Size := 9
global JumpDistance := 15
global Direction := new Vector(1, 0)
global GuiPosition := new Vector(20, 20)

GameLoop() {
    While, true 
    {
        Sleep, 250

        Movement := Direction.Clone()
        Movement.Multiply(JumpDistance)
        GuiPosition.AddVector(Movement)
        UpdatePosition()
    }
}

UpdatePosition() {
    x := GuiPosition.X
    y := GuiPosition.Y
    Gui, head:show, x%x% y%y% w%Size% h%Size% NA
}

GameLoop()

w::
    Direction := new Vector(0, -1)
Return

a::
    Direction := new Vector(-1, 0)
Return

s::
    Direction := new Vector(0, 1)
Return

d::
    Direction := new Vector(1, 0)
Return

Esc::
ExitApp
Return