#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

; IMAGES
; Gui Images
global gui1_img := "images\mob_gui_1.bmp"
global gui2_img := "images\mob_gui_2.bmp"
global gui3_img := "images\mob_gui_3.bmp"
global gui4_img := "images\mob_gui_4.bmp"
; Items
global cooked_chicken := {id: "cooked_chicken", file: "images\cooked_chicken.png"}
global raw_chicken := {id: "raw_chicken", file: "images\raw_chicken.png"}
global feather := {id: "feather", file: "images\feather.png"}
global egg := {id: "egg", file: "images\egg.png"}
global chestplate := {id: "chestplate", file: "images\chestplate.png"}

; FILE INSTRUCTIONS
global instructions_file := "instructions.txt"

; GUI_SETTINGS
global gui1_settings := {boxSize: 18, craftOffset: {X: 9, Y: 20}, inventoryOffset: {X: 9, Y: 125}}
global gui2_settings := {boxSize: 36, craftOffset: {X: 18, Y: 40}, inventoryOffset: {X: 18, Y: 250}}
global gui3_settings := {boxSize: 54, craftOffset: {X: 27, Y: 60}, inventoryOffset: {X: 27, Y: 375}}
global gui4_settings := {boxSize: 72, craftOffset: {X: 36, Y: 80}, inventoryOffset: {X: 36, Y: 500}}

; LOCATIONS
global _x := -1
global _y := -1
global _boxSize := -1
global _craftOffs := {X: -1, Y: -1}
global _invOffs := {X: -1, Y: -1}

; COORDS SETUP
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; --------------------------------------
; FUNCTIONS
; --------------------------------------

; Sets the global variables to the settings from the passed GUI_SETTING
SetScreenSettings(ByRef gui_settings) {
    _boxSize := gui_settings.boxSize
    _craftOffs := gui_settings.craftOffset
    _invOffs := gui_settings.inventoryOffset
    return
}

; Looks for the image on the entire screen.
; Returns an Object containing a boolean (WasFound) describing if the image was found
; and the X and Y location of the image. The X and Y will be blank if the image was not found
FindImage(ByRef image_file, x1:=0, y1:=0, x2:=-1, y2:=-1) {
    found := false
    if (x2 = -1 || y2 = -1){
        x2 := A_ScreenWidth
        y2 := A_ScreenHeight
    }
    ImageSearch, loc_x, loc_y, %x1%, %y1%, %x2%, %y2%, %image_file%
    if (ErrorLevel = 0) {
        found := true
    }
    result := {WasFound: found, X: loc_x, Y: loc_y}
    return result
}

; Looks for image_file and sets the global _x and _y to it's location. Returns True if Image was found
TryImage(ByRef image_file, ByRef gui_settings) {
    r := FindImage(image_file)
    if (r.WasFound = true) {
        _x := r.X
        _y := r.Y
        SetScreenSettings(gui_settings)
        return true
    }
    return false
}

; Determines the correct Offset for instructions (inv | craft)
GetOffsetFromString(ByRef offset_string) {
    if (offset_string = "inv") {
        return _invOffs
    } else if (offset_string = "craft") {
        return _craftOffs
    }
}

; Halves the screen area and returns the corners of a search area, which only has what's needed
HalfSearchArea(bottom_half := true) {
    ; Why does this need to be reversed... the fuck?
    if (bottom_half = true) {
        area := [0, 0, A_ScreenWidth, A_ScreenHeight//2]
    } else {
        area := [0, A_ScreenHeight//2, A_ScreenWidth, A_ScreenHeight]
    }
    ; MsgBox % "Search Area : " area[1] ", " area[2] ", " area[3] ", " area[4]
    return area
}

; Compares the item_id to the IDs of the global variables and returns the variable which matches
GetImageFromId(ByRef item_id){
    stupid_thing := chestplate.id
    if (%item_id% = %stupid_thing%) {
        return chestplate
    } else {
        stupid_thing := raw_chicken.id
    }

    if (%item_id% = %stupid_thing%) {
        return raw_chicken
    } else {
        stupid_thing := feather.id
    } 

    if (%item_id% = %stupid_thing%) {
        return feather
    } else {
        stupid_thing := egg.id
    }

    if (%item_id% = %stupid_thing%) {
        return egg
    } else {
        stupid_thing := cooked_chicken.id
    }

    if (%item_id% = %stupid_thing%) {
        return cooked_chicken
    }
    MsgBox % item_id " could not be identified"
}

; Clicks an X Y position
Click(x, y, delay := 50){
    MouseClick, Left, x, y
    Sleep, delay
    return
}

; Clicks a location, based on the _boxSize
ClickInTable(ByRef offset, x, y) {
    loc_x := (x-1) * _boxSize + _x + offset.X
    loc_y := (y-1) * _boxSize + _y + offset.Y

    Click(loc_x, loc_y)
    return
}

; Finds and Clicks an Item
ClickItem(bottom_half, ByRef item_id) {
    Loop, 3 {
        image := GetImageFromId(item_id)
        search_area := HalfSearchArea(bottom_half)
        found_image := FindImage(image.file, search_area[1], search_area[2], search_area[3], search_area[4])
        if (found_image.WasFound = true) {
            Click(found_image.X, found_image.Y)
            return
        } else if (A_Index = 3) {
            MsgBox % image.id " could not be found`nAborting item"
            return
        } else {
            MouseMove, 50, 50
            Sleep, 10
        }
    }
    return
}

; Craft Instructions
Craft(ByRef instruction_array) {
    for i in instruction_array {
        ; Get Entry in array
        entry := StrSplit(instruction_array[i], ", ")
        ; Get Size of Entry
        len := entry.MaxIndex()
        ; Check Length, if 2 (inv section, item id), else if 3 (inv section, col, row)
        if (len = 2) {
            ; Determine if Craft or Inv
            bottom_half = true
            if (entry[1] = craft) {
                bottom_half = false
            }
            ; Click item
            ClickItem(bottom_half, entry[2])
        } else if (len = 3) {
            ; Get Offset using String
            offset := GetOffsetFromString(entry[1])
            x := entry[2]
            y := entry[3]
            ; Click location
            ClickInTable(offset, x, y)
        }
    }
    return
}

; Attempts setting the GUI settings using all the images provided.
; Kills the current action if action wasn't possible.
TryAllImages(){
    image_was_found := TryImage(gui1_img, gui1_settings)
    if (image_was_found = false) {
        image_was_found := TryImage(gui2_img, gui2_settings)
    }
    if (image_was_found = false){
        image_was_found := TryImage(gui3_img, gui3_settings)
    }
    if (image_was_found = false){
        image_was_found := TryImage(gui4_img, gui4_settings)
    }
    if (image_was_found = false){
        MsgBox % "GUI Scale could not be determined (" ErrorLevel ")"
        Exit
    }
}

MsgBox % "Chicken Data Card Crafter has started up | Press Ctrl + X to start"
; Hotkey
^x:: ; Ctrl + X
    KeyWait Control ; Wait for Ctrl to be not-clicked
    KeyWait x ; Wait for X to be not-clicked

    TryAllImages() ; Stops if scaling couldn't be set

    FileRead, instructions, %instructions_file%
    instructions := StrSplit(instructions, "`r`n")
    Craft(instructions)
Return