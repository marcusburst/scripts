function get-logonhistory{
Param (
 [string]$Computer = (Read-Host Remote computer name),
 [int]$Days = 10
 )
 cls
 $Result = @()
 Write-Host "Gathering Event Logs, this can take a while..."
 $ELogs = Get-EventLog System -Source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-$Days) -ComputerName $Computer
 If ($ELogs)
 { Write-Host "Processing..."
 ForEach ($Log in $ELogs)
 { If ($Log.InstanceId -eq 7001)
   { $ET = "Logon"
   }
   ElseIf ($Log.InstanceId -eq 7002)
   { $ET = "Logoff"
   }
   Else
   { Continue
   }
   $Result += New-Object PSObject -Property @{
    Time = $Log.TimeWritten
    'Event Type' = $ET
    User = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
   }
 }
 $Result | Select Time,"Event Type",User | Sort Time -Descending | Out-GridView
 Write-Host "Done."
 }
 Else
 { Write-Host "Problem with $Computer."
 Write-Host "If you see a 'Network Path not found' error, try starting the Remote Registry service on that computer."
 Write-Host "Or there are no logon/logoff events"
 Write-Host "Have you entered a valid computer hostname?"
 }
}


get-logonhistory