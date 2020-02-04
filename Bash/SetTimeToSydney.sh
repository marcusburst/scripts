#!/bin/sh

timezonetocheck=$(/usr/sbin/systemsetup -gettimezone)

# Don't run if the user has already set their time zone to Tokyo, Seoul or Hong Kong #
if [[ $timezonetocheck = *"Tokyo"* ]];then
		echo "Time is set to Japan..ignoring"
		exit
elif [[ $timezonetocheck = *"Seoul"* ]];then
		echo "Time is set to Korea..ignoring"
		exit
elif [[ $timezonetocheck = *"Hong_Kong"* ]];then
		echo "Time is set to Hong Kong..ignoring"
		exit
else
		echo "Timezone isn't set to JP/KR/HK..continuing"
fi

# Use "/usr/sbin/systemsetup -listtimezones" to see a list of available list time zones.
TimeZone="Australia/Sydney"
TimeServer="time.apple.com"

/usr/sbin/systemsetup -setusingnetworktime off 

# Set an initial time zone
/usr/sbin/systemsetup -settimezone $TimeZone

# Set specific time server
/usr/sbin/systemsetup -setnetworktimeserver $TimeServer

# Enable location services
uuid=`/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | cut -c22-57`
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.$uuid LocationServicesEnabled -int 1
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.notbackedup.$uuid LocationServicesEnabled -int 1
/usr/sbin/chown -R _locationd:_locationd /var/db/locationd

# Set time zone automatically using current location 
/usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool true

/usr/sbin/systemsetup -setusingnetworktime on 

exit 0