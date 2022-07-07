# AHK-Scripts

**A random assortment of AHK Scripts which I found joy in creating**

## <span id=contents>Contents</span>

0. <a href=#contents>Contents</a>
1. <a href=#shortcuts>Shortcuts</a>
2. <a href=#insert>ItemInsert</a>

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

### Current Shortcuts are

- `_shrug` - Sends a Shrug Emoticon
- `_lenny` - Sends a Lenny Emoticon
- `_mail` - Replaces with Text from File
- `_username` - Replaces with Text from File
- `_discord` - Replaces with Text from File
- `_password` - Replaces with Text from File. Please don't actually use this...
- `_today` - Writes current date as DD/MM/YYYY
- `_exit` - Exits the Script, terminating the process as well
- `+shortcuts` - Reloads the Script

<hr>

## <span id=insert>ItemInsert</span>

<i><a href=#contents>(back to contents)</a></i>

`ItemInsert.ahk` is a small script used for quickly inserting different texts. Primarily meant for quickly sending one of a collection of Dongers

The Inserter is activated when typing `_insert`. This will open a GUI near the cursor. The GUI will then have a list of different items, these are loaded from a text file, and you will then be able to select one of them by either Clicking the button, or clicking the matching number on your keyboard.

![insert preview](https://user-images.githubusercontent.com/42655737/155179022-d54e1dc9-c704-48b1-9064-6982ef922228.png)

To modify the list of items, you will find a `items.txt` in the same directory as the script. Every line of text in this file will show as an option when using the ItemInserter. By adding a new line of text, and writing a piece of text, you will have added a new possible item to insert.

![itemlist preview](https://user-images.githubusercontent.com/42655737/155185560-6cf9e818-5a83-45dc-aa57-2a950d04409a.png)


### Hotstrings

- `_insert` - Opens the Insert Menu
- `+insert` - Reloads the script
