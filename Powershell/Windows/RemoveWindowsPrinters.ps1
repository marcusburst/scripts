$Printers = Get-Printer
$PrinterConnectionPath = 'HKCU:\Printers\Connections' 
$PrinterSettingsPath = 'HKCU:\Printers\Settings'

ForEach ($Printer in $Printers) {
    If ($Printer.Name -eq "*MYPRINTERNAME*") {
        Remove-Printer $Printer.Name -ErrorAction SilentlyContinue
    }
}

foreach ($printersetting in $printersettingspath) {
    Remove-ItemProperty -Path $PrinterSettingsPath -Name "*MYPRINTERNAME*" -ErrorAction SilentlyContinue
}

Get-ChildItem -Path $PrinterConnectionPath | ForEach-Object {if ($_ -like "*MYPRINTERNAME*"){Remove-Item -Path "Registry::$_" -confirm:$false}}
