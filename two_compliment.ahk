#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

title = Two's Complement

Bin(x){
    while x
        r:=1&x r,x>>=1
    return r
}

Dec(x){
    b:=StrLen(x),r:=0
    loop,parse,x
        r|=A_LoopField<<--b
    return r
}

getBinaryNumberFromClipboard() {
    raw_value := ClipBoard
    num = 0
    checkval := RegExMatch(raw_value, "(\b|b)[01]+\b", num)
    if not checkval {
        TrayTip, %title%, Value in Clipboard was not a Binary Value, 8, 3
        Exit, -1
    }
    return num
}

secondComplement(value) {
    l := StrLen(value)
    firstComplement := ""
    Loop, %l%
    {
        i := SubStr(value, A_Index, 1)
        if (i == 0) {
            firstComplement .= 1
        } else {
            firstComplement .= 0
        }
    }

    dec := Dec(firstComplement)
    dec++
    secondComplement := Bin(dec)

    returnString := Format("{:08}", secondComplement)

    return returnString
}

getSecondComplement() {
    binary := getBinaryNumberFromClipboard()
    output := secondComplement(binary)
    Clipboard := output
}

TrayTip, %title%, Copy a Binary number and type '_second' to get the Two's Complement, 8, 1

:*?0:_second::
    getSecondComplement()
Return
