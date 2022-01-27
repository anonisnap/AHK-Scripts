#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

Gui, insertWindow:new, -Resize +AlwaysOnTop, Insert

InitiateInsertWindow() {

}

OpenInsertWindow() {
	Gui, insertWindow:show, ,
}

InitiateInsertWindow()

; == Activation ==
:*?0:_insert::
    OpenInsertWindow()