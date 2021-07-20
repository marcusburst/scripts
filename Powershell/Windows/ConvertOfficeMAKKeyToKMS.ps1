# Convert Office MAK key to KMS

Set-Location -Path "C:\Program Files\Microsoft Office\Office16"

Start-Process -FilePath "cmd.exe" -ArgumentList "/c cscript OSPP.VBS /dstatus > C:\temp\officekey.txt" -Wait -Passthru

$CurrentKey = Get-Content -Path "C:\temp\officekey.txt"

if($CurrentKey -match "MAK"){

    Start-Process -FilePath "cmd.exe" -ArgumentList "/c cscript OSPP.VBS /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP" -Wait -Passthru 
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c cscript OSPP.VBS /act" -Wait -Passthru 

}

$TxtFile = 'C:\temp\officekey.txt'

if(Test-Path -Path $TxtFile){
    Remove-Item -Path $TxtFile
}