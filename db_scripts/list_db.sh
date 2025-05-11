#! /bin/bash

set -e
source ./utils/constants.sh

workspace_dir="./$WORK_SPACE"

# Substitute '/' at the end of line and replace it with nothing
dbs=$(ls -F $workspace_dir | grep '/$' | sed 's/\/$//') 

if [[ -z $dbs ]]; then
    echo "================== Databases =================="
    echo "No databases found in $workspace_dir"
    echo "==============================================="

else
    echo "================== Databases =================="
    for db in $dbs; do
        echo " - $db"
    done
    echo "==============================================="

fi
