# Copies the most recent item in the source folder to the destination #
# If you wanted to move the 2nd most recent or 3rd most recent you could change the Sort-Object [0] to [1] or [2] #

$Source = 'source'
$Destination = 'destination'

@(Get-ChildItem $Source -Filter *.bak | Sort-Object LastWriteTime -Descending)[0] | ForEach-Object { Copy-Item -Path $_.FullName -Destination $Destination -Force } 