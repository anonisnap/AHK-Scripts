#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global todos := []
global TodoText := "Empty"

NewTodo() {
	Gui, NewTodo:new, +AlwaysOnTop, New Todo
	Gui, NewTodo:add, Edit, vTodoText, 
	Gui, NewTodo:add, Button, gAddTodo, Add
	Gui, NewTodo:show
	Return
}

AddTodo() {
	Gui, Submit
	; MsgBox % "Adding: " TodoText
	todos.Push( { text: TodoText, checked: 0 } )

	Gui, NewTodo:Destroy
	Gosub, Refresh
	Return
}

UpdateCheckboxes(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
	GuiControlGet, num, Name, %CtrlHwnd%
	cbox := todos[SubStr(num, 8)] ; Correctly gets a Checkbox Object
	cbox.checked := cbox.checked == 1 ? 0 : 1
}

RemoveCompleted() {
	tmp := []
	For i, val in todos
	{
		if (val.checked == 0) {
			tmp.Push(val)
		}
	}
	todos := tmp
	tmp =
	Gosub, Refresh
}

Refresh: 
	; Restart the Window
	Gui, TodoWindow:Destroy
	Gui, TodoWindow:new, -Resize +AlwaysOnTop -Border, Todo List

	; Buttons
	Gui, TodoWindow:add, Button, gNewTodo, Add New Todo
	Gui, TodoWindow:add, Button, gGuiClose x+10, Exit
	Gui, TodoWindow:add, Button, gRemoveCompleted x+10, Clean Todos

	; Statusbar
	amount := todos.Length()
	Gui, TodoWindow:add, StatusBar, , There are %amount% total todos.
	amount =
		 
	; Checklist
	For i, todo in todos
	{
		isChecked := todo.checked
		todoText := todo.text
		Gui, TodoWindow:add, Checkbox, Checked%isChecked% vChecked%i% gUpdateCheckboxes x20 +Wrap, %todoText%
	}

	; MsgBox % "Amount of Todos: " amount "`nMost recent todo: " todos[amount]

	Gui, TodoWindow:show, x10 y10 w240
Return

GuiClose:
ExitApp, 1