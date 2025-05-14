#! /bin/bash

set -e

source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

echo
read -rp "Enter the new name for '$table_name' table: " new_name

# Input Validation
new_name=$(validate_name "$new_name" "Table") 

# Existence Validation
new_table_data_path="./$WORK_SPACE/$CONNECTED_DB/$new_name"
new_table_metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$new_name"

error_message="Table '$new_name' already exists."
validate_file_does_not_exist "$new_name" "$error_message"

mv "$table_data_path" "$new_table_data_path"
mv "$table_metadata_path" "$new_table_metadata_path"

table_name="$new_name"
table_data_path="$new_table_data_path"
table_metadata_path="$new_table_metadata_path"

print_green "Table renamed successfully to '$new_name'."
