$Profiles = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'

Foreach ($UserProfile in $Profiles) {

    If ($UserProfile -like "*.bak") {
        $ProfilePath = $UserProfile.PSPath
        $PathToDelete = $ProfilePath -replace '\bHKEY_LOCAL_MACHINE\\b', 'HKLM:\'
        Remove-Item -Path $PathToDelete
    }

}