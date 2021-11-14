; ========================================================
; Script: Instruction Parsing
; Desc: A script for parsing an instruction file, and
;       the relavant informaiton to the user
; Author: anonisnap | andreasyoungandersen@gmail.com
; Last Updated
;   Date: 1 November 2021
;   Time: 3:45am
; ========================================================

#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

instruction_file := "instructions.txt"

; Loads instructions from the given file into an array and returns the array
LoadInstructionsFromFile(ByRef file) {
    FileRead, full_instruction_string, %file% ; Reads entire file into a long string
    full_instruction_string := StrReplace(full_instruction_string, " ", "") ; Removes all Spaces
    full_instruction_string := StrReplace(full_instruction_string, "`t", "") ; Removes all Tabs
    full_instruction_string := StrReplace(full_instruction_string, "`r", "") ; Removes all Return
    full_instruction_array := StrSplit(full_instruction_string, "`n") ; Splits on each NewLine char and creates a new entry in array
    return full_instruction_array
}

; Strips the array from all comments and removes empty entries
StripCommentsFromArray(ByRef array) {
    clean_array := [] ; New array to return to user
    for i, entry in array { ; Loop through entire array with 
        entry := StrSplit(entry, "#")[1]
        if (entry != "") {
            clean_array.Push(entry)
        }
    }
    return clean_array
}

; Splits the Command and the Arguments into a 2 index array
SplitCommandAndArgs(ByRef entry) {
    entry_array := StrSplit(entry, ",", , 2)
    cmd := entry_array[1]
    StringLower, cmd, cmd
    entry_array[1] := cmd
    return entry_array
}

; == COMMANDS ==
; Inventory Command
InvCommand(ByRef item_or_xy_index_as_string) {
    args := StrSplit(item_or_xy_index_as_string, ",")
    len := args.MaxIndex()
    if (len = 1) {
        item := args[1]
        MsgBox, 0, InvCommand, Attempting to find %item% in your Inventory, 5
    } else if (len = 2) {
        x := args[1]
        y := args[2]
        MsgBox, 0, InvCommand, Clicking in Inventory at slot %x%`, %y%, 5
    } else {
        error_message := "Could not match argument count (" len ") with any sub commands`nDEBUG: args = " args
        MsgBox 0, Invalid Arg Count, %error_message%, 5
    }
}

; Craft Command
CraftCommand(ByRef item_or_xy_index_as_string) {
    args := StrSplit(item_or_xy_index_as_string, ",")
    len := args.MaxIndex()
    if (len = 1) {

        ; STUFF FOR FINDING AN ITEM IN INVENTORY START
        item := args[1]
        MsgBox, 0, CraftCommand, Attempting to find %item% in the Crafting area, 5
        ; STUFF FOR FINDING AN ITEM IN INVENTORY STOP

    } else if (len = 2) {

        ; STUFF FOR CLICKING A LOCATION START
        x := args[1]
        y := args[2]
        MsgBox, 0, CraftCommand, Clicking in Crafting area at slot %x%`, %y%, 5
        ; STUFF FOR CLICKING A LOCATION STOP

    } else {
        error_message := "Could not match argument count (" len ") with any sub commands`nDEBUG: args = " args
        MsgBox 0, Invalid Arg Count, %error_message%, 5
    }
}

; Find Command
FindCommand(ByRef item_or_xy_index_as_string) {
    args := StrSplit(item_or_xy_index_as_string, ",")
    len := args.MaxIndex()
    if (len = 1) {

        ; STUFF FOR FINDING AN ITEM IN INVENTORY START
        item := args[1]
        MsgBox, 0, FindCommand, Attempting to find %item% in the Crafting area, 5
        ; STUFF FOR FINDING AN ITEM IN INVENTORY STOP

    } else {
        error_message := "Could not match argument count (" len ") with any sub commands`nDEBUG: args = " args
        MsgBox 0, Invalid Arg Count, %error_message%, 5
    }
}

; Run Command
RunCommand(cmd, ByRef args) {
    ; MsgBox, 0, Command Search, Attempting to run the command %cmd%, 5 
    ; Needs to run through an If Else loop
    if (cmd = "inv") {
        InvCommand(args)
    } else if (cmd = "craft") {
        CraftCommand(args)
    } else if (cmd = "find") {
        FindCommand(args)
    } else if (cmd = "WORD") {
        ; DUPLICATE THE LINE RIGHT ABOVE THIS AND ALTER THE WORD IN THE TOP MOST ONE OF THE cmd = "WORD"
        msg := "Don't use the word 'word' as a command, like really?"
        MsgBox, 0, Easter Egg?, %msg%, 5
    } else {
        error_message := "The command, (" cmd "), was invalid, please check the valid commands"
        MsgBox, 0, Invalid Command, %error_message%, 5
    }
}

ArrayToString_Numbered(ByRef array) {
    string := ""
    for i, entry in array {
        string := string "`n" i ": " entry
    }
    return string
}

; Tests

inv_info := "(inv, item_name / inv, x, y) informs the user, it is attempting to click a certain item or location"
craft_info := "(craft, item_name / craft, x, y) informs the user, it is attempting to click a certain item or location"
find_info := "(find, item_name) informs the user, it is attempting to click a certain item"
initial_message := "Currently implemented commands are`n" inv_info "`n" craft_info "`n" find_info
MsgBox, 0, Info, %initial_message%, 10

iteration := 0
:*?0:parse::
    ; Seems it is possible to alter the instruction_file midway through. Not sure if that is good or bad, but I will keep it for now
    var := LoadInstructionsFromFile(instruction_file) ; Loads all instructions into an Array
    var := StripCommentsFromArray(var) ; Remove all blank lines and comments from Array

    array_loop_count := var.MaxIndex()
    index := Mod(iteration++, array_loop_count) + 1

    entry := SplitCommandAndArgs(var[index])

    ; info_string := ArrayToString_Numbered(entry)

    RunCommand(entry[1], entry[2])

return