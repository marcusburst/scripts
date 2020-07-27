Do {

    $Group = 'MyTestGroup'
    
    Try {
        $GetGroup = Get-ADGroup -Identity $Group -ErrorAction Stop
        Write-Host "$Group Exists!" -ForegroundColor Green
        break
    }
    
    Catch {
        Write-Host "Couldn't find $Group" -ForegroundColor Yellow
        Start-Sleep -Seconds 60
    }
}
    
While ($GetGroup -notmatch $error)