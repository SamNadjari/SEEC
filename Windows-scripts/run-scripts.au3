#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <AutoItConstants.au3>

;#pragma compile(AutoItExecuteAllowed, true)
#RequireAdmin

$script1 = "image-view-RT.au3"
$script2 = "web-browsing.au3"
RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $script1)

MsgBox($MB_OK,"Info","I'm running next script!")

RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $script2)