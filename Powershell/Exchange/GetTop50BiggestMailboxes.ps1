# Return the top 50 biggest mailboxes

Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Select-Object DisplayName,TotalItemSize -First 50 | Sort-Object TotalItemSize -descending | Export-CSV 'C:\temp\top50mailboxes.csv'