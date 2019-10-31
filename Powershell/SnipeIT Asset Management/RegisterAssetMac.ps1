#! /usr/bin/pwsh

## Install SnipeitPS module if it doesn't exist ##

if (-not (Get-Module -ListAvailable -Name SnipeitPS)) {
    Install-Module SnipeitPS -Force
} 

## Import Module and set Variables ##

Import-Module SnipeitPS

$apikey = "myapikey"
$url = "https://mysubdomain.snipe-it.io"
$assetTag = system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'
$getAssets = Get-Asset -url $url -apikey $apikey
$assetExists = $getAssets | Where-Object {$_.asset_tag -eq $assetTag}

## Only proceed if asset doesn't exist in SnipeIT already ##

if(([string]::IsNullOrEmpty($assetExists)))
{
    $computerName = hostname
    $computerNameUppercase= $computerName | tr [a-z] [A-Z]
    $memory = system_profiler SPHardwareDataType | grep "Memory"
    $memoryAmount = $memory -replace "      Memory: "
    $model = system_profiler SPHardwareDataType | grep "Model Identifier"
    $modelno = $model -replace "      Model Identifier: "   
    $user = 4
    $cpu = system_profiler SPHardwareDataType | grep "Processor Name"

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

    New-Asset -tag $assetTag -Name $computerNameUppercase -Status_id $user -Model_id $modelSelection.id -url $url -apikey $apikey
              
}

else {
    exit
}
