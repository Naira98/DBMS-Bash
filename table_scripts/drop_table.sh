#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/output_utils.sh

table_name=$(select_from_tables "drop")

table_path="./$WORK_SPACE/$CONNECTED_DB/$table_name"
metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$table_name"

rm -f $table_path $metadata_path
echo_green "Table '$table_name' successfully dropped."
