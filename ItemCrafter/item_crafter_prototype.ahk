#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, force

;   | Implemented Stuff
;   |=====================
;   | Reading Instructions
;   | Image Location
;   | Gui Boundaries
;   | User Input for Resource Pack Folder
;   | Remove Empty Lines from Instructions

;   | To Implement
;   |=====================
;   | Item Recognition (Texture Sacling)
;   | Command List and Syntax
;   | Commands
;   | Command Lookup
;   |

;   | Remember
;   |=====================
;   | Remove all ; InformUser(
;   | Texture Scaling when looking for items
;   |

;   |===================|
;   |  Variables Setup  |
;   |===================|

; GUI
GUI1_SETTINGS := {BoxSize: 18, CraftOffset: {X: -1, Y: -1}, InventoryOffset: {X: -1, Y: -1}}
GUI2_SETTINGS := {BoxSize: 36, CraftOffset: {X: -1, Y: -1}, InventoryOffset: {X: -1, Y: -1}}
GUI3_SETTINGS := {BoxSize: 54, CraftOffset: {X: -1, Y: -1}, InventoryOffset: {X: -1, Y: -1}}
GUI4_SETTINGS := {BoxSize: 72, CraftOffset: {X: -1, Y: -1}, InventoryOffset: {X: -1, Y: -1}}
global GUI_SCALE_SIZES := [[1295, 998], [975, 758], [655, 518]] 
global GUI_SETTINGS := [GUI4_SETTINGS, GUI3_SETTINGS, GUI2_SETTINGS, GUI1_SETTINGS]
global GUI_SCALE := {}

; FILE INSTRUCTIONS
global INSTRUCTIONS_FILE := "instructions.txt"
global RESOURCE_PACK_FOLDER := "C:\Users\andre\AppData\Roaming\.minecraft\resourcepacks" ; <-- CHANGE THIS AS YOU SEE FIT

; ITEMS
; global ITEM_LOOKUP := []

; LOCATIONS
global _x := -1
global _y := -1

; COORDINATE SPACE SETUP
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; Point has an X and Y property with Get Functions
Class Point {
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
    ; Creates a new Point Object
    __New(loc_x, loc_y) {
        this.X := loc_x
        this.Y := loc_Y
    }
}

; File has a FileName and Path proerty with Get Functions
Class MyFileClass {
    ; Filename
    FileName {
        get {
            return this.FileName
        }
    }
    ; Filepath
    Path {
        get {
            return this.Path
        }
    }
    ; Constructor (Name, Path)
    __New(file_name, ByRef path) {
        this.FileName := file_name
        this.Path := path
    }
}

;   |=============|
;   |  FUNCTIONS  |
;   |=============|

; Mouse Click
MouseClick(button := "L", times := 1, delay := 50) {
    Loop, times {
        MouseClick, %button%
        Sleep, delay
    }
    return
}

; Moves the mouse to a certain X, Y position
MouseMove(position_x := 0, position_y := 0, speed := 2, is_relative := false) {
    if (is_relative = false) { 
        MouseMove, position_x, position_y, speed, 
    } else {
        MouseMove, position_x, position_y, speed, R
    }
    return
}

; Moves the mouse to a certain Point location
MouseMovePoint(ByRef point, speed := 2, is_relative := false) {
    if (point.X is not integer || point.Y is not integer) {
        InformUser("Point was not correctly defined`nReturning")
        return
    }
    MouseMove(point.X, point.Y, speed, is_relative)
}

; Sends an OK message box to the user for information. Default Timeout of 3 seconds
InformUser(message := "[MESSAGE HERE]", timeout := 1) {
    If (timeout is integer) { 
        TrayTip, info, %message%, %timeout%, 1
        ; MsgBox, , , %message%, %timeout%
    }
}

; SETUP
; Saves the Cursor Location to the global _x and global _y.
SaveCursorLocation() {
    MouseGetPos, _x, _y
}

; Loads the Instructions from the INSTRUCTIONS_FILE into the instruction_array, and the total amount of instructions will be saved at instruction_amounts
InstructionSetup(ByRef instruction_array, ByRef instruction_amounts) {
    FileRead, tmp, %INSTRUCTIONS_FILE% ; Reads the Instruction File and saves it as a single string in the variable tmp
    tmp := StrReplace(tmp, "`t") ; Removes All Tab Characters from the entire list
    tmp := StrReplace(tmp, " ") ; Removes All Space Characters from the entire list
    instruction_array := StrSplit(tmp, "`r`n") ; Splits each line into seperate entries in an Array
    RemoveComments(instruction_array) ; Remove all Comments from the instruction set

    instruction_amounts := instruction_array.MaxIndex()
}

; Loads files of an optional format from folder into optional array, updates AND returns array ByRef
LoadItemTextures(ByRef dir, format := "*", ByRef array := 0) {
    if (array = 0) {
        array := []
    }

    Loop, %dir%\*.%format% {
        ; Clean up Filename
        file_name := A_LoopFileName
        file_extension := A_LoopFileExt
        file_name := StrSplit(file_name, ".")[1]

        ; Create File Object
        file := new MyFileClass(file_name, A_LoopFileFullPath)

        ; Add File to Array
        array.Push(file)
    }
    ; Return array | Only really needed incase array wasn't specified when calling function
    return array
}

; Checks through the GUI_IMAGES and determines the GUI_SETTINGS which should be saved to gui_scaling_settings
ScreenSetup(ByRef gui_scaling_settings) {
    InputBox, gui_scale_user_input, Gui scale, What is your GUI scale?`n(1 | 2 | 3 | 4 | auto), show, 200, 140, , , Locale, , auto
    if (gui_scale_user_input = "auto" || gui_scale_user_input = "") {
        WinGetPos, , , w, h, ahk_class GLFW30, , , 

        loop {
            req_width := GUI_SCALE_SIZES[A_Index, 1]
            req_height := GUI_SCALE_SIZES[A_Index, 2]
            if (w > req_width && h > req_height) {
                gui_scaling_settings := GUI_SETTINGS[A_Index]
                return
            }
        } until A_Index > 2
        last_item_index := GUI_SCALE_SIZES.MaxIndex() + 1
        gui_scaling_settings := GUI_SETTINGS[last_item_index]
        return
    } else {
        gui_scale_number := NumGet(gui_scale_user_input, 0, "int")
        gui_scaling_settings := GUI_SETTINGS[gui_scale_number]
        return
    }
    InformUser("GUI Settings could not be determined")
}

; Looks for the corners of the Inventory and Crafting areas, then creates look-up grids containing the points for each item-slot. These can be accessed using 2D Array Indexing
SearchAreaSetup(ByRef inventory_grid_locations, ByRef crafting_grid_locations) {

}

; COMMAND FUNCTIONS | THESE ARE THE COMMANDS WHICH WILL BE WRITTEN AND USED IN THE SCRIPT
Comment(arr) {
    ; This is purely for typing Comments in the file
    ; Comments can be written using 2 different syntaxes
    ; # message
    ; comment, message
}

; NOT YET IMPLEMENTED
Find(ByRef item_texture_lookup, item, area := "full") {
    fuzzyness := 0
    ; Syntax
    ; find, item, inv | craft
    ; Will search for an item in the specified area and click it
    item_img := GetItemTextureFromArray(item, item_texture_lookup)
    corner1 =
    corner2 =
    if (area = "full") {
        corner1 := new Point(0, 0)
        corner2 := new Point(A_ScreenWidth, A_ScreenHeight)
    } else if (area = "craft") {
        offset
        corner1 := 
    }
    position := FindImage(item_img, corner1, corner2, ,fuzzyness, scale)
    MsgBox % item " was found at " position.X ", " position.Y
}

; Complicated Runtime Functions

; ------------------------------------
; Comment Removal
RemoveComments(ByRef array) {
    RemoveFullComments(array)
    RemovePartialComments(array)
}

; Removes full line comments. Checks if the first value, or command word, is a Comment Indicator (uses IsCommentCommand)
RemoveFullComments(ByRef array) {
    new_array := []
    new_idx := 1
    for i in array {
        entry := array[i]
        was_comment := IsCommentCommand(entry)
        if (was_comment = false) {
            new_array[new_idx] := entry
            new_idx++
        }
    }
    array := new_array.Clone()
    new_array.__Delete()
}

; Removes end-of-line comments. Goes through and splits each entry at the Comment Indicator (#) and saves only the portion before the indicator
RemovePartialComments(ByRef array) {
    for i in array {
        instruction_entry := array[i]
        instruction_clean := StrSplit(instruction_entry, "#", , 2)[1]
        array[i] := instruction_clean
    }
}

; Returns True if either Comment Indicator is found as first in entry
IsCommentCommand(ByRef entry_string) {
    cmd_keyword := StrSplit(entry_string, ",", , 2)[1]
    if (cmd_keyword = "comment" || cmd_keyword = "Comment" || cmd_keyword = "") {
        return true
    } else {
        first_char := SubStr(cmd_keyword, 1, 1)
        if (first_char = "#") {
            return true
        }
        return false
    }
}

; ------------------------------------

; Looks through an Array and returns the first MyFileClass with matching name
GetItemTextureFromArray(item_name, ByRef array) {
    for i, item in array {
        if (item.FileName = item_name) {
            return item
        }
    }
    InformUser(item_name " could not be found. Consider checking the resourcepack for the correct file_name")
}

; Searches for the image_file within the area marked by p1 and p2. Defaults to Entire Main Screen. Returns a Point with X and Y being the top left corner of the image location
FindImage(ByRef image_file, p1 := -1, p2 := -1, search_attempts := 1, allowed_variation := 0, width := 0, height := -1) {
    ; Set Default Points to include entire main Screen
    if (p1 = -1) {
        p1 := new Point(0, 0)
    } 
    if (p2 = -1) {
        p2 := new Point(A_ScreenWidth, A_ScreenHeight)
    }
    ; Check for errors in Search Area
    if (p1 is integer || p2 is integer) {
        InformUser("Search Area was not specified using Points")
    } else if (p1.X is not Integer || p1.Y is not Integer) {
        InformUser("Top Left Corner was not specified correctly", 2)
    } else if (p2.X is not Integer || p2.Y is not Integer) {
        InformUser("Bottom Right Corner was not specified correctly", 2)
    } else if (p1.X >= p2.X || p1.Y >= p2.Y) {
        InformUser("Corners should be in order, Top Left -> Bottom Right`n`t(" p1.X ", " p1.Y ") -> (" p2.X ", " p2.Y ")", 2)
    } else {
        NumGet(VarOrAddress [, Offset = 0, Type = "UInt"])
        ; If Search Area is all good, attempt to find image
        error_offset := 200 // search_attempts
        ; InformUser("Attempting to find " image_file "`n`tAttempt " A_Index "/" search_attempts)
        Loop {
            search_criteria := ImageSearchCriteria(image_file, allowed_variation, width, height)
            ImageSearch, loc_x, loc_y, p1.X, p1.Y, p2.X, p2.Y, %image_file%
            if (ErrorLevel = 2) {
                InformUser("Image could not be loaded") 
            } else if (ErrorLevel = 1) {
                if (A_Index < search_attempts) {
                    MouseMove(error_offset, error_offset, , true)
                } else {
                    MouseMove(_x, _y)
                    ; InformUser("Image could not be found`n(" image_file ")", 2)
                }
            } else {
                point := new Point(loc_x, loc_y)
                return point
            }
        } Until A_Index = search_attempts
    }
}

ImageSearchCriteria(ByRef image, variation, width, height) {
    string = %image% *%variation% *w%width% *h%height%
    return string
}

;   |============|
;   |   INPUTS   |
;   |============|

; Informs User the Bot has been started
MsgBox % "Please locate the item folder in your current resource pack"

; Load all textures in pack
FileSelectFolder, RESOURCE_PACK_FOLDER, %RESOURCE_PACK_FOLDER%

; Sets the current GUI scale
ScreenSetup(GUI_SCALE)

InformUser("To Activate, press Ctrl + R")

;   |============|
;   |   HOTKEY   |
;   |============|

^r:: ; Ctrl + R
    KeyWait, Control
    KeyWait, r
    ; Save Cursor Position
    SaveCursorLocation()

    ; Loads Instructions
    instructions := []
    instruction_count := -1
    InstructionSetup(instructions, instruction_count)

    ; Loads textures from selected resourcepack
    item_lookup_array := []
    LoadItemTextures(RESOURCE_PACK_FOLDER, "png", item_lookup_array)

    ; Defines grids for the inventory and crafting area
    inventory_area := []
    crafting_area := []
    SearchAreaSetup(inventory_area, crafting_area)

    TMP_ListInstructionArray(instructions)
    ; TMP_ListFileArray(item_lookup_array)
Return

; Testing Area
TMP_ListFileArray(ByRef array) {
    msg :=
    for i, item in array {
        msg := msg "`n" i ": " item.FileName
        if (i = 50) {
            break
        }
    }
    if (msg = "") {
        return
    } else {
        MsgBox % msg
    }
}

TMP_ListInstructionArray(ByRef array) {
    msg :=
    for i, item in array {
        msg := msg "`n" i ": " item
        if (i = 50) {
            break
        }
    }
    if (msg = "") {
        return
    } else {
        MsgBox % msg
    }
}
