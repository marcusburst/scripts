#! /usr/bin/pwsh

## Installs Module if it doesn't exist, then renames the SnipeIT module so it's properly picked up by Powershell (Linux is very particular) and then renames any instance of that string in the .psd1 file ##
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
$url = "https://companyname.snipe-it.io"
$assetTag = dzdo dmidecode -s system-serial-number
$getAssets = Get-Asset -url $url -apikey $apikey
$assetExists = $getAssets | Where-Object {$_.asset_tag -eq $assetTag}

## Only continue if this asset doesn't exist in SnipeIT already ##

if(([string]::IsNullOrEmpty($assetExists)))
{
    $computerName = hostname
    $computerNameUppercase = $computerName -replace(".companydomain","") | tr [a-z] [A-Z]
    $memory = dzdo dmidecode -t 17 | grep "Size.*MB" | awk '{s+=$2} END {print s / 1024}' 
    $memoryAmount = $memory + " GB"
    $model = dzdo dmidecode -s system-product-name   
    $user = 4
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

    New-Asset -tag "$assetTag" -Name "$computerNameUppercase" -Status_id "$user" -Model_id $modelSelection.id -url "$url" -apikey "$apikey"
              
}

else {
    exit
}
