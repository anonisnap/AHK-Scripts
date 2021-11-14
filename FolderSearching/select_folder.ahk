#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; How can we get all files from a folder?
; How can we navigate to a different folder?
; How can we get all files from a different folder?

global file_array = []

Class FileClass {
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
        MsgBox, Creating a new File Object`nFile Name: %file_name%`nPath: %path%
        this.FileName := file_name
        this.Path := path
    }
}


; Creates a long MsgBox with all file paths
ListFileArray(ByRef array) {
    msg :=
    for i, item in array {
        msg := msg "`n" item.Path
    }
    if (msg = "") {
        return
    } else {
        MsgBox % msg
    }
}

; Loads files of an optional format from folder into optional array, updates AND returns array ByRef
LoadImages(ByRef dir, format := "*", ByRef array := 0) {
    if (array = 0) {
        array := []
    }

    Loop, %dir%\*.%format% {
        ; Clean up Filename
        file_name := A_LoopFileName
        file_extension := A_LoopFileExt
        file_name := StrSplit(file_name, file_extension)[1]
        file_name := RTrim(file_name, ".")

        ; Create File Object
        file := new FileClass(file_name, A_LoopFileFullPath)

        ; Add File to Array
        array.Push(file)
    }
    ; Return array | Only really needed incase array wasn't specified when calling function
    return array
}




;       |===========|
;       |  Testing  |
;       |===========|

FileSelectFolder, selected_folder

LoadImages(selected_folder, "png", file_array)
ListFileArray(file_array)
