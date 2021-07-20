# Get Mailbox folders bigger than 1GB for a specific user

Get-MailboxFolderStatistics -identity 'first.last@email.com' | Where-Object {$_.FolderSize -Gt 1GB} | Select-Object Name,FolderSize,ItemsinFolder | Sort-Object -property foldersize -descending