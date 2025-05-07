#! /bin/bash

source ./variables.sh

DBS_DIR="$RUNNING_DIR/$WORK_SPACE"

# Substitute '/' at the end of line and replace it with nothing
dbs=$(ls -F $DBS_DIR | grep '/$' | sed 's/\/$//') 

if [[ -z $dbs ]]; then
    echo "================== Databases =================="
    echo "No databases found in $DBS_DIR"
    echo "==============================================="
else
    echo "================== Databases =================="
    for db in $dbs; do
        echo " - $db"
    done
    echo "==============================================="

fi
