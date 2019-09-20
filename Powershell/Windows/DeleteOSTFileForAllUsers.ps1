## Deletes OST file for all users that haven't opened outlook for 2 weeks and have an OST file greater than 1GB ##
## Useful for meeting room/shared PC's ##

$users = Get-ChildItem c:\users | Where-Object {$_.Name -notlike "Administrator" -and $_.Name -ne "Public" -and $_.Name -ne "Default"}


foreach ($user in $users){

$folder = "C:\users\" + $user +"\AppData\Local\Microsoft\Outlook" 
$folderpath = test-path -Path $folder

if($folderpath)
{

Get-ChildItem $folder -filter *.ost | where-object {($_.LastWriteTime -gt (Get-Date).AddDays(-14)) -and ($_.Length /1GB -gt 1)} | remove-item -ErrorAction SilentlyContinue
Write-Output "Deleted OST file for $user"
}

else{

Write-Output "OST file doesn't exist or meet deletion criteria for $user"

}
}


