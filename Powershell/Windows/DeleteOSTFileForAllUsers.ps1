$Users = Get-ChildItem 'C:\Users' | Where-Object { $_.Name -notlike "Administrator" -and $_.Name -ne "Public" -and $_.Name -ne "Default"}

Foreach ($User in $Users) {

    $Folder = "C:\users\" + $User + "\AppData\Local\Microsoft\Outlook" 
    $Folderpath = Test-Path -Path $Folder

    if ($FolderPath) {

        Get-ChildItem $Folder -Filter *.ost | Where-Object { ($_.LastWriteTime -gt (Get-Date).AddDays(-14)) -and ($_.Length /1GB -gt 1) } | Remove-Item -ErrorAction SilentlyContinue
        Write-Output "Deleted OST file for $user"
    }

    else {
        Write-Output "OST file doesn't exist or meet deletion criteria for $user"
    }

}