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
#include <ScreenCapture.au3>

#RequireAdmin ; this required for clumsy to work properlys



; ============================ Parameters initialization ====================
; QoS
Local $aRTT[3] = [0,50,100] ;,1,2,5,10,50,100] ;,50, 150]
Local $aLoss[2] = [0,3] ;,0.05,1] ;packet loss rate, unit is %
Global $app = "gimp"
Local $logDir = "C:\Users\Harlem5\SEEC\Windows-scripts"
GLobal $routerIP = "172.28.30.124" ; the ip address of the server acting as router and running packet capture
Global $routerIF = "ens160" ; the router interface where the clinet is connected
GLobal $routerUsr = "harlem1"
Global $routerPsw = "harlem"
Local $timeInterval = 20000 ;30000
Local $picName = "test-pic"
Local $clinetIPAddress = "172.28.30.9"
Global $udpPort = 60000
Global $no_tasks = 3
Global $runNo = 5



;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = $logDir &"\results\" & $app &"-RT-autoit-run-no-"& $runNo & ".txt"

; Open file
Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)

; Prove it exists
If FileExists($sFileName) Then
    ;MsgBox($MB_SYSTEMMODAL, "File", "Exists")
Else
    MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
 EndIf

;=====================open the app and load the picture to have both in the RAM============
ShellExecute("C:\Program Files\GIMP 2\bin\gimp-2.10.exe","","","",@SW_MAXIMIZE)
Local $hGIMP = WinWaitActive("GNU Image Manipulation Program")
Send("^o") ;send ctrl+o to open image
;search for the image
WinWaitActive("Open Image")
MouseClick($MOUSE_CLICK_LEFT,31,122,1)
Send($picName)
Send("{ENTER}")
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT,209,121,1)
Send("{ENTER}")
$hGIMP = WinWaitActive("[" & $picName & "] (imported)-1.0 (RGB color 8-bit gamma integer, GIMP built-in sRGB, 1 layer) 2614x2245 – GIMP")
WinClose($hGIMP)

;================= Start actual test =============================
;setup clumsy basic param to prepare for network configuration
Local $hClumsy = Clumsy("", "open", $clinetIPAddress)

;For $i = 0 To UBound($aRTT) - 1
;   For $j = 0 To UBound($aLoss) - 1

For $j = 0 To UBound($aLoss) - 1
   For $i = 0 To UBound($aRTT) - 1
	  ;configure clumsy
	  Clumsy($hClumsy, "configure","",$aRTT[$i], $aloss[$j])
	  Clumsy($hClumsy, "start")

	  ; start packet capture
	  router_command("start_capture")

	  ;setup UDP socket
	  SetupUDP($clinetIPAddress, $udpPort)

	  Sleep($timeInterval)

      ; 1) open GIMP
	  ;log time
	  Local $hTimer = TimerInit() ;begin the timer and store the handler
	  ;mark start of task with a udp packet
	  SendPacket("start")
	  ShellExecute("C:\Program Files\GIMP 2\bin\gimp-2.10.exe","","","",@SW_MAXIMIZE)
	  Local $hGIMP = WinWaitActive("GNU Image Manipulation Program")
	  ;take screenshot
	  $file_name = "task-1-capture-rtt-" & $aRTT[$i] & "-loss-" & $aloss[$j]
	  _ScreenCapture_Capture($logDir & "\screenShots\" & $file_name & ".png", "","",-1,-1, False)
	  Local $timeDiff = TimerDiff($hTimer)/1000 ; find the time difference from the first call of TImerInit, unit sec
	  SendPacket("end")
	  FileWrite($hFilehandle, $aRTT[$i] & " "& $aLoss[$j] & " " & $timeDiff & " ")

	  Sleep($timeInterval)

	  ; 2) open "open image" window
	  SendPacket("start")
	  $hTimer = TimerInit() ;begin the timer and store the handler
	  Send("^o") ;send ctrl+o to open image
	  ;search for the image
	  WinWaitActive("Open Image")
	  ;take screenshot
	  $file_name = "task-2-capture-rtt-" & $aRTT[$i] & "-loss-" & $aloss[$j]
	  _ScreenCapture_Capture($logDir & "\screenShots\" & $file_name & ".png", "","",-1,-1, False)
	  $timeDiff = TimerDiff($hTimer)/1000 ; find the time difference from the first call of TImerInit
	  SendPacket("end")
	  FileWrite($hFilehandle, $timeDiff & " ")

	  Sleep($timeInterval)

	  ; 3) choose image and open it
	  MouseClick($MOUSE_CLICK_LEFT,31,122,1)
	  Send($picName)
	  Send("{ENTER}")
	  ;Sleep(1000)
	  Sleep($timeInterval)
	  MouseClick($MOUSE_CLICK_LEFT,209,121,1)
	  SendPacket("start")
	  $hTimer = TimerInit() ;begin the timer and store the handler
	  Send("{ENTER}")
	  $hGIMP = WinWaitActive("[" & $picName & "] (imported)-1.0 (RGB color 8-bit gamma integer, GIMP built-in sRGB, 1 layer) 2614x2245 – GIMP")
	  ;take screenshot
	  $file_name = "task-3-capture-rtt-" & $aRTT[$i] & "-loss-" & $aloss[$j]
	  _ScreenCapture_Capture($logDir & "\screenShots\" & $file_name & ".png", "","",-1,-1, False)
	  $timeDiff = TimerDiff($hTimer)/1000 ; find the time difference from the first call of TImerInit
	  SendPacket("end")
	  FileWrite($hFilehandle, $timeDiff & @CRLF)

	  Sleep($timeInterval)



	  ;4) choose fuzzy select
	  ;MouseClick($MOUSE_CLICK_LEFT,85,81,1)
	  ;Send("u") ;shortcut ot fuzzy select
	  ;select an area from the picture
	  ;MouseClick($MOUSE_CLICK_LEFT,990,393,1)
      ;SendPacket("start")
	  ;delete area
	  ;Send("{DEL}")
      ;SendPacket("end")
	  ;deselect
	  ;Send("^+a") ;ctrl + shift + a

	  ;Sleep(1000)


	  ; stop capture
	  router_command("stop_capture")

	  ;plot rate
	  ;router_command("compute_plot","",$aRTT[$i], $aLoss[$j])

	  ;analyze results
	  router_command("analyze_results","",$aRTT[$i], $aLoss[$j])

	  WinClose($hGIMP)

	  Clumsy($hClumsy, "stop")

	  WinClose($hClumsy)
	  $hClumsy = WinActivate("Quit GIMP")
	  Send("^d");ctr + d to discard changes
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
	ShellExecute("C:\Program Files\PuTTY\putty")
	;ShellExecute($videoDir & $vdieoName)
	Local $hPutty = WinWaitActive("PuTTY Configuration")

	;connect to the router linux server
	;Send($routerIP)
	ControlSend("","","",$routerIP)
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
	  Local $command = "sudo sh /home/harlem1/SEEC/Windows-scripts/start-tcpdump.sh " & $routerIF & " " & $videoSpeed
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
	  $command = "sudo bash SEEC/Windows-scripts/analyze.sh " & $slow_time & " " & $reg_time & " " & $rtt & " " & $loss
	  Send($command)
	  Send("{ENTER}")
	  Sleep(300)
	  Send($routerPsw)
	  Send("{ENTER}")

	  ElseIf $cmd = "compute_plot" Then
	  $command = "sh SEEC/Windows-scripts/compute-thru.sh  capture-1-slow.pcap "  & $clinetIPAddress & " " & $rtt & " " & $loss
	  Send($command)
	  Send("{ENTER}")

	  ElseIf $cmd = "analyze_results" Then
	  $command = "sh SEEC/Windows-scripts/analyze_RT.sh  " & $clinetIPAddress & " " & $rtt & " " & $loss & " " & $no_tasks & " " & $app & " " & $runNo
	  Send($command)
	  Send("{ENTER}")


	EndIf

	;close putty
	Sleep(500)
	Send("exit")
	Send("{ENTER}")

EndFunc

Func Clumsy($hWnd, $cmd, $clinetIPAddress="0.0.0.0", $RTT=0, $loss=0)

   If $cmd = "open" Then
	  ShellExecute("C:\Users\Harlem5\Downloads\clumsy-0.2-win64\clumsy.exe")
	  $hWnd = WinWaitActive("clumsy 0.2")
	  ;basic setup
	  ; clear the filter text filed
	  Local $filter = "outbound and ip.DstAddr==" & $clinetIPAddress & " and udp.DstPort != "& $udpPort
	  ControlSetText($hWnd,"", "Edit1", $filter)

	  ; set check box for lag (delay)
	  ControlClick($hWnd, "","Button4", "left", 1,8,8) ;1 click 8,8 coordinate

	  ;set check box for drop
	  ControlClick($hWnd, "","Button7", "left", 1,8,8)
	  Return $hWnd

   ElseIf $cmd = "configure" Then
	  ;make sure it is active
	  WinActivate($hWnd)

	  ;set delay
	  ControlSetText($hWnd,"", "Edit2", $RTT)

	  ;add packet drop
	  ControlSetText($hWnd,"", "Edit3", $loss)

   ElseIf $cmd = "start" Then
	  ;click the start button
	  ControlClick($hWnd, "","Button2", "left", 1,8,8)

   ElseIf $cmd = "stop" Then
	  ;click the start button
	  ControlClick($hWnd, "","Button2", "left", 1,8,8)

   EndIf
EndFunc
