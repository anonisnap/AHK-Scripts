#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global information_map = []

file = %A_WorkingDir%\IgnoredFiles\personal_information.txt
; Read File into Memory (String)
FileRead, file_string, %file%
; Split on , into Array of Entries ("key":"value")
file_contents_array := StrSplit(file_string, ",")
; Loop through array
For i, entry in file_contents_array
{
    key_val_pair := StrSplit(entry, ":", " `t`n`r""", 2)
    entry_key := key_val_pair[1]
    entry_val := key_val_pair[2]
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

:*?0:_mail::
    PrintMail()
return

:*?0:_username::
    PrintUsername()()
return

:*?0:_discord::
    PrintDiscord()()
return

Esc::
ExitApp
