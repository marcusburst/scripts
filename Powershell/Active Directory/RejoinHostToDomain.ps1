## This script fixes a trust relationship issue without having to leave the workgroup, remove the object from AD etc. ##
## Either run this locally on the host itself or Enter-PSSession to it ##  

$AdminCreds = Get-Credential
$Domain = 'my.domain'

$Computer = Get-WmiObject Win32_ComputerSystem
$Computer.UnjoinDomainOrWorkGroup($AdminCreds.Password, $AdminCreds.UserName, 0)
$Computer.JoinDomainOrWorkGroup($Domain, $AdminCreds.Password, $AdminCreds.UserName, $null, 3)
Restart-Computer -Force