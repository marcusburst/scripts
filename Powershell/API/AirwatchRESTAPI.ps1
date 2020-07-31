# All Airwatch Machines #

# This is insecure, only use if desperate #
$userNameWithPassword = 'username:password'
$encoding = [System.Text.Encoding]::ASCII.GetBytes($userNameWithPassword)
$encodedString = [Convert]::ToBase64String($encoding)
$auth = "Basic " + $encodedString
$AWTenantCode = 'awtenantcode'
$airwatchApiToken = @{"Authorization" = $auth; "aw-tenant-code" = $AWTenantCode }
$base_URL = "https://myawurl"
$device_URL = $base_URL + "mdm/devices/search"

# Only return corporate owned devices #
$corporateFilter = $device_URL + '?ownership=c'

$airwatchDevices = Invoke-RestMethod -Method Get -Uri $corporateFilter -Headers $airwatchApiToken -ContentType application/json -UseBasicParsing

$airwatchDevices = $airwatchDevices.Devices