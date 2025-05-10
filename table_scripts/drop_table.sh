#! /bin/bash

set -e
source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

read -rp "Enter the name of the table you want to drop: " table_name

# Input Validation
table_name=$(validate_name "$table_name")  # DB name or Error message

# Existence Validation
FILE_PATH="./$WORK_SPACE/$CONNECTED_DB/$table_name"
METADATA_PATH="./$WORK_SPACE/$CONNECTED_DB/.$table_name"
ERROR_MESSAGE="Table '$table_name' doesn't exist."
validate_file_exists "$FILE_PATH" "$ERROR_MESSAGE"

#Create the table directory
rm "$FILE_PATH"
rm "$METADATA_PATH"
print_green "Table '$table_name' successfully dropped."
