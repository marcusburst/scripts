$ComputerNames = Get-Content 'C:\Windows\Temp\MyListOfServers.txt'

Invoke-Command -ComputerName $ComputerNames -ScriptBlock {

$ComputerName = $env:COMPUTERNAME
$UserExistsWMI = [bool](Get-WMIObject -ClassName Win32_UserAccount -Computername $ComputerName | Where-Object Name -eq 'mylocaladmin')

if($UserExistsWMI){

    Write-Host "mylocaladmin account exists on $ComputerName"

}

else{

    Write-Host "mylocaladmin account is missing on $ComputerName"
}
}
