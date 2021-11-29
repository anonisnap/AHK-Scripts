#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global information_map = []

file = %A_WorkingDir%\IgnoredFiles\personal_information.txt
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

PrintMail() {
    mail := information_map["mail"]
    SendRaw, %mail%
}

PrintUsername() {
    username := information_map["username"]
    SendRaw, %username%
}

PrintDiscord() {
    discord := information_map["discord"]
    SendRaw, %discord%
}

PrintCurrentDay() {
    day := A_DD
    month := A_MM
    year := A_YYYY
    SendRaw, %day%/%month%/%year%
}

PrintPassword() {
    pass := information_map["password"]
    SendRaw, %pass%
}

; |===========|
; |  Hotkeys  |
; |===========|

:*?0:_mail::
    PrintMail()
return

:*?0:_username::
    PrintUsername()
return

:*?0:_discord::
    PrintDiscord()
return

:*?0:_today::
    PrintCurrentDay()
return

:*?0:_password::
    PrintPassword()
return

:*?0:_exit::
ExitApp
