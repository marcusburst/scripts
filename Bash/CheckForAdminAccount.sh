#!/bin/bash

# Checks if an admin user exists

admexists=$(ls /Users | grep adm)

if [ $admexists == "adm" ];
    then echo "Admin account exists"
    exit 1
else
    echo "No admin account exists"
    exit 0
fi
