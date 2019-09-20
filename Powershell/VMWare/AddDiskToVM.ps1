## Pulls in CSV list of VM's and increases their disk size ##

$vCenter = 'vCenterURL'

$newSizeGB = '60'

## Must format CSV with column headers Name | DiskSize and then disksize values as a number without adding GB

$vmList = Import-CSV -Path .\expandVMS.csv

Connect-VIServer $vCenter

foreach ($vm in $vmList) {

Get-VM $vmList.Name | Get-HardDisk | where {$_.Name -eq "Hard Disk 1"} | Set-HardDisk -confirm:$false -CapacityGB $newSizeGB

}

Disconnect-VIServer -Confirm:$false

