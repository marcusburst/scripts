## Looks at disk space of hosts in an OU and sends an email with a formatted report showing Disk size / Free Space GB / Free Space % ##
## Good for meeting room pcs ##

$PSEmailServer = 'mailserver'
$Computers = Get-ADComputer -Filter 'Name -like "SYMR*"' -SearchBase "OU=myou,DN=test" | select-object -expandproperty dnshostname
$title = "Meeting Room PC Disk Space Report"
$date = Get-Date -DisplayHint Date | Out-String
$head=@"
<style>
@charset "UTF-8";

table
{
font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
border-collapse:collapse;
}
td 
{
font-size:1em;
border:1px solid #2087db;
padding:5px 5px 5px 5px;
text-align: center; 
}
th 
{
font-size:1.1em;
text-align:center;
padding-top:5px;
padding-bottom:5px;
padding-right:7px;
padding-left:7px;
background-color:#2087db;
color:#ffffff;
text-align: center; 
}
name tr
{
color:#F00000;
background-color:#2087db;
text-align: center; 
}
</style>
"@
$htmlFile = "C:\temp\diskSpace_Server.html"
Get-WmiObject Win32_LogicalDisk -ComputerName $Computers -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue | Select-Object PsComputerName, DeviceID, @{N="Disk Size (GB) ";e={[math]::Round($($_.Size) / 1073741824,2)}}, @{N="Free Space (GB)";e={[math]::Round($($_.FreeSpace) / 1073741824,2)}}, @{N="Free Space (%)";e={[math]::Round($($_.FreeSpace) / $_.Size * 100,1)}} | Sort-Object -Property 'Free Space (%)' | ConvertTo-Html -Head $head -Title "$title" -PreContent "<p><font size=`"6`">$title</font></p>" > $htmlFile

$body = Get-Content "C:\temp\diskSpace_Server.html" -raw
Send-MailMessage -From 'My sender <reportsender@test.com>' -To 'My recipient <reportrecipient@test.com>' -Subject 'Please Review - Meeting Room PC Disk Space Report' -Body $body -BodyAsHtml