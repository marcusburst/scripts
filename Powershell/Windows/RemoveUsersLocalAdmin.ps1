# Get a list of users that are local admins and remove them if they dont match Administator or Domain Admins

Get-LocalGroupMember Administrators | Where-Object {$_.name -NotLike '*Administrator*' -and $_.name -notlike '*Domain Admins*'} | Remove-LocalGroupMember Administrators