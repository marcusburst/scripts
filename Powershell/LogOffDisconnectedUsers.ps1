### Logs off users who have a disconnected user session state
### Originally created for meeting room PCs to circumvent issue with Box Drive not working if someone else is logged in at the same time

quser | Select-String "Disc" | ForEach {logoff ($_.tostring() -split ' +')[2]}
