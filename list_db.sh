#! /bin/bash

DBS_DIR="$SCRIPT_DIR/${WORK_SPACE}"

# Substitute '/' at the end of line and replace it with nothing
dbs=$(ls -F $DBS_DIR | grep '/$' | sed 's/\/$//') 

echo "Listing Databases..."
sleep 1
for db in $dbs; do
    echo " - $db"
done
