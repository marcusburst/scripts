#!/bin/bash

SERIAL=$(/usr/sbin/system_profiler SPHardwareDataType | awk '/Serial Number/ {print $4;}')
PartSerial=$( echo $SERIAL | cut -c 5-8 | tr "[:upper:]"  "[:lower:]" )

newhostname=myhostname$PartSerial
/usr/sbin/scutil --set HostName "$newhostname"
/usr/sbin/scutil --set ComputerName "$newhostname"  
/usr/sbin/scutil --set LocalHostName "$newhostname"   

echo Changing hostname to $newhostname
