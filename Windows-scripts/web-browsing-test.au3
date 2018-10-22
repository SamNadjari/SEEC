
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <AutoItConstants.au3>
#include <ScreenCapture.au3>
#include <File.au3>

#RequireAdmin ; this required for clumsy to work properlys

Opt("WinTitleMatchMode",-2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase





; ============================ Parameters initialization ====================
; QoS
Local $aRTT[1] = [0];,50,100];1,2,5,10,50,100] ;,50, 150]
Local $aLoss[1] = [0];,3,5];,3] ;,0.05,1] ;packet loss rate, unit is %
Global $app = "Web"
Local $logDir = "C:\Users\Harlem1\SEEC\Windows-scripts"
local $picsDir = $logDir & "\Pics6\"
local $picsExt = ".jpg"
GLobal $routerIP = "172.28.30.124" ; the ip address of the server acting as router and running packet capture
Global $routerIF = "ens160" ; the router interface where the clinet is connected
GLobal $routerUsr = "harlem1"
Global $routerPsw = "harlem"
Local $timeInterval = 20000 ;30000
Local $picName = "test-pic"
Local $clinetIPAddress = "172.28.30.9"
Global $udpPort = 60000
Global $no_tasks = 3
Global $runNo = 1
Local $no_of_runs = 1

;============================= Read website list from a file =======================

$sFileName = $logDir & "/alexa-list-parsed.txt"

; Open the file for reading and store the handle to a variable.
Local $hFileOpen = FileOpen($sFileName, $FO_READ)
If $hFileOpen = -1 Then
   MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
   Exit
EndIf

; Read the contents of the file  and save it to an attay
$no_sites = _FileCountLines($hFileOpen)
Local $aWebSites [$no_sites] ;crate array to hold web-sites

For $i = 1 to $no_sites
   $line = FileReadLine($hFileOpen, $i)
   $aWebSites[$i-1] = $line;-1 is because the array starts with 0 and not 1
Next

; Close the handle returned by FileOpen.
FileClose($hFileOpen)

;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = $logDir &"\results\" & $app &"_RT_autoit_run_"& $runNo  ;".txt"

; Open file
Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)

; Prove it exists
If FileExists($sFileName) Then
    ;MsgBox($MB_SYSTEMMODAL, "File", "Exists")
Else
    MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
 EndIf

;==================================== activity =====================================


;load the web-browser (Chrome)
;log time
Local $hTimer = TimerInit() ;begin the timer and store the handler
;mark start of task with a udp packet
;SendPacket("start")

ShellExecute("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe","","","",@SW_MAXIMIZE)
Local $hChrome = WinWaitActive("New Tab - Google Chrome")

Local $timeDiff = TimerDiff($hTimer)/1000 ; find the time difference from the first call of TImerInit, unit sec
;SendPacket("end")
FileWrite($hFilehandle, $aRTT[0] & " "& $aLoss[0] & " " & $timeDiff & " ")
;Sleep($timeInterval)

For $n = 0 To 3 ;$no_sites-1
   ;open new tab
   Send("^t")
   $sWebSiteTitle = StringTrimRight ( $aWebSites[$n], 4 ); to remove .com from the website name
   Sleep(1000)
   $hTimer = TimerInit()
   Send($aWebSites[$n])
   Send("{ENTER}")
   $hWnd = WinWaitActive($sWebSiteTitle)
   $timeDiff = TimerDiff($hTimer)/1000
   FileWrite($hFilehandle, $timeDiff & " ")

   Sleep(1000)

   Switch $sWebSiteTitle
   Case "Google"
	  Search($hWnd, 475,418,"speaker")
   Case "Amazon"
	  Search($hWnd, 331,165,"speaker")
   Case "Youtube"
	  Search($hWnd, 548,108,"speaker")
   Case "Ebay"
	  Search($hWnd, 491,140,"speaker")
   EndSwitch

   Sleep(1000)


   ScrollDown()

   Sleep(1000)
   ;close current tab
   Send("^w")

Next

FileWrite($hFilehandle, @CRLF)

Func ScrollDown()
   Send('{PGDN}')
EndFunc

Func Search($hWnd, $x,$y,$sWord)
   _ConvertXY($x, $y) ; Convert proportionally to the actual desktop size

   MouseClick("left",$x,$y)
   Send($sWord)
   Send('{ENTER}')
   EndFunc

; Fuction to convert screen coordinates
Func _ConvertXY(ByRef $Xin, ByRef $Yin)
     $Xin = Round( ($Xin / 1440) * @DesktopWidth ) ; 1440 is the display resoution of the display where I wrote my code and based on it found the x,y coord
     $Yin = Round( ($Yin / 900) * @DesktopHeight )
EndFunc






