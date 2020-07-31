$Hosts = Get-Content -Path C:\Temp\awhosts.txt

# Creds titled infobloxss account in SS #
$Credentials = Get-Credential

foreach($Lappy in $Hosts){
    
    $InfobloxReturn = Invoke-RestMethod -URI "https://infobloxserver/wapi/v1.2/record:a?name~=$Lappy" -Credential $Credentials

    $InfobloxArray += $InfobloxReturn
}

# Find hosts that have a bad A record #

$InfobloxBadARecord = $InfobloxArray | Where-Object -Property ipv4addr -eq 0.0.0.0

$InfobloxBadARecord