<# 
Syntax = (strText,[nSecondsToWait],[strTitle],[nType]) 
In this case, show the text 'PC will reboot in 60 seconds', wait 60 seconds, title of the box is Kill GUIs and 4096 + 48 + 1 means show on top of window, show exclamation mark and  show OK and Cancel buttons
https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/x83z1d9f(v=vs.84)?redirectedfrom=MSDN#arguments 
#>
 
$Prompt = New-Object -comobject wscript.shell
$Answer = $Prompt.Popup("WARNING: PC will reboot in 60 seconds", 60, "Kill GUIs", 4096 + 48 + 1)

Switch ($Answer) {

    # Accepted #
    { $Answer -eq 1 } { Start-Sleep -Seconds 60; Restart-Computer -Force }
    # Cancelled #
    { $Answer -eq 2 } { Exit 0 }
    # Timeout #
    { $Answer -eq -1 } { Start-Sleep -Seconds 60; Restart-Computer -Force }

}
