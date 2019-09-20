## Finds PC's that have been inactive for 30,60,90 days and sends an email with the CSVs of the results ##

$logdate = Get-Date -format yyyyMMdd
$logfile30 = "c:\temp\30DaysInactiveComputers - "+$logdate+".csv"
$logfile60 = "c:\temp\60DaysInactiveComputers - "+$logdate+".csv"
$logfile90 = "c:\temp\90DaysInactiveComputers - "+$logdate+".csv"
$mail = "recipient@test.com"
$smtpserver = "mailserver"
$emailFrom = "sender@test.com"
$emailTo = "$mail"
$subject = "Inactive Desktops/VMs in Active Directory"
$body = 
    "Attached you will find a list of Desktops and VM's that have been inactive for 30, 60, 90 days.  Please review."
 
# Change this line to the specific OU that you want to search

$searchOU = "OU=Test,OU=Computers,DC=My,DC=Domain,DC=Directory"

#30 days inactive
$time = (Get-Date).Adddays(-30)
Get-ADComputer -SearchBase $searchOU -Filter {LastLogon -lt $time -and enabled -eq $true} -Properties LastLogon, description |
select-object Name,DistinguishedName, description, enabled,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.LastLogon)}} | export-csv $logfile30 -notypeinformation

#60 days inactive
$time = (Get-Date).Adddays(-60)
Get-ADComputer -SearchBase $searchOU -Filter {LastLogon -lt $time -and enabled -eq $true} -Properties LastLogon, description |
select-object Name,DistinguishedName, description, enabled,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.LastLogon)}} | export-csv $logfile60 -notypeinformation

#90 days inactive
$time = (Get-Date).Adddays(-90)
Get-ADComputer -SearchBase $searchOU -Filter {LastLogon -lt $time -and enabled -eq $true} -Properties LastLogon, description |
select-object Name,DistinguishedName, description, enabled,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.LastLogon)}} | export-csv $logfile90 -notypeinformation


Send-MailMessage -To $emailTo -From $emailFrom -Subject $subject -Body $body -Attachments $logfile30,$logfile60,$logfile90 -SmtpServer $smtpserver