#!/usr/bin/bash
source ./utils/output_utils.sh

tables_path="./$WORK_SPACE/$CONNECTED_DB"

tables=$(ls $tables_path)

echo
if [[ -z $tables ]]; then
    echo "================= Tables ================="
    echo "No tables found in '$CONNECTED_DB' database"
    echo "=========================================="


else
    echo "================= Tables ================="
    for table in $tables; do
        echo " - $table"
    done
    echo "=========================================="
fi
