## Imports a list of VM's from a .txt file, shuts them down and deletes them ##

$vCenter = 'vCenterURL'

Connect-VIServer $vCenter

#Create .txt file with list of VM's
$VMs = (Get-Content vmnames.txt)
$vmObj = Get-vm $vms

#If powered on then shutdown 
foreach($active in $vmObj){
if($active.PowerState -eq "PoweredOn"){
Stop-VM -VM $active -Confirm:$false -RunAsync | Out-Null} 
}
Start-Sleep -Seconds 7

#Shutdown each VM in the txt file 
foreach($delete in $vmObj){
Remove-VM -VM $delete -DeleteFromDisk -Confirm:$false -RunAsync | Out-Null}

Disconnect-VIServer -Confirm:$false