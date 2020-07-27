# Pulls in a list of usernames associated to devices in Airwatch and compares it against a list of AD users that are disabled #
# It's best practice not to use credentials in plain text - this script was quickly written #

# API Credentials #
$UserNameWithPassword = 'username:password'
$Encoding = [System.Text.Encoding]::ASCII.GetBytes($UserNameWithPassword)
$EncodedString = [Convert]::ToBase64String($Encoding)
$Auth = "Basic " + $EncodedString
$AWTenantCode = 'tenantcodestring'

# Get all of the Airwatch Assets #
$Params = @{
    Uri         = 'myairwatchurl'
    Headers     = @{"Authorization" = $Auth; "aw-tenant-code" = $AWTenantCode }
    Method      = 'GET'
    ContentType = 'application/json'
}

# Store the Airwatch Assets in $GetAssets #
$GetAssets = Invoke-RestMethod @Params

# Get a list of Users from Airwatch that have a device assigned to them #
$AirwatchUserNames = $GetAssets.Devices.UserName

# Get a list of AD users that are disabled #
Import-Module ActiveDirectory
$DisabledUsers = Get-ADUser -Filter * -SearchBase "OU=DisabledUsers,OU=Users,OU=Group,DC=My,DC=Domain,DC=FQDN" | Where-Object { $_.Enabled -eq $false } | Select-Object SAMAccountName

# Compare the users #
Compare-Object -ReferenceObject $AirwatchUserNames -DifferenceObject $DisabledUsers