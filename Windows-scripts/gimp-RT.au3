#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author:         Fatma Alali
 Script Function:
	RT objective test for GIMP
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
Local $aRTT[1] = [0] ;,50, 150]
Local $aLoss[1] = [0] ;,0.05,1] ;packet loss rate, unit is %
Local $videoDir = "C:\Users\harlem1\Documents\"
Local $vdieoName= ["COSMOS04.mp4" , "COSMOS04.mp4"] ;"out-1fps.mp4"]
Local $activity = "video"
GLobal $routerIP = "10.101.2.1" ; the ip address of the server acting as router and running packet capture
Global $routerIF = "enp0s9" ; the router interface where the clinet is connected
GLobal $routerUsr = "fatma"
Global $routerPsw = "123"
Local $timeInterval = 3000
Local $picName = "test-pic.jpg"


For $i = 0 To UBound($aRTT) - 1
   For $j = 0 To UBound($aLoss) - 1

	  ; start packet capture
	  ;router_command("start_capture", $videoSpeed[$k])

      ;open GIMP
	  ;log time
	  Local $hTimer = TimerInit() ;begin the timer and store the handler
	  ShellExecute("C:\Program Files\GIMP 2\bin\gimp-2.10.exe")
	  Local $hGIMP = WinWaitActive("GNU Image Manipulation Program")

	  ;open image to edit
	  Send("^o") ;send ctrl+o to open image
	  ;search for the image
	  WinWaitActive("Open Image")
	  MouseClick($MOUSE_CLICK_LEFT,31,122,1)
	  Send($picName)
	  Send("{ENTER}")
	  Sleep(1000)
	  MouseClick($MOUSE_CLICK_LEFT,209,121,1)
	  Send("{ENTER}")

	  ;choose magic select
	  ;MouseClick($MOUSE_CLICK_LEFT,85,81,1)
	  Send("u") ;shortcut ot fuzzy select

	  ;select an area from the picture
	  MouseClick($MOUSE_CLICK_LEFT,990,393,1)

	  ;delete area
	  Send("{DEL}")

	  ;deselect
	  Send("^+a") ;ctrl + shift + a


	  ;select
	  #comments-start
	  C:\Users\harlem1\Documents\SEEC\Windows-scripts\test-pic.jpg

	  Sleep($timeInterval)
	  Local $timeDiff = TimerDiff($hTimer) ; find the time difference from the first call of TImerInit

	  WinClose($hVLC)

	  ;MsgBox($MB_OK,"Info","Video finished and it took "& $timeDiff & " ms to finish")

	  ; stop capture
	  router_command("stop_capture")

	  ; store the time of the video based on the video speed
	  If $videoSpeed[$k] = "regular" Then
		  Global $reg_time = $timeDiff
	  Else
		  Global $slow_time = $timeDiff
	  EndIf
	;send times for analysis
	router_command("analyze", "slow", $aRTT[$i] , $aLoss[$j]) ; here the second param doesn't matter
	#comments-end
   Next
Next




Func router_command($cmd, $videoSpeed="slow", $rtt=0, $loss=0); cmd: "start_capture", "stop_capture", "analyze"
	; open putty
	ShellExecute("C:\Users\harlem1\Downloads\putty")
	;ShellExecute($videoDir & $vdieoName)
	Local $hPutty = WinWaitActive("PuTTY Configuration")

	;connect to the router linux server
	Send($routerIP)
	ControlClick($hPutty, "","Button1", "left", 1,8,8)

	Local $hShell = WinWaitActive($routerIP & " - PuTTY")
	Sleep(500)
	Send($routerUsr)
	Send("{ENTER}")
	Send($routerPsw)
	Send("{ENTER}")
	Sleep(500)

	If $cmd = "start_capture" Then

	  ;run the capture /home/fatma/SEEC/Windows-scripts
	  Local $command = "sudo sh /home/fatma/SEEC/Windows-scripts/start-tcpdump.sh " & $routerIF & " " & $videoSpeed
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


	EndIf

	;close putty
	Sleep(500)
	Send("exit")
	Send("{ENTER}")

EndFunc

