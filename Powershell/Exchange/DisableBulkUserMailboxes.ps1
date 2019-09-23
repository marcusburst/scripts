## Bulk disable users mailboxes in Exchange ##

#Create Exchange PowerShell PSSession

$s=New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://server/Powershell -Authentication Kerberos

#Import Exchange PowerShell Session

Import-PSSession -Session $s -AllowClobber

#Import CSV

$users = Get-Content  c:\scripts\users.csv

foreach ($user in $users)
{
Disable-Mailbox -Identity $user -Confirm:$false
Write-Host "$user has been disabled Successfully" -ForegroundColor Green
}

