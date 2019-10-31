#! /usr/bin/pwsh

## Install SnipeitPS module if it doesn't exist ##

if (-not (Get-Module -ListAvailable -Name SnipeitPS)) {
    Install-Module SnipeitPS -Force
} 

## Import Module and set Variables ##

Import-Module SnipeitPS

$apikey = "myapikey"
$url = "https://mysubdomain.snipe-it.io"
$computerName = hostname
$memory = system_profiler SPHardwareDataType | grep "Memory"
$memoryAmount = $memory -replace "      Memory: "
$model = system_profiler SPHardwareDataType | grep "Model Identifier"
$modelno = $model -replace "      Model Identifier: "  
$manufacturer = 'Apple'

    if ( $computerName -like "sydmac*"){
        $category = '5' 
    }

    else{
        $category = '7'
    } 

    if ( $manufacturer -like 'Apple'){

        $manufacturer = '3'
    }

    else{
        $manufacturer = '4'

    }
 
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

    $modelName = [string]::Concat($modelno, " ", $cpuType, " ", $memoryAmount)
 
    $modelSelection = Get-Model -url $url -apikey $apikey | Where-Object {$_.name -eq $modelName}

    if(([string]::IsNullOrEmpty($modelSelection)))
    {
        New-Model -Name "$modelName" -manufacturer_id "$manufacturer" -fieldset_id "1" -category_id "$category" -url $url -apikey $apikey     
           
   } 

    else {
        exit
}