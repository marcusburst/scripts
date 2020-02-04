## Checks if Office is Running, if one of the below apps is running the script throws an exception ##

@(
    "Word",
    "Outlook",
    "Excel",
    "Powerpoint",
    "OneNote",
    "Access"
) | 

Foreach-Object {
    if (Get-Process $_ -ErrorAction SilentlyContinue)
    {throw "$_ is running" }
    else { Write-Output "$_ is not running" }
}
