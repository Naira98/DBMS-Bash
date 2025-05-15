#! /usr/bin/bash

set -e
source ./utils/select_from_tables_utils.sh
source ./utils/output_utils.sh
source ./utils/constants.sh

table_name=$(select_from_tables "drop")

table_path=./$WORK_SPACE/$CONNECTED_DB/$table_name
metadata_path=./$WORK_SPACE/$CONNECTED_DB/.$table_name

rm -f $table_path $metadata_path
print_green "Table '$table_name' successfully dropped."
