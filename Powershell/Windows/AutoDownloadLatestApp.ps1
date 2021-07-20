# Auto download some apps from endpoint

# Download Zoom #

Invoke-WebRequest -Uri 'https://zoom.us/client/latest/ZoomInstallerFull.msi' -Outfile '\\mylocation\ZoomInstallerFull.msi'

# Download Box Drive #

Invoke-WebRequest -Uri 'https://e3.boxcdn.net/box-installers/desktop/releases/win/Box-x64.msi' -Outfile '\\mylocation\Box-x64.msi'