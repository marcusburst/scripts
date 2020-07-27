#!/bin/bash
lpstat -p | cut -d' ' -f2 | grep myprinternamehere | xargs -I{} lpadmin -x {}