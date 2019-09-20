## Auto generates an outlook signature for a user based on their info from AD. Formats the signature based on the sigsource file ##

#Checks if outlook profile exists - we only want it to run on people who have a profile so they don't get an annoying profile popup
$OutlookProfileExists = Test-Path "C:\Users\$env:Username\AppData\Local\Microsoft\Outlook"

if($OutlookProfileExists -eq $true)
{
Write-Host "User Outlook profile exists.. continuing.." -ForegroundColor Yellow 

#variables 
$SignatureName = 'Signature' 
$SigSource = '\\networkedlocation\Signature.docx' 
$SignatureVersion = "1.0"  
$ForceSignature = '0' #'0' = editable ; '1' non-editable and forced. 
  
#Environment variables 
$AppData=$env:appdata 
$SigPath = '\Microsoft\Signatures' 
$LocalSignaturePath = $AppData+$SigPath 
$RemoteSignaturePathFull = $SigSource 
 
#Copy file 
#This If statement will only create the signatures if the Signature folder doesn't already exist.. if you want to apply to everyone then remove the If statement and change the Else to an If
If   ((Test-Path -PathType Container $LocalSignaturePath))
{
       Write-Host "Signature already exists, Script will now exit..." -ForegroundColor Yellow 
       break
}

Elseif (!(Test-Path -Path $LocalSignaturePath\$SignatureVersion)) 
{  
    New-Item -Path $LocalSignaturePath\$SignatureVersion -Type Directory 
} 

Elseif (Test-Path -Path $LocalSignaturePath\$SignatureVersion) 
{ 
    Write-Host "Signature already exists, Script will now exit..." -ForegroundColor Yellow 
    break 
}  
 
#Check signature path  
if (!(Test-Path -path $LocalSignaturePath)) { 
    New-Item $LocalSignaturePath -Type Directory 
} 
 
#Get Active Directory information for logged in user 
$UserName = $env:username 
$Filter = "(&(objectCategory=User)(samAccountName=$UserName))" 
$Searcher = New-Object System.DirectoryServices.DirectorySearcher 
$Searcher.Filter = $Filter 
$ADUserPath = $Searcher.FindOne() 
$ADUser = $ADUserPath.GetDirectoryEntry() 
 
#Copy signature templates from domain to local Signature-folder 
Write-Host "Copying Signatures" -ForegroundColor Green 
Copy-Item "$Sigsource" "$LocalSignaturePath\$SignatureName.docx" -Force 
 
 
#Insert variables from Active Directory to rtf signature-file 
$MSWord = New-Object -ComObject word.application 
$fullPath = "$LocalSignaturePath\$SignatureName.docx" 
$MSWord.Documents.Open($fullPath) 
#$MSWord.visible = $true 
#User Name $ Designation  
 
Function Update-Sig 
{ 
Param($attribute,$value) 
 
$ReplaceAll = 2 ;$FindContinue = 1;$MatchCase = $False;$MatchWholeWord = $True;$MatchWildcards = $False;$MatchSoundsLike = $False;$MatchAllWordForms = $False 
$Forward = $True;$Wrap = $FindContinue;$Format = $False 
 
$FindText = $attribute 
$ReplaceText = $value 

Write-Host "Finding $attribute ....." -ForegroundColor Green -NoNewline 
Write-Host "Replacing with value:$value" -ForegroundColor yellow  
$MSWord.Selection.Find.Execute($FindText, $True, $MatchWholeWord,	$MatchWildcards, $MatchSoundsLike, $MatchAllWordForms, $Forward, $Wrap,    $Format, $ReplaceText, $ReplaceAll	)
if ($MSWord.Selection.Find.Execute($ReplaceText.ToString())) {
  $MSWord.ActiveDocument.Hyperlinks.Add($MSWord.Selection.Range, "mailto:"+$ReplaceText.ToString(), $missing, $missing, $ReplaceText.ToString()) | Out-Null 
} }

$ADUserNumberSplit = '+{0:## # #### ####}' -f ([int64]$ADUser.TelephoneNumber.TrimStart('+'))

Update-Sig -attribute "mail" -value "$([string]($ADUser.mail))" 
Update-Sig -attribute "DisplayName" -value "$([string]($ADUser.displayName))" 
Update-Sig -attribute "title" -value "$([string]($ADUser.title))" 
Update-Sig -attribute "TelephoneNumber" -value "$([string]($ADUserNumberSplit))" 

 
#Save new message signature  
 
#Save HTML 
 
$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatHTML"); 
$path = $LocalSignaturePath+'\'+$SignatureName+".htm" 
$MSWord.ActiveDocument.saveas([ref]$path, [ref]$saveFormat) 
     
#Save RTF  
$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatRTF"); 
$path = $LocalSignaturePath+'\'+$SignatureName+".rtf" 
$MSWord.ActiveDocument.SaveAs([ref] $path, [ref]$saveFormat) 
     
#Save TXT     
$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatText"); 
$path = $LocalSignaturePath+'\'+$SignatureName+".txt" 
$MSWord.ActiveDocument.SaveAs([ref] $path, [ref]$SaveFormat) | Out-Null 
$MSWord.ActiveDocument.Close() 
$MSWord.Quit() 
   

#Office 2016  
 
If (Test-Path HKCU:'\Software\Microsoft\Office\15.0') 
{ 
Write-host "Setting signature for Office 2016"-ForegroundColor Green 
 
    If ($ForceSignature -eq '0') 
    { 
    Write-host "Setting signature for Office 2016 as available" -ForegroundColor Green 
 
    $MSWord = New-Object -comobject word.application 
    $EmailOptions = $MSWord.EmailOptions 
    $EmailSignature = $EmailOptions.EmailSignature 
    $EmailSignatureEntries = $EmailSignature.EmailSignatureEntries 
    $EmailSignature.NewMessageSignature="$SignatureName" 
    $EmailSignature.ReplyMessageSignature="$SignatureName" 

    stop-process -name "outlook" -Force

    Write-host "Closing Outlook.." -ForegroundColor Yellow

    Write-host "Cleaning up recent files list in File Explorer.." -ForegroundColor Yellow

    Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent" -File | sort LastWriteTime -Descending | Remove-Item

    Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" -File | sort LastWriteTime -Descending | Remove-Item
 
    } 
 
    If ($ForceSignature -eq '1') 
    { 
    Write-Host "Setting signature for Office 2016 " 
        If (!(Get-ItemProperty -Name 'NewSignature' -Path HKCU:'\Software\Microsoft\Office\15.0\Common\MailSettings' -ErrorAction SilentlyContinue))   
        {  
        New-ItemProperty HKCU:'\Software\Microsoft\Office\15.0\Common\MailSettings' -Name 'NewSignature' -Value $SignatureName -PropertyType 'String' -Force  
        }  
 
        If (!(Get-ItemProperty -Name 'ReplySignature' -Path HKCU:'\Software\Microsoft\Office\15.0\Common\MailSettings' -ErrorAction SilentlyContinue))   
        {  
        New-ItemProperty HKCU:'\Software\Microsoft\Office\15.0\Common\MailSettings' -Name 'ReplySignature' -Value $SignatureName -PropertyType 'String' -Force 
        }  

     stop-process -name "outlook" -Force

     Write-host "Closing Outlook.." -ForegroundColor Yellow

     Write-host "Cleaning up recent files list in File Explorer.." -ForegroundColor Yellow

     Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent" -File | sort LastWriteTime -Descending | Remove-Item

     Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" -File | sort LastWriteTime -Descending | Remove-Item
    } 
}
}
else
{
    Write-Host "User Outlook profile doesn't exist. This script will run again on next logon and check for Outlook profile existence.." -ForegroundColor Yellow 
    exit
}
