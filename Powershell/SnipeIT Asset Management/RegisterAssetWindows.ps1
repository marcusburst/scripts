## Install SnipeitPS module if it doesn't exist ##

if (-not (Get-Module -ListAvailable -Name SnipeitPS)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module SnipeitPS -Force
} 

## Import Module and set Variables ##

Import-Module SnipeitPS

$apikey = "myapikey"

$url = "https://mysubdomain.snipe-it.io"

$assetTag = (Get-CimInstance win32_bios).SerialNumber
 
$assetExists = Get-Asset -search $assetTag -url $url -apikey $apikey

## Only continue is asset doesn't exist in SnipeIT ##

if(([string]::IsNullOrEmpty($assetExists)))
{
    $computerName = $env:COMPUTERNAME
    $cs = (Get-CimInstance -class Win32_ComputerSystem).TotalPhysicalMemory
    $memory = [math]::Ceiling($cs / 1GB)
    $memoryAmount = [string]::Concat($memory, 'GB')
    $modelno = (Get-CimInstance -class Win32_ComputerSystem).Model    
    $user = (Get-CimInstance -class Win32_ComputerSystem).Username  

## This is a hacky way of setting device Status based on our build process, it'll be changed later.. ideally with device status based on machine IP address ##

    if ( $user -eq 'Administrator'){

        $user = '2' 
    }

    else{

        $user = '4'
    } 
 
    $cpu = (Get-CimInstance Win32_Processor).Name
    if ($cpu -like "*i7*"){
        $cpuType = "i7"
    }
    elseif ($cpu -like "*i5*"){
        $cpuType = "i5"
    }
    elseif ($cpu -like "*i9*"){
        $cpuType = "i9"
    }

    $assetName = [string]::Concat($modelno, " ", $cpuType, " ", $memoryAmount)
 
    $modelSelection = Get-Model -url $url -apikey $apikey | Where-Object {$_.name -eq $assetName}
    
    New-Asset -tag "$assetTag" -Name "$computerName" -Status_id "$user" -Model_id $modelSelection.id -url "$url" -apikey "$apikey"
              
}

else {
    exit
}