$Account = 'mylocaladmin'
$Administrators = 'Administrators'
$Password = Read-Host "Enter Password" -AsSecureString
$ComputerNames = Get-Content 'C:\Windows\Temp\MyListOfServers.txt'

Invoke-Command -ComputerName $ComputerNames -ScriptBlock {

if($PSVersionTable.PSVersion.Major -ge 5 -and $PSVersionTable.PSVersion.Minor -ge 1){

$UserExists = [bool](Get-LocalUser -Name $Using:Account)

if(-not ($UserExists)){

    New-LocalUser -Name $Using:Account -Password $Using:Password -PasswordNeverExpires
    Write-Host "Created user $Using:Account on $env:COMPUTERNAME"
    Add-LocalGroupMember -Group $Using:Administrators -Member $Using:Account
    Write-Host "Added User $Using:Account to $Using:Administrators group on $env:COMPUTERNAME"

}

else{

    Write-Host "$Using:Account already exists on $env:COMPUTERNAME"
    exit
}
}

else{

    $ComputerName = $env:ComputerName
    $UserExistsCIM = [bool](Get-WMIObject -ClassName Win32_UserAccount -Computername $ComputerName | Where-Object Name -eq '$Using:Account')

    if(-not ($UserExistsCIM)){

    net user /add $Using:Account MyPlainTextPassword
    Write-Host "Created user $Using:Account on $env:COMPUTERNAME"
    net localgroup $Using:Administrators $Using:Account /add
    Write-Host "Added User $Using:Account to $Using:Administrators group on $env:COMPUTERNAME"

    }

else{
    Write-Host "$Using:Account already existson $env:COMPUTERNAME"
    exit

}
}
}
