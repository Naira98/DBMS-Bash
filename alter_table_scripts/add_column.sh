#!/usr/bin/bash
set -e
source ./utils/table_utils.sh
source ./utils/output_utils.sh

col_num=$(( $(wc -l < "$TABLE_METADATA_PATH") + 1 ))

col_name=$(ask_for_col_name "$TABLE_METADATA_PATH" "Enter the name of new column: " "-1")

data_type=$(ask_for_data_type "$col_name")
    
constraints=$(ask_for_all_constraints $col_name $data_type "::::" "$TABLE_DATA_PATH" "$col_num")

col_metadata="$col_name":"$data_type":"$constraints"

sed -i 's/$/:/' "$TABLE_DATA_PATH"

echo "$col_metadata" >> "$TABLE_METADATA_PATH"


echo_green "Column '$col_name' added to '$TABLE_NAME' table successfully."
