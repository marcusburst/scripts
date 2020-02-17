#!/bin/sh

# Get current user

currentUser=$(stat -f "%Su" /dev/console)

# Enter time in format yymmddhhmm

sudo shutdown -r 2002172330

# Run command as user who's logged in (Otherwise prompt never appears)

su - "$currentUser" -c osascript -e <<EOT

tell app "System Events" to display dialog "Your laptop is in violation of a COMPANY compliance policy and has been scheduled to reboot at 11:30pm tonight to install critical security updates. - Please talk to the IT Support Team if you have any issues."

EOT