#! /bin/bash

set -e
source ./utils/select_from_tables_utils.sh
source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

table_name=$(select_from_tables "drop")

#Create the table directory
rm -f "$FILE_PATH" "$METADATA_PATH"
print_green "Table '$table_name' successfully dropped."
