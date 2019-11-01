## Exports a CSV and removes the Header ##

$Properties = 'GivenName', 'Surname', 'Department', 'EmailAddress', 'Office'
Get-ADUser -Filter 'Department -like "*"' -Properties $Properties |
    Select-Object -Property $Properties |
    ConvertTo-Csv -NoTypeInformation | # Convert to CSV string data without the type metadata
    Select-Object -Skip 1 | # Trim header row, leaving only data columns
    Set-Content -Path "c:\emailaddress.csv"