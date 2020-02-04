#!/bin/bash

lpadmin -p NameOfMyPrinter -o printer-is-shared=false -E -v lpd://networklocation/printer1 -P /Library/Printers/PPDs/Contents/Resources/LocationandNameofmyPPDfile.ppd.gz -D "NameOfMyPrinter" 1>&2 >> /tmp/print.err