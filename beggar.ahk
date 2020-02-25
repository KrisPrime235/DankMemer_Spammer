; beggar.ahk/exe
; Discord / Dank Memer Beg Bot
; Ron Egli / github.com/smugzombie

AppName = Pls Bot
version = 1.0
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#Persistent
#Include, inc/json.ahk

global OpenWindows := ""
; Load the JSON Config file
loadConfig()

Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop
Gui, Add, Text, x10 y9, Active:
Gui, Add, DDL, y6 x50 w220 vDiscordWindows,
Gui, Add, Button, y5 x275 w50 gClearOpenDiscord, Fetch
Gui, Add, Text, x10 y35, Action: 
Gui, Add, ComboBox, x50 y32 w220 vActions, %History%
;Gui, Add, Button, y31 x275 w50 vRunButton gbeg, Run
Gui, Show,, %AppName% %version%

if (hideGui == 1) {
	Gui, Submit
}

; Fetch the most recent copy of open Discord Windows
goSub ClearOpenDiscord
; Process those windows
Gosub, processWindows
return

; Clears the current GUI of open discord windows, then loads them again
ClearOpenDiscord:
GuiControl,, DiscordWindows, |
OpenPutty :=
goSub, GetOpenDiscord
return

; Fetches the latest truth of what is "open" regarding discord
GetOpenDiscord:
Gui, Submit, Nohide
WinGet, id, list,,, Program Manager
OpenWindows := ""
; Loop through all windows to find "discord" specific ones
Loop, %id%
{
    this_id := id%A_Index%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
	if(this_class = winClass){
		IfInString, this_title, %winTitle%
		{
			GuiControl,, DiscordWindows, %this_title%||
			OpenWindows = %OpenWindows%,%this_id%
		}
	}
	; Do this again in 5 seconds
	SetTimer, ClearOpenDiscord, 5000
}
; Trim off the opening ,
OpenWindows := SubStr(OpenWindows, 2, StrLen(OpenWindows))
return

processWindows:

	IfInString, OpenWindows, ,
	{
		; If we found multiple windows, iterate through them
		for each, Window_id in Windows
		{
			discordCommand(Window_id)
		}
	}
	Else
	{
		; Otherwise just process the one
		discordCommand(OpenWindows)
	}

	; If none were found, sleep for 5 seconds and try again, Otherwise sleep for 5 seconds anyway

	Sleep 5000
	; Then call self to start all over again.
	Gosub, processWindows

Return

discordCommand(WindowId){
	global
	;WinActivate, ahk_id %WindowId%
	WinGetActiveTitle, SwitchBack
	for each, loc_Command in Commands
	{
		processCommand(loc_Command,WindowId)
	}
	WinActivate, %SwitchBack%
}

processCommand(Command, WindowId){
	global
	command_id := Command.id
	command_command := Command.command
	command_freq := Command.freq
	;msgbox % command
	if(checkInterval(command_id,command_freq) == True){
		;msgbox Fired
		BlockInput, On ; Temporarily block input in the event user is typing while the command runs
		WinActivate, ahk_id %WindowId%
		Send %botPrefix% %command_command%{enter}
		Sleep 100
		BlockInput, Off ; Resume input
	}else{
		; Do Nothing
	}
}

loadConfig(){
	global 

	; Verify existance of json file
	IfNotExist, beggar_config.json
	{
		msgbox % "Unable to find beggar_config.json"
		ExitApp, 0
	}
	; Load file to String
	FileRead, jsonString, beggar_config.json
	; Parse JSON
	Data := JSON.Load(jsonString)

	; Set basic Preferences
	winTitle := Data.Preferences.Application.winTitle
	winClass := Data.Preferences.Application.winClass
	hideGui := Data.Preferences.Application.hideGui
	botPrefix := Data.Preferences.Bot.prefix
	debug := Data.Preferences.Application.debug
	commands := Data.Commands

	loadCommands()
	;msgbox % winTitle
}

; Simply creates a new variable, last_run for all commands
loadCommands(){
	global
	for each, loc_Command in Commands
	{
		command_id := loc_Command.id
		last_run%command_id% = 0
	}
}

; Checks when the command was last run, and returns true if ready to run again, otherwise false
checkInterval(command_id, frequency){
	global
	last_run_var = last_run%command_id%
	
	Now := A_TickCount
	StartTime := last_run%command_id%
	difference := Ceil((Now-StartTime)/1000)
	DEBUG(last_run_var "_difference", difference)

	if(last_run%command_id% == 0 || difference > frequency){
		DEBUG(last_run_var "_pre", last_run%command_id%)
		last_run%command_id% := Now
		
		DEBUG(last_run_var "_post", last_run%command_id%)
		DEBUG(last_run_var "_fired", True)
		return True
	}

	DEBUG(last_run_var "_fired", False)
	return False
}

DEBUG(key, value){
	global
	if(debug == 1){
		IniWrite, %value%, debug.ini, Debug, %key%
	}
}
