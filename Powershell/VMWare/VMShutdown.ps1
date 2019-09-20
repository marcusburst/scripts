## Imports a list of VM's from a .txt file and shuts them down ##

$vCenter = 'vCenterURL'

Connect-VIServer $vCenter

foreach($vmName in (Get-Content -Path .\vmnames.txt)){

    $vm = Get-VM -Name $vmName

    if($vm.Guest.State -eq "Running"){

        Shutdown-VMGuest -VM $vm -Confirm:$false

    }

    else{

        Stop-VM -VM $vm -Confirm:$false

    }

}

Disconnect-VIServer -Confirm:$false