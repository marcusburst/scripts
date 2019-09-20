Import-Module ActiveDirectory

$input = Read-Host -Prompt "Enter Username"

Set-AdAccountPassword -Identity $input -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Abcd1234" -Force)