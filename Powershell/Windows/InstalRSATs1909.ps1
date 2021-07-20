# Install RSAT's for 1909

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v UseWUServer /t REG_DWORD /d 0 /f

restart-service wuauserv

Get-WindowsCapability -Online | Where-Object Name -like Rsat* | Add-WindowsCapability -Online -Source "linktoFoD.ISO"

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v UseWUServer /t REG_DWORD /d 1 /f

restart-service wuauserv