# Return the number of mailboxes per database

Get-Mailbox -Server mymailserver | Group-Object -property:database | Select-Object name,count | Sort-Object name | Format-Table -auto