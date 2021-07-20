<# 
Syntax = (strText,[nSecondsToWait],[strTitle],[nType]) 
In this case, show the text , wait 300 seconds, title of the box is Notifcations and 4096 + 48 + 1 means show on top of window, show exclamation mark and  show OK and Cancel buttons
https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/x83z1d9f(v=vs.84)?redirectedfrom=MSDN#arguments 
#>
 
$Prompt = New-Object -comobject wscript.shell
$Answer = $Prompt.Popup("Windows 1909 update is under way! Please allow roughly 1 hour for this to complete.", 120, "Notification", 4096 + 48 + 0)

<#Switch ($Answer) {

    # Accepted #
    { $Answer -eq 1 } { Start-Sleep -Seconds 60  }
    # Cancelled #
    { $Answer -eq 2 } { Exit 0 }
    # Timeout #
    { $Answer -eq -1 } { Start-Sleep -Seconds 60 }

}
#>