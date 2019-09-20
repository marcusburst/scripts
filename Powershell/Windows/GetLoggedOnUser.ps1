## Prompts for hostname and outputs current logged on user to write-host ##

$computerName = read-host "Enter Hostname"

$currentUser = (Get-WmiObject -Class win32_computersystem -ComputerName $computerName).Username | write-host

 