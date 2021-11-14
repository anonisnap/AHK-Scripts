; ================================================
; Script: Item Crafter
; Desc: A script for automatically crafting items, 
;       using an instruction file with
; Author: anonisnap | andreasyoungandersen@gmail.com
; Last Updated
;   Date: 7 November 2021
;   Time: 3:25 am
; ================================================

; - NOTICE - NOTICE - NOTICE - NOTICE - NOTICE - 
; ==============================================
;   The Item recognition is a little lacking.
;   It works in some cases, specifically where
;   the size of the item ingame matches the 
;   provided file.
; ==============================================
; - NOTICE - NOTICE - NOTICE - NOTICE - NOTICE - 

#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

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

    __New(x := -1, y := -1) {
        this.X := x
        this.Y := y
    }

    Multiply(k := 1) {
        if k is Number
        {
            this.X *= k
            this.Y *= k
        } else {
            MsgBox, 0, Error, Value of k was not a Number`, %k%, 5 
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

    Clone() {
        return new SimpleVector2Class(this.X, this.Y)
    }

    ToString() {
        string := "V2(" this.X ", " this.Y ")"
        return string
    }
}

Class PairClass {
    Key {
        get {
            return this.Key
        }
    }

    Value {
        get {
            return this.Value
        }
    }

    __New(key, value) {
        this.Key := key
        this.Value := value
        ; Msg("New Pair - " this.Key " : " this.Value)
    }

    IsPair() {
        return true
    }

    ToString() {
        string := "{Key: " this.Key " Value:" this.Value "}"
        return string
    }
}

Class Map {
    ; Gets Value matching Key in a Array of Pairs
    GetValue(ByRef array, key) {
        if (!IsObject(array)) {
            Msg("First Parameter was not Array")
            return ""
        } else {
            For i, pair in array {
                if (pair.Key = key) {
                    value := pair.Value
                    return value
                }
            }
        }
        Msg("Value matching (" key ") not found. Returning -1")
        return -1
    }
}

global _WINDOW := ; Don't worry about this
global _INSTRUCTIONS := "instructions.txt" ; File which has all instructions written down
global _DEFAULT_PATH := A_WorkingDir ; Default Path for the Setup to show
global _RESOURCE_PATH := "" ; Specific path for the selected resource pack
global _GUI_SCALE := 5 ; Defaults to Invalid GUI Scale
global _ITEM_IMAGE_SCALING := -1 ; Pixel size to scale textures to 
global _ITEM_MAP := [] ; Map of all items
global _CRAFT_GRID := []
global _INVENTORY_GRID := []
global _OUTPUT_SLOT := []
global _DELAY := 80 ; Delay in Miliseconds

; Send a Message to the user, 5 second timeout
Msg(message) {
    MsgBox, 1, Info, %message%, 5
}

; Moves the Cursor to a Vector Defined X, Y position on Screen
MoveMouseTo(ByRef vector) {
    if (SimpleVector2Class.IsVector(vector)) {
        x := vector.X
        y := vector.Y
        ; MsgBox, 0, DEBUG, Moving mouse to %x%`, %y%, 5
        MouseMove, x, y, , 
        Sleep, _DELAY
    } else {
        MsgBox, 0, Error, value was not recognized as a valid Vector
    }
}

; Moves the Cursor to a Vector Location and Clicks
ClickLocation(ByRef vector) {
    MoveMouseTo(vector)
    Click
    MouseMove, -64, -64, , R
}

; Instruction parsing
LoadInstructions() {
    FileRead, full_instruction_string, %_INSTRUCTIONS% ; Reads entire file into a long string
    full_instruction_string := StrReplace(full_instruction_string, " ", "") ; Removes all Spaces
    full_instruction_string := StrReplace(full_instruction_string, "`t", "") ; Removes all Tabs
    full_instruction_string := StrReplace(full_instruction_string, "`r", "") ; Removes all Return
    full_instruction_array := StrSplit(full_instruction_string, "`n") ; Splits on each NewLine char and creates a new entry in array
    arr := StripCommentsFromArray(full_instruction_array)
    return arr
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

; Determines which command to run, and runs with the needed args
RunCommand(cmd, ByRef args) {
    if (cmd = "inv") {
        Command(_INVENTORY_GRID, 9, 4, args)
    } else if (cmd = "craft") {
        Command(_CRAFT_GRID, 3, 3, args)
    } else if (cmd = "output") {
        Output()
    } else {
        error_msg := "The command (" cmd ") was not valid.`nPlease check with documentation"
        Msg(error_message)
    }
}

; == Command Handling ==
; Finds an Item in the specified Location
FindItemInBounds(item, ByRef top_left_vector, ByRef bottom_right_vector) {
    ; Verify the bounds are vectors
    if (!SimpleVector2Class.IsVector(top_left_vector)) {
        Msg("Top Left corner was not a Vector")
    }
    if (!SimpleVector2Class.IsVector(bottom_right_vector)) {
        Msg("Bottom Right corner was not a Vector")
    }

    ; Item Search Bounds
    x1 := top_left_vector.X
    y1 := top_left_vector.Y
    x2 := bottom_right_vector.X
    y2 := bottom_right_vector.Y
    ; Assume bounds are correctly setup, because I'm a little lazy
    ; > IMAGE SEARCH HERE
    image_file := Map.GetValue(_ITEM_MAP, item)
    ImageSearch, loc_x, loc_y, x1, y1, x2, y2, *32 *TransBlack %image_file% 
    if (ErrorLevel = 0) {
        v := new SimpleVector2Class(loc_x, loc_y)
        return v
    } else {
        error_msg := "(" ErrorLevel ") Error finding image: " image_file "`nAborting"
        Msg(error_msg)
        Exit
    }
}

; Clicks on the Output Slot
Output() {
    location := _OUTPUT_SLOT[2]
    ClickLocation(location)
}

; Executes Command
Command(ByRef grid, x_lim, y_lim, ByRef item) {
    args := StrSplit(item, ",")
    len := args.Length()
    if (len = 0) {
        location := _OUTPUT_SLOT[1]
        ClickLocation(location)
    } else if (len = 1) {
        offset_vector := new SimpleVector2Class(-_ITEM_IMAGE_SCALING, -_ITEM_IMAGE_SCALING)     ; Create an Offset Vector (up 1, left 1)
        top_left := grid[1, 1].Clone()                                                          ; Create Top Left bound as a Vector
        top_left.AddVector2(offset_vector)                                                      ; Move bound a little for some more leeway
        offset_vector.Multiply(-1)                                                              ; Flip Offset Vector (down 1, right 1)
        bottom_right := grid[x_lim, y_lim].Clone()                                              ; Create Bottom Right bound as a Vector
        bottom_right.AddVector2(offset_vector)                                                  ; Move bound a little for some more leeway
        offset_vector.Multiply(0.5)                                                             ; Shorten Offset Vector (down .5, right .5)
        item_position := FindItemInBounds(item, top_left, bottom_right)                         ; Request Vector for Items location
        item_position.AddVector2(offset_vector)                                                 ; Move location into the center of the box
        ClickLocation(item_position)                                                            ; Move cursor to location and click
    } else if (len = 2) {
        x := args[1]
        y := args[2]
        location := grid[x, y]
        ClickLocation(location)
    } else {
        error_msg := "Could not match the arg count (" len ") with any sub-command"
        Msg(error_msg)
    }
}

; Runs through all commands in the array
RunCommands(ByRef cmd_arr) {
    For i, cmd_entry_string in cmd_arr {
        cmd_entry := SplitCommandAndArgs(cmd_entry_string)
        RunCommand(cmd_entry[1], cmd_entry[2])
        Sleep, _DELAY
    }
}
; == COMMAND HANDLING ==

; Creates Item and Craft grids, as well as the Output Slot
ImportantSlots() {
    center_of_window := GetCenterOfWindow()
    output_offset := RelativeIndexToVector(1, -2)
    out_vector := center_of_window.Clone()
    out_vector.AddVector2(output_offset)
    _OUTPUT_SLOT[1] := out_vector.Clone()
    output_offset := RelativeIndexToVector(2, 0)
    out_vector.AddVector2(output_offset)
    _OUTPUT_SLOT[2] := out_vector.Clone()
    craft_offset := RelativeIndexToVector(-3, -3)
    _CRAFT_GRID := GridSlots(center_of_window.Clone(), craft_offset, 3, 3)
    inv_offset := RelativeIndexToVector(-4, 2)
    _INVENTORY_GRID := GridSlots(center_of_window.Clone(), inv_offset, 9, 4)
    Return
}

; Creates the Grids Slots using vectors, returns the array grid
GridSlots(start, offset, x_lim := 0, y_lim := 0) {
    if (!SimpleVector2Class.IsVector(start) || !SimpleVector2Class.IsVector(offset))
    {
        Msg("Position or Offset was not a valid Vector")
        return
    }
    if x_lim is not number
        Return
    if y_lim is not number
        Return

    arr := []
    padding := (4 * _ITEM_IMAGE_SCALING) // 32
    start.AddVector2(offset)
    x_offset := new SimpleVector2Class(_ITEM_IMAGE_SCALING + padding, 0) 
    y_offset := new SimpleVector2Class(0, _ITEM_IMAGE_SCALING + padding) 
    current := start.Clone()
    y := 1
    Loop {
        x := 1
        current.X := start.X
        Loop {
            arr[x, y] := current.Clone()
            current.AddVector2(x_offset)
            x++
        } until x > x_lim
        current.AddVector2(y_offset)
        y++
    } until y > y_lim
    return arr
}

; Converts the X and Y grid spots to a Vector
RelativeIndexToVector(x_index := 0, y_index := 0) {
    padding := (4 * _ITEM_IMAGE_SCALING) // 32
    x := x_index * (_ITEM_IMAGE_SCALING + padding)
    y := y_index * (_ITEM_IMAGE_SCALING + padding)
    v := new SimpleVector2Class(x, y)
    return v
}

; Gives the Center of the window as a SimpleVector2Class
GetCenterOfWindow() {
    v := new SimpleVector2Class(_WINDOW.W, _WINDOW.H + 5)
    v.Multiply(0.5)
    offset := new SimpleVector2Class(_WINDOW.X, _WINDOW.Y)
    v.AddVector2(offset)
    Return v
}

; Requests the user for current Resource Pack
ResourcePathSetup() {
    FileSelectFolder, _RESOURCE_PATH, %_DEFAULT_PATH%, 0, Locate the Item folder in your current Resourcepack
    If _RESOURCE_PATH = %_DEFAULT_PATH%
    {
        Msg("Ctrl + O to run the Setup Again`nThis cannot run without the folder being set")
        return false
    } else {
        return true
    }
}

; Loads the resource items into memory
ResourcePackLoad() {
    loop, %_RESOURCE_PATH%\*.png {
        file_name := A_LoopFileName
        file_name := StrSplit(file_name, ".")[1]
        pair := new PairClass(file_name, A_LoopFileFullPath)
        _ITEM_MAP[A_Index] := pair
    }
}

; Requests user for GUI Scaling. If Auto is selected, it will use the current active window
GuiSetup() {
    InputBox, gui_scale_user_input, Gui scale, What is your GUI scale?`n(1 | 2 | 3 | 4 | auto), show, 200, 140, , , Locale, , auto
    tmp = %gui_scale_user_input%
    if tmp is number
    {
        _GUI_SCALE := tmp
        return
    } else {
        _GUI_SCALE := "auto"
        return
    }
}

; Gets the GUI scale if the value was set to Auto
GuiAuto() {
    w := _WINDOW.W
    h := _WINDOW.H
    sizes := [[1295, 998], [975, 758], [655, 518], [0, 0]]
    loop {
        req_w := sizes[A_Index, 1]
        req_h := sizes[A_Index, 2]
        if (w > req_w && h > req_h) {
            gui_scale := 5 - A_Index
            return gui_scale
        }
    } until A_Index > 3
    Msg("GUI Scaling could not be determined. Returning -1")
    return -1
}

; Runs all needed setups
Setup() {
    TrayTip, Remark, Image Recognition will not work`, if the images you provide do not match exactly what is seen on screen, 10, 1
        ResourcePathSetup()
    ResourcePackLoad()
    GuiSetup()
}

; == SETUP ==
Setup()

; == HOTKEY ==
^e::
    KeyWait, Control
    KeyWait, e

    _WINDOW := WindowClass.ActiveWindow()
    if (_GUI_SCALE = "auto") {
        _ITEM_IMAGE_SCALING := 16 * GuiAuto()
    } else {
        _ITEM_IMAGE_SCALING := 16 * _GUI_SCALE
    }
    if _ITEM_IMAGE_SCALING is not number
        return
    ImportantSlots()

    ; LOAD AND PARSE COMMANDS
    instructions := LoadInstructions()

    RunCommands(instructions)

Return

^o::
    KeyWait, Control
    KeyWait, o

    Setup()
Return