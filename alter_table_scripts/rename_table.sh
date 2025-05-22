#!/usr/bin/bash
set -e
source ./utils/output_utils.sh
source ./utils/validation_utils.sh

while true; do
    echo
    read -rp "Enter the new name for '$table_name' table: " new_name

    new_name=$(validate_name "$new_name" "Table") || continue

    new_table_data_path="./$WORK_SPACE/$CONNECTED_DB/$new_name"
    new_table_metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$new_name"

    error_message="Error: Table '$new_name' already exists."
    validate_file_does_not_exist "$new_table_data_path" "$error_message" || continue

    mv "$table_data_path" "$new_table_data_path"
    mv "$table_metadata_path" "$new_table_metadata_path"

    echo_green "Table renamed successfully to '$new_name'."
    break
done
