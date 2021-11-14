m1 := "&6&lWelcome&6 to the &cM&feta&cM&fechanists&6 Slimefun Server{!}"
m2 := "&6We are happy to have you here, and we hope you enjoy your stay{!}"
m3 := "&6If you have any questions, you are free to ask in chat as we are happy to help."
m4 := "&6We also have a &bDiscord Server&6 where you, at times, can find us voicechatting."
m5 := "&6To Join this &bDiscord&6, go to: &f&nhttps://discord.com/invite/6Ew8BYxUtZ"

^å::
KeyWait Control
KeyWait å
Send, &r
Send, +{ENTER}
Send, %m1%
Send, +{ENTER}
Send, %m2%
Send, +{ENTER}
Send, %m3%
Send, {ENTER}
Sleep, 1000
Send, &r
Send, +{ENTER}
Send, %m4%
Send, +{ENTER}
Send, %m5%
Send, {ENTER}
return