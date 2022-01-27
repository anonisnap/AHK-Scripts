#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global itemList := []
global file := A_WorkingDir "\items.txt"

ListSetup() {

}

; Open the Window with the items to Insert
OpenInsertWindow() { 
	Gui, show, ,
}

Insert(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
	GuiControlGet, num, Name, %CtrlHwnd%

	; Get relevant Information
	Gui, Destroy

	; Insert relevant Information
	MsgBox % "You clicked Insert #" SubStr(num, 4)
}

Cancel() {
	Gui, Destroy
}

ListSetup()

; == Activation ==
:*?0:_insert::
	Gosub, WindowSetup ; "Method call"
	OpenInsertWindow()
Return

:*?0:+insert::
    TrayTip, Reload, Reloading insert script,
	Reload
return

WindowSetup: ; This is stupid and I can't get it set up form within a Method... But a Label, doing what seems to be THE EXACT SAME THING as a method works fine...
	Gui, new, -Resize +AlwaysOnTop, Insert

	Loop, 3 ; Change 3 to length of a loaded list
	{
		Gui, add, Button, x10 gInsert vBtn%A_Index%, Insert
		Gui, add, Text, x+5 yp+5, Text #%A_Index% ; Change text to item from the list
	}
	Gui, add, Button, x180 y250 +Default gCancel, &Cancel
Return