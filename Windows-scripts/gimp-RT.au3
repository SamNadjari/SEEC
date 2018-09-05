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
Local $picName = "test-pic"
;Local $picName2 = "test-pic" ; the image name without the
Local $clinetIPAddress = "10.101.2.3"
Local $udpPort = 60000


For $i = 0 To UBound($aRTT) - 1
   For $j = 0 To UBound($aLoss) - 1

	  ; start packet capture
	  ;router_command("start_capture", $videoSpeed[$k])

	  ;setup UDP socket
	  SetupUDP($clinetIPAddress, $udpPort)

      ; 1) open GIMP
	  ;log time
	  Local $hTimer = TimerInit() ;begin the timer and store the handler
	  ;mark start of task with a udp packet
	  SendPacket("start")
	  ShellExecute("C:\Program Files\GIMP 2\bin\gimp-2.10.exe","","","",@SW_MAXIMIZE)
	  Local $hGIMP = WinWaitActive("GNU Image Manipulation Program")
	  SendPacket("end")

	  Sleep($timeInterval)

	  ; 2) open "open image" window
	  SendPacket("start")
	  Send("^o") ;send ctrl+o to open image
	  ;search for the image
	  WinWaitActive("Open Image")
	  SendPacket("end")

	  Sleep($timeInterval)

	  ; 3) choose image and open it
	  MouseClick($MOUSE_CLICK_LEFT,31,122,1)
	  Send($picName)
	  Send("{ENTER}")
	  Sleep(1000)
	  MouseClick($MOUSE_CLICK_LEFT,209,121,1)
	  SendPacket("start")
	  Send("{ENTER}")
	  WinWaitActive("[" & $picName & "] (imported)-1.0 (RGB color 8-bit gamma integer, GIMP built-in sRGB, 1 layer) 2614x2245 – GIMP")
	  SendPacket("end")

	  Sleep($timeInterval)


	  ;4) choose fuzzy select
	  ;MouseClick($MOUSE_CLICK_LEFT,85,81,1)
	  Send("u") ;shortcut ot fuzzy select
	  ;select an area from the picture
	  MouseClick($MOUSE_CLICK_LEFT,990,393,1)
      SendPacket("start")
	  ;delete area
	  Send("{DEL}")
      SendPacket("end")
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


Func SetupUDP($sIPAddress, $iPort)
	UDPStartup() ; Start the UDP service.

    ; Register OnAutoItExit to be called when the script is closed.
    OnAutoItExitRegister("OnAutoItExit")

	; Assign a Local variable the socket and connect to a listening socket with the IP Address and Port specified.
    Global $iSocket = UDPOpen($sIPAddress, $iPort,1); 1 flag indicates broadcast, because at the zero clinet we cannot run a UDP server
    Local $iError = 0

    ; If an error occurred display the error code and return False.
    If @error Then
        ; The server is probably offline/port is not opened on the server.
        $iError = @error
        MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Client:" & @CRLF & "Could not connect, Error code: " & $iError)
        Return False
    EndIf


    ; Close the socket.
    ;UDPCloseSocket($iSocket)
EndFunc   ;==>MyUDP_Client

Func OnAutoItExit()
    UDPShutdown() ; Close the UDP service.
EndFunc   ;==>OnAutoItExit


Func SendPacket($msg)
	    ; Send the string "toto" converted to binary to the server.
    UDPSend($iSocket, StringToBinary($msg))

    ; If an error occurred display the error code and return False.
    If @error Then
        $iError = @error
        MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Client:" & @CRLF & "Could not send the data, Error code: " & $iError)
        Return False
    EndIf
EndFunc

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

