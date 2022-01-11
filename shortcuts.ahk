#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global information_map = []

; Set the File Location for the file to be loaded
file = %A_WorkingDir%\IgnoredFiles\personal_information.txt
; Set FileEncoding
FileEncoding, UTF-8
; Read File into Memory (String)
FileRead, file_string, %file%
; Split on , into Array of Entries ("key":"value")
file_contents_array := StrSplit(file_string, ",`r")
; Loop through array
For i, entry in file_contents_array
{
    ; Split the Array Entry into a Key and Value pair
    key_val_pair := StrSplit(entry, ":", " `t`n`r""", 2)
    ; Get Key as a seperate Object
    entry_key := key_val_pair[1]
    ; Get Value as a seperate Object
    entry_val := key_val_pair[2]
    ; Set Array Index (Key) to hold Value (Value)  |  This functions a lot like a Simple Map<Key, Val>
    information_map[entry_key] := entry_val
}
file_string = ""
file_contents_array = ""

; For writing simple text
PrintSimple(value) {
    msg := information_map[value]
    SendRaw, %msg%
}

; For Pasting text, that cannot be written out (Dongers and such)
PasteSimple(value) {
    Clipboard := information_map[value]
    Send, ^v
}

; Prints the current day as DD/MM/YYYY
PrintCurrentDay() {
    day := A_DD
    month := A_MM
    year := A_YYYY
    SendRaw, %day%/%month%/%year%
}

; Copy and uncomment the following for more Key Values available
; PrintTemplate() {
;     template := information_map["CHANGE_THIS"]
;     SendRaw %template%
; }

; |===========|
; |  Hotkeys  |
; |===========|

:*?0:_mail::
    PrintSimple("mail")
return

:*?0:_username::
    PrintSimple("username")
return

:*?0:_discord::
    PrintSimple("discord")
return

:*?0:_today::
    PrintCurrentDay()
return

:*?0:_password::
    PrintSimple("password")
return

:*?0:_shrug::
    PrintSimple("shrug")
return

:*?0:_lenny::
    PrintSimple("lenny")
return

; Copy and uncomment the following for more Hotkeys
; :*?0:HERE_GOES_HOTSTRING::
;     PrintSimple("HERE_GOES_IDENTIFIER")
; return

:*?0:_exit::
    TrayTip, Exit, Exiting shortcut script,
ExitApp

:*?0:_reload::
    TrayTip, Reload, Reloading shortcut script,
    Reload
return