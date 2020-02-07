$Account = 'support'
$Password = Read-Host "Enter Password" -AsSecureString
$Administrators = 'Administrators'
$PCList = Get-Content -Path 'C:\temp\InfraServers.txt'

foreach($PC in $PCList){

$UserExists = [bool](Get-LocalUser -Name $Account -ErrorAction SilentlyContinue)

if(-not ($UserExists)){

    New-LocalUser -Name $Account -Password $Password -PasswordNeverExpires
    Write-Host "Created user $Account"
    Add-LocalGroupMember -Group $Administrators -Member $Account
    Write-Host "Added User $Account to $Administrators group"

}

else{

    Write-Host "$Account already exists"
    exit

}
}