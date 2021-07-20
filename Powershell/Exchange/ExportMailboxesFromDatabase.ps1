# Export mailboxes from a certain database to a CSV

Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Select-Object DisplayName,TotalItemSize,Database | Where-Object {$_.Database -like "myvariable*"} | Sort-Object TotalItemSize -descending | Export-CSV C:\temp\mailboxes.csv