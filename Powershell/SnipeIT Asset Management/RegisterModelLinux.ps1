#! /usr/bin/pwsh

## Installs Module if it doesn't exist, then renames the SnipeIT module so it's properly picked up by Powershell (Linux is very particular) and then renames any instance of that string in the .psd1 file
## Working with Fedora 30 ##

if (-not (Get-Module -ListAvailable -Name SnipeitPS)) {
    Install-Module -Name SnipeitPS -Force
    Set-Location ~/.local/share/powershell/Modules/SnipeitPS/*/
    Rename-Item SnipeItPS.psd1 SnipeitPS.psd1
    Rename-Item SnipeItPS.psm1 SnipeitPS.psm1
    sed -i 's/SnipeItPS/SnipeitPS/g' SnipeitPS.psd1 
} 

## Import Module and set Variables ##

Import-Module SnipeitPS

$apikey = "myapikey"
$url = "https://mysubdomain.snipe-it.io"
$computerName = hostname
$memory = dzdo dmidecode -t 17 | grep "Size.*MB" | awk '{s+=$2} END {print s / 1024}' 
$memoryAmount = $memory + " GB"
$model = dzdo dmidecode -s system-product-name 
$manufacturer = dzdo dmidecode -s chassis-manufacturer

    if ($computerName -like "sygps*"){
        $category = '6' 
    }

    elseif ($computerName -like "syofs*"){
        $category = '6' 
    }
    
    else{
        $category = '7'
    } 

    if ( $manufacturer -like "Dell*"){

        $manufacturer = '2'
    }

    else{
        $manufacturer = '4'

    }
 
    $cpu = dzdo dmidecode -s processor-version
    
    if ($cpu -like "*Xeon*"){
        $cpuType = "Xeon"
    }
    elseif ($cpu -like "*i5*"){
        $cpuType = "i5"
    }
    elseif ($cpu -like "*i7*"){
        $cpuType = "i7"
    }
    elseif ($cpu -like "*i9*"){
        $cpuType = "i9"
    }

    $modelName = [string]::Concat($model, " ", $cpuType, " ", $memoryAmount)
 
    $modelSelection = Get-Model -url $url -apikey $apikey | Where-Object {$_.name -eq $modelName}

    if(([string]::IsNullOrEmpty($modelSelection)))
    {
        New-Model -Name "$modelName" -manufacturer_id "$manufacturer" -fieldset_id "1" -category_id "$category" -url $url -apikey $apikey     
           
   } 

    else {
        exit
}