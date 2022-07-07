#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


global msg_getworldid := "`/getworldid"
global msg_addAndJoin := "Levi on me | Add & Join"

getWorldID() {
    SendRaw, %msg_getworldid%
    Send, {Enter}
    Sleep, 200
    Return
}

addAndJoin(uberDiff) {
    Send, {Enter}
    Sleep, 100
    SendRaw, U%uberDiff% %msg_addAndJoin% | World ID: %Clipboard%
    Sleep, 100
    Send, {Enter}
    Return
}

:*?0:_levi::
    Input, uber, , {Space}{Enter}, 
    getWorldID()
    addAndJoin(uber)
Return