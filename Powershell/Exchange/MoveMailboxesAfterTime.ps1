# Get a list of mailboxes and queue them up after a certain time

$Mailboxes = Get-Content C:\Temp\migrations\mailboxmoves.txt

Foreach($Mailbox in $Mailboxes){ 

    New-Moverequest -Identity $Mailbox -Targetdatabase MYDB -Baditemlimit 100 -Startafter "02/12/2020 10:00 PM"

}