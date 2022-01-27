#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global itemList := []
global file := A_WorkingDir "\items.txt"

ListSetup() {
	; Set FileEncoding
	FileEncoding, UTF-8
	; Read File into Memory (String)
	FileRead, file_string, %file%

	Loop, Parse, file_string, "`r", "`n"
	{
		if (StrLen(A_LoopField) != 0) {	
			itemList.Push(A_LoopField)
		} 
	}
}

; Open the Window with the items to Insert
OpenInsertWindow() { 
	Gui, show, ,
}

Insert(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
	GuiControlGet, num, Name, %CtrlHwnd%
	output := itemList[SubStr(num, 4)]

	; Get relevant Information
	Gui, Destroy

	; Insert relevant Information
	Send, %output%
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

WindowSetup: ; This is stupid and I can't get it work from within a Method... But a Label, doing what seems to be THE EXACT SAME THING as a method works fine...
	Gui, new, -Resize +AlwaysOnTop, Insert

	For i, item in itemList ; Change 3 to length of a loaded list
	{
		Gui, add, Button, x10 gInsert vBtn%A_Index%, Insert #&%A_Index%
		Gui, add, Text, x+5 yp+5, %item% ; Change text to item from the list
	}
	Gui, add, Button, x180 y+25 +Default gCancel, &Cancel
Return