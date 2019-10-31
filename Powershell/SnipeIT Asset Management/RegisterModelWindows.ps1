## Install SnipeitPS module if it doesn't exist ##

if (-not (Get-Module -ListAvailable -Name SnipeitPS)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module SnipeitPS -Force
} 

## Import Module and set Variables ##

Import-Module SnipeitPS

$apikey = "myapikey"
$url = "https://mysubdomain.snipe-it.io"
$computerName = $env:COMPUTERNAME
$cs = (Get-CimInstance -class Win32_ComputerSystem).TotalPhysicalMemory
$memory = [math]::Ceiling($cs / 1GB)
$memoryAmount = [string]::Concat($memory, 'GB')
$modelno = (Get-CimInstance -class Win32_ComputerSystem).Model
$manufacturer = (Get-CimInstance -class Win32_ComputerSystem).Manufacturer

    if ( $computerName -like 'SYDT*'){
        $category = '3' 
    }

    elseif ( $computerName -like 'SYMR*'){
        $category = '3' 
    }

    elseif ( $computerName -like 'SYLT*'){
        $category = '4' 
    }

    else{
        $category = '7'
    } 

    if ( $manufacturer -like '*Dell*'){

        $manufacturer = '2'
    }

    else{
        $manufacturer = '4'

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

    $modelName = [string]::Concat($modelno, " ", $cpuType, " ", $memoryAmount)
 
    $modelSelection = Get-Model -url $url -apikey $apikey | Where-Object {$_.name -eq $modelName}
    

    if(([string]::IsNullOrEmpty($modelSelection)))
    {
        New-Model -Name $modelName -manufacturer_id "$manufacturer" -fieldset_id "1" -category_id "$category" -url $url -apikey $apikey
        
           
    }

    else {
        exit
}