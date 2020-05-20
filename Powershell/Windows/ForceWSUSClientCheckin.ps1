$Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
$Name = 'TargetGroup'
$GroupExists = Get-ItemProperty -Path $Path -Name $Name
$OSVersion = Get-CimInstance win32_operatingsystem | Select-Object Name

if ($GroupExists) {
    Remove-ItemProperty -Path $Path -Name $Name
}

# Start Windows Update service #
start-service wuauserv -ErrorAction SilentlyContinue

# For < Win 10 and < Server 2016 #
if ($OSVersion -like "*Windows 7*") {

    wuauclt.exe /detectnow
    wuauclt.exe /reportnow
}

# For Win 10 > and Server 2016 > #
if ($OSVersion -like "*Windows 10*") {

    (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
    usoclient.exe startscan
}

# Group Policy Update #
gpupdate /force