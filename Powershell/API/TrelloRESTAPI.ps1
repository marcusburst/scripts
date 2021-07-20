## Trello API starter.. get all enterprise members and assign them a license ##

## API Token + URLs ##
 
$APIToken = '?key=MYAPITOKEN'
$BaseUrl = 'http://api.trello.com/1/'
$EnterpriseMembersUrl = $BaseUrl + 'enterprises/MYENTERPRISE/members'

# Get Enterprise members (both licensed and unlicensed) #
 
$GetEnterpriseMembers = @{
    URI         = $EnterpriseMembersUrl + $APIToken
    Method      = 'GET'
    ContentType = 'application/json'
}

$EnterpriseMembers = Invoke-RestMethod @GetEnterpriseMembers

# Assign each member of the enterprise a license #

Foreach ($Member in $EnterpriseMembers){

    $AssignEnterpriseLicense = @{
        URI         = $EnterpriseMembersUrl + "/$($Member.id)/licensed" + $APIToken + '&value=1'
        Method      = 'PUT'
        ContentType = 'application/json'
    }

    Invoke-RestMethod @AssignEnterpriseLicense
}