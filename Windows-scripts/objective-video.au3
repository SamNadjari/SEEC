#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author:         Fatma Alali
 Script Function:
	VIdeo objective test
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

; ============================ Parameters initialization ====================
; QoS
Local $aRTT[3] = [0,50, 150]
Local $aLoss[3] = [0,0.05,1] ;packet loss rate, unit is %
Local $videoDir = "C:\Users\harlem1\Desktop\AUtoIT-scripts\"
Local $vdieoName= ["COSMOS04.mp4" , "out-1fps.mp4"]
Local $activity = "video"
GLobal $routerIP = "10.101.2.1" ; the ip address of the server acting as router and running packet capture
Global $routerIF = "enp0s9" ; the router interface where the clinet is connected
GLobal $routerUsr = "fatma"
Global $routerPsw = "123"

;============================= Create a file for results======================
; Create file in same folder as script
;Global $sFileName = @ScriptDir &"\" & $activity &"-objective.txt"

; Open file
;Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)

; Prove it exists
;If FileExists($sFileName) Then
   ; MsgBox($MB_SYSTEMMODAL, "File", "Exists")
;Else
   ; MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
 ;EndIf

; play video at regular speed

Local $videoSpeed = ["regular" , "slow"]
For $speed in $videoSpeed

  If $speed = "regular" Then
	  $video = $vdieoName[0]
  Else
	  $video = $vdieoName[1]
  EndIf

  ; start packet capture
  router_command("start_capture", $videoSpeed)

  ;================== start video ===========================
  ;log time
  Local $hTimer = TimerInit() ;begin the timer and store the handler

  ;start the video at regular speed
  ShellExecute("C:\Users\harlem1\Documents\" & $video)
  ;ShellExecute($videoDir & $vdieoName)
  Sleep(2000)
  ;wait till the video ends, when the video ends the title of the VLC media player will change and that's what I'm using to detect ends of video
  Local $hVLC = WinWaitActive("VLC media player")
  Local $timeDiff = TimerDiff($hTimer) ; find the time difference from the first call of TImerInit

  WinClose($hVLC)

  ;MsgBox($MB_OK,"Info","Video finished and it took "& $timeDiff & " ms to finish")

  ; stop capture
  router_command("stop_capture")

  ; store the time of the video based on the video speed
  If $speed = "regular" Then
	  Global $reg_time = $timeDiff
  Else
	  Global $slow_time = $timeDiff
  EndIf
Next
;send

Func router_command($cmd, $videoSpeed); cmd: "start_capture", "stop_capture", "analyze"

	; open putty
	ShellExecute("C:\Users\harlem1\Downloads\putty")
	;ShellExecute($videoDir & $vdieoName)
	Local $hPutty = WinWaitActive("PuTTY Configuration")

	;connect to the router linux server
	Send($routerIP)
	ControlClick($hPutty, "","Button1", "left", 1,8,8)

	Local $hShell = WinWaitActive($routerIP & " - PuTTY")
	Send($routerUsr)
	Send("{ENTER}")
	Send($routerPsw)
	Send("{ENTER}")
	Sleep(300)

	If $cmd = "start_capture" Then

	  ;run the capture
	  Local $command = "sudo sh start-tcpdump.sh " & $routerIF & " " & $videoSpeed
	  Send($command)
	  Send("{ENTER}")
	  Sleep(500)
	  Send($routerPsw)
	  Send("{ENTER}")

	ElseIf $cmd = "stop_capture" Then
	  $command = "sudo killall tcpdump"
	  Send($command)
	  Send("{ENTER}")
	  Sleep(500)
	  Send($routerPsw)
	  Send("{ENTER}")

	ElseIf $cmd = "analyze" Then
	  $command = "sh analyze.sh " & $slow_time & " " $reg_time
	  Send($command)
	EndIf

	;close putty
	Sleep(500)
	Send("exit")
	Send("{ENTER}")

EndFunc