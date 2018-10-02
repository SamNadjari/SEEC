#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author:         Fatma Alali
 Script Function:
	Take screebnshot with Snipping tool (we cannot use keyboard shrtcut of Print Screen because it requires the "fn" key which Autoit doesn't support)
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <AutoItConstants.au3>

#RequireAdmin ; this required for clumsy to work properlys

#include <WinAPIFiles.au3>
#include <ScreenCapture.au3>


#comments-start
#AutoIt3Wrapper_UseX64=y
$sFile = ("C:\WINDOWS\system32\SnippingTool.exe")
If FileExists($sFile) Then
   Run($sFile)
Else
   MsgBox(0,'File Error', "The Windows snipping tool was not found")
EndIf
#comments-end
;screen_shot(30,1)

; Capture full screen

_ScreenCapture_Capture("C:\Users\Harlem5\SEEC\Windows-scripts\screenShots" & "\image1.jpg", "","",-1,-1, False)

Func screen_shot($rtt, $loss)
   ;Turn off redirection for a 32-bit script on 64-bit system.
   If @OSArch = "X64" And Not @AutoItX64 Then _WinAPI_Wow64EnableWow64FsRedirection(False)
   Run("C:\WINDOWS\system32\SnippingTool.exe")
   $hSnip = WinWaitActive("Snipping Tool")
   ;create new snip
   Send("^n")
   Sleep(500)
   Send("{ENTER}")
   Send("{ENTER}")

   ;save the capture
   Send("^s")
   $hSave = WinWaitActive("Save As")
   ;MsgBox(0,'File Error', "The Windows snipping tool was not found")
   $file_name = "capture-rtt-" & $rtt & "-loss-" & loss
   ;sleep(500)
   ;Send($file_name)
   ControlSetText($hSave,"", "Edit1", "fatma alal")
   Send("{ENTER}")

   ;close app
   ;WinClose($hSnip)




EndFunc
