#!/usr/bin/bash

set -e

workspace_path="./$WORK_SPACE"

# Substitute '/' at the end of line and replace it with nothing
dbs=$(ls -F $workspace_path | grep '/$' | sed 's/\/$//') 

echo
if [[ -z $dbs ]]; then
    echo "================== Databases =================="
    echo "No databases found in $workspace_path"
    echo "==============================================="

else
    echo "================== Databases =================="
    for db in $dbs; do
        echo " - $db"
    done
    echo "==============================================="

fi
