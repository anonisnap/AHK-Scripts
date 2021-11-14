#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

class Point {
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

    __New(x_value, y_value) {
        this.X := x_value
        this.Y := y_value
    }
}

a := new Point(1, 2)
b := new Point(3, 4)
MsgBox % "Values for Point a`na.X: " a.X ", a.Y: " a.Y
MsgBox % "Values for Point a`na.X: " b.X ", a.Y: " b.Y
