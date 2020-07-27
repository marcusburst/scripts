$RegKeyExists32Bit = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX'
$RegKeyPath32Bit = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\'
$RegKeyExists64Bit = 'HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX'
$RegKeyPath64Bit = 'HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\'


if(-not (Test-Path $RegKeyExists32Bit)){

    New-Item -Path $RegKeyPath32Bit -Name 'FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX' -Force
    New-ItemProperty -Path $RegKeyExists32Bit -Name 'iexplore.exe' -Value '1' -PropertyType DWORD -Force
}

if(-not (Test-Path $RegKeyExists64Bit)){

    New-Item -Path $RegKeyPath64Bit -Name 'FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX' -Force
    New-ItemProperty -Path $RegKeyExists64Bit -Name 'iexplore.exe' -Value '1' -PropertyType DWORD -Force
}