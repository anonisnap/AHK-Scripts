#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileRead, Instructions, instructions.txt
instructionList := StrSplit(Instructions, "`n")
iteration := 0

MsgBox % "Instruction Reader Started"

^i:: ; Ctrl + I
KeyWait Control ; Wait for Ctrl to be not-clicked
KeyWait i ; Wait for X to be not-clicked

idx := Mod(iteration++, instructionList.MaxIndex()) + 1

MsgBox % instructionList[idx]