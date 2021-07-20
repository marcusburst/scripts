# Find moverequests that happened on a certain database at a certain time

Get-Moverequest | Get-Moverequeststatistics | Where-Object {$_.QueuedTimeStamp -gt "11/23/2020 00:00:00" -and $_.SourceDatabase -like "XYD*"} | Format-Table displayname, totalmailboxsize, status, percentcomplete | Format-List