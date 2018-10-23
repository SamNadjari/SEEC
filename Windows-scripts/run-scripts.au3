
$script1 = "image-view-RT.au3"
$script2 = "web-browsing.au3"

RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $script1)
RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $script2)