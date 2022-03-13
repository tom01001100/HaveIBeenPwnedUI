#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\..\icons\Open Library\open_icon_library-standard\icons\ico\48x48\symbols\pictograms-hazard_signs-toxic.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#Region Includes
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>
#include <ButtonConstants.au3>
#include <WinHttp.au3>
#EndRegion Includes

Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode

Global $GUILoop1 = 1

;== Create Main GUI Window
Global $GUI_Main = GUICreate("SHA1 Hash of String",500,200,-1,-1,BitOR($WS_SYSMENU,$WS_CAPTION))
GUISetBkColor(0xe6e4ff)

;== If X button is pushed, or alt+F4
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

Local $input1 = GUICtrlCreateInput("",10,10,480,20)
Local $button1 = GUICtrlCreateButton("Hash", 430,40,60,20)
Local $button2Clear = GUICtrlCreateButton("Clear", 360,40,60,20)
Local $fullHashInput = GUICtrlCreateInput("",10,70,310,20)
Local $5HashInput = GUICtrlCreateInput("",10,100,46,20)
Local $35HashInput = GUICtrlCreateInput("",66,100,254,20)
Local $label1 = GUICtrlCreateLabel("",10,130,310,50)
GUICtrlSetFont($fullHashInput,9,0,0,"Lucida Console")
GUICtrlSetFont($5HashInput,9,0,0,"Lucida Console")
GUICtrlSetFont($35HashInput,9,0,0,"Lucida Console")
GUICtrlSetFont($input1,10,0,0,"Lucida Console")
GUICtrlSetFont($label1,12,800)
GUICtrlSetState($button1,$GUI_DEFBUTTON)

;== Show everything
GUISetState(@SW_SHOW)

;== Actions!
GUICtrlSetOnEvent($button1,"button1_pushed")
GUICtrlSetOnEvent($button2Clear,"button2Clear_pushed")


While $GUILoop1 = 1
  Sleep(200)  ; Idle around
WEnd



Func button1_pushed()
Local $inputtext = GUICtrlRead($input1)
Local $input1hash = _Crypt_HashData($inputtext,$CALG_SHA1)
Local $inputhashwithout0x = StringRight($input1hash,(StringLen($input1hash)-2))
Local $inputHashWithout0xFirst5 = StringLeft($inputhashwithout0x,5)
Local $inputHashWithout0xLast35 = StringRight($inputhashwithout0x,35)
GUICtrlSetData($fullHashInput,$inputhashwithout0x)
GUICtrlSetData($5HashInput,$inputHashWithout0xFirst5)
GUICtrlSetData($35HashInput,$inputHashWithout0xLast35)
Global $sGet = HttpGet("https://api.pwnedpasswords.com/range/"&$inputHashWithout0xFirst5)
;FileWrite("funTest.txt", $sGet)
Local $position1 = StringinStr($sGet,$inputHashWithout0xLast35)
ConsoleWrite(@CRLF & "'Position of 35 Char Hash (0 if not found)' "&$position1 & @CRLF)
If $position1 <> 0 Then
Local $position2 = (StringInStr($sGet,":",0,2,$position1))
Local $occurances = StringMid($sGet,$position1+36,$position2-($position1+73))
ConsoleWrite(@CRLF & "'2nd :' " & $position2 & @CRLF)
ConsoleWrite(@CRLF & "'How many occurances' " & $occurances & @CRLF)
GUICtrlSetData($label1,"Found "&$occurances&" times.")
EndIf
If $position1 = 0 Then GUICtrlSetData($label1,"Not found.")
GUICtrlSetState($input1,$GUI_FOCUS)
EndFunc

Func button2Clear_pushed()
GUICtrlSetData($label1,"")
GUICtrlSetData($input1,"")
GUICtrlSetData($fullHashInput,"")
GUICtrlSetData($5HashInput,"")
GUICtrlSetData($35HashInput,"")
GUICtrlSetState($input1,$GUI_FOCUS)
EndFunc


Func CLOSEClicked()
	Exit
EndFunc