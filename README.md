# AHK-Scripts

###### A random assortment of AHK Scripts which I found joy in creating

<hr>

## <span id=contents>Contents</span>

0. <a href=#contents>Contents</a>
1. <a href=#shortcuts>Shortcuts</a>

<hr>

## <span id=shortcuts>Shortcuts</span>

<i><a href=#contents>(back to contents)</a></i>

`shortcuts.ahk` is a small script used to create, and keep track of, small shortcuts. Allowing for adding custom replacements in a txt file.  

To do this, create a folder called `IgnoredFiles`. Inside of this folder, create a txt file and name it `personal_information.txt`. In this file, you will write the replacements using the following format

```json
"key" : "replacement text"
```

In the script, it currently implements replacements for the `key` values `mail`, `username`, `discord`, and `password`. Adding more if needed is not difficult. By copying the out-commented implementation of the function `PrintTemplate()`, and changing the String in this line, `template := information_map["CHANGE_THIS"]`, to whichever `key` you have defined in `personal_information.txt` will let you use that function to replace a text.

Towards the bottom of the file, you will find the Hotkey/Hotstring implementations. By copying the out-commented Hotstring and replacing the text, `HERE_GOES_HOTSTRING`, with a desired text of your own, when you then type that exact text, it will replace the text with the defined replacement.

Current Shortcuts are 

* `_mail` - Replaces with Text from File
* `_username` - Replaces with Text from File
* `_discord` - Replaces with Text from File
* `_password` - Replaces with Text from File. Please don't actually use this...
* `_today` - Writes current date as DD/MM/YYYY

<hr>