#! /bin/bash

set -e

source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

old_name=$1
old_table_data_path=$2
old_table_metadata_path=$3

read -rp "Enter the new name for '$old_name' table: " new_name

# Input Validation
new_name=$(validate_name "$new_name" "Table") 

# Existence Validation
new_table_data_path="./$WORK_SPACE/$CONNECTED_DB/$new_name"
new_table_metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$new_name"

error_message="Table '$new_name' already exists."
validate_file_does_not_exist "$new_name" "$error_message"

# echo "$old_table_data_path"
# echo "$new_table_data_path"
# echo "$old_table_metadata_path"
# echo "$new_table_metadata_path"

mv "$old_table_data_path" "$new_table_data_path"
mv "$old_table_metadata_path" "$new_table_metadata_path"

print_green "Table renamed successfully to '$new_name'."
