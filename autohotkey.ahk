#NoEnv
#KeyHistory 12330
#Hotstring ? z
;SendMode Input
;SetBatchLines,-1
;SetControlDelay,-1
SetDefaultMouseSpeed,0
;SetKeyDelay,-1,-1
SetMouseDelay,-1
;SetWinDelay,-1
SetNumLockState,AlwaysOn
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode,2 ;Match title when string is contained anywhere inside.
#SingleInstance,force
global vX ;virtual X axis (spans all monitors)
global vY ;virtual Y axis (spans all monitors)
f8::PrintScreen 
;^Space::winset, alwaysontop, ,a
!Backspace::send {Delete}
;^#g:: Reload
;*capslock::shift
SetCapsLockState, alwaysoff
^SPACE::  Winset, Alwaysontop, , A
^#g::Reload

;+capslock::
;        Keywait, Capslock
;	SetCapsLockState Off
;	Return
capslock::ctrl
;capslock::shift

;z/2022/10/16/05/49/34/Sunday, October 16/
!right::
FormatTime, time, A_nowutc, yyyy'/'MM'/'dd'/'HH'/'mm'/'ss
FormatTime, date, A_now, dddd', 'MMMM' 'dd
send z/%time%/%date%/
return

;#[[2022-10-16 Sunday]]#[[z/2022/10/16]]
#!right::
#right::
keywait right
keywait lwin
keywait right
keywait lwin
keywait right
keywait lwin
FormatTime, time, A_now, yyyy'-'MM'-'dd
FormatTime, date, A_now, dddd
FormatTime, timeu, A_nowutc, yyyy'/'MM'/'dd'
send {#}
send z/%timeu%
;send {enter}
send {space}
send {#}
send [[%time% %date%]]
send {escape}
return

DisplayToolTip(toolTipDescription,toolTipTimer:=500){
  ToolTip,%toolTipDescription%
  SetTimer,RemoveToolTip,%toolTipTimer%
  Return
}
ImgPresent(conditionImage){
  ImageSearch,fX,fY,0,0,vX,vY, ..\img\%conditionImage%.png
  Return !ErrorLevel
}
ImgPresentNav(conditionImage,img*){
  if ImgPresent(conditionImage)
    Return ImgNav(img*)
}
ImgClickOffset(tX:=0,tY:=0,img*) {
  mousegetpos oX,oY
  for imgNum,imgName in img {
    if ImgPresent(imgName){
      imagesearch fX,fY,0,0,vX,vY, ..\img\%imgName%.png
      fX:=fX+tX
      fY:=fY+tY
      click, %fX%,%fY%
      ;Mousemove, %fX%,%fY%
     ;mousemove oX,oY
    }
  }
}
ImgNav(img*){
  MouseGetPos,oX,oY
  for imgNum,imgName in img {
    ImageSearch,fX,fY,0,0,vX,vY, ..\img\%imgName%.png
    MouseMove,%fX%,%fY%
    if(ErrorLevel != 0)
      errorStatus = (%imgName% not found.)`n%errorStatus%
    if(imgNum = img.MaxIndex()){
      if (ErrorLevel = 0)
       Click
      if errorStatus
        DisplayToolTip(errorStatus)
     ; MouseMove,oX,oY
      Return !ErrorLevel
    } Sleep,75
  }
}
RunHotStringTool(){
  AutoTrim Off
  ClipboardOld = %ClipboardAll%
  Clipboard = ''
  Send ^c
  ClipWait 1
  if ErrorLevel
    Return
  StringReplace,Hotstring,Clipboard,``,````,All
  StringReplace,Hotstring,Hotstring,`r`n,``r,All
  StringReplace,Hotstring,Hotstring,`n,``r,All
  StringReplace,Hotstring,Hotstring,%A_Tab%,``t,All
  StringReplace,Hotstring,Hotstring,`;,```;,All
  Clipboard = %ClipboardOld%
  SetTimer,MoveCaret,10
  InputBox,Hotstring,New Hotstring,Type your abreviation at the indicated insertion point. You can also edit the replacement text if you wish.`n`nExample entry: :R:btw`::by the way,,,,,,,, :*:`::%Hotstring%{Enter}
  if ErrorLevel
    Return
  IfInString,Hotstring,:R`:::
  {
    MsgBox Invalid abbreviation. The hotstring has been removed. Please evaluate.
    Return
  }
  FileAppend,`n%Hotstring%,%A_ScriptFullPath%
  ExitApp
  Sleep 200
  MsgBox,4,,The hotstring just added appears to be improperly formatted.  Would you like to open the script for editing? Note that the bad hotstring is at the bottom of the script.
  IfMsgBox,Yes,Edit
    Return
  Return
  MoveCaret:
  IfWinNotActive,New Hotstring
    Return
  Send {Home}{Right 3}
  SetTimer,MoveCaret,Off
    Return
}
RunOrActivate(windowName,programPath:=""){
  IfWinExist,%windowName%
    WinActivate
  else{ 
    if(programPath == "") 
      programPath:=windowName
    Run,%programPath%
  } Return
}
WaitForReload(){
  Sleep,50
  ImageSearch,fX,fY,0,0,vX,vY,*5 ../img/globe.png
  While ErrorLevel != 0 {
    if (A_Index > 50){
      ToolTip,Timeout
      SetTimer,RemoveToolTip,500
      Exit
    } Sleep,5
    DisplayToolTip(A_INDEX)
    ImageSearch,fX,fY,0,0,vX,vY,*5 ../img/globe.png
  }
  Return  
}
#f::runoractivate("(B", "explorer B:\")
RemoveToolTip:
  SetTimer,RemoveToolTip,Off
  ToolTip
  Exit
#b::runoractivate("Chrome")
!+c:: ;	Focuses or opens Chrome, depending. (Ctrl + Shift + C)
      IfWinExist, Chrome
      {
          WinActivate
      }
      else
      {
          run Chrome
      }
  	return
#s:: ; Focuses or opens Notepad++, depending.  (Win + N)
  IfWinExist, Sublime
  {
    WinActivate
  }
  else
  {
    run "C:\Program Files\Sublime Text 3\sublime_text.exe"
  }
  Return
#n:: ;	Focuses or opens Notepad++, depending.	(Win + N)
	IfWinExist, Notepad++
	{
		WinActivate
	}
	else
	{
		run Notepad++
	}
	return
#h:: ;	 Hotstring Tool	(Win + H)
AutoTrim Off
ClipboardOld = %ClipboardAll%
Clipboard =  ;
Send ^c
ClipWait 1
if ErrorLevel  ; ClipWait timed out.
    return
StringReplace, Hotstring, Clipboard, ``, ````, All  ; Do this replacement first to avoid interfering with the others below.
StringReplace, Hotstring, Hotstring, `r`n, ``r, All  ; Using `r works better than `n in MS Word, etc.
StringReplace, Hotstring, Hotstring, `n, ``r, All
StringReplace, Hotstring, Hotstring, %A_Tab%, ``t, All
StringReplace, Hotstring, Hotstring, `;, ```;, All
Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
SetTimer, MoveCaret, 10
InputBox, Hotstring, New Hotstring, Type your abreviation at the indicated insertion point. You can also edit the replacement text if you wish.`n`nExample entry: :R:btw`::by the way,,,,,,,, :*:`::%Hotstring%{Enter}
if ErrorLevel  ; The user pressed Cancel.
    return
IfInString, Hotstring, :R`:::
{
    MsgBox You didn't provide an abbreviation. The hotstring has not been added.
    return
}
FileAppend, `n%Hotstring%, %A_ScriptFullPath%  ; Put a `n at the beginning in case file lacks a blank line at its end.
Reload
Sleep 200 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The hotstring just added appears to be improperly formatted.  Would you like to open the script for editing? Note that the bad hotstring is at the bottom of the script.
IfMsgBox, Yes, Edit
	return
Send {Home}{Right 3}
SetTimer, MoveCaret, Off
	return
;		|-------------------------|
;		|END OF HOTSRING TOOL CODE|
;		|-------------------------|
