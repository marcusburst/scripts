$Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
$Name = 'TargetGroup'
$GroupExists = Get-ItemProperty -Path $Path -Name $Name

if($GroupExists){
    Remove-ItemProperty -Path $Path -Name $Name
}
else{
    exit
}