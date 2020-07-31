# Checks for the existence of a group in AD #
# Useful to run when you've made a change on one DC and are waiting for it to replicate #

Do {

    $Group = 'MYADGroup'
    
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