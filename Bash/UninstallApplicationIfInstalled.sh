#!/bin/bash

# Checks if an app is installed, if it is then force uninstall it. Currently using as a pre-install script with Munki.

if [ -e "/Applications/Appname.app" ];
then
rm -r "/Applications/Appname.app"
fi
exit 0
