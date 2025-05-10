#! /bin/bash

set -e
source ./utils/validate_utils.sh
source ./utils/output_utils.sh

read -rp "Enter the name of the database you want to connect to: " db_name

# Input Validation
db_name=$(validate_name "$db_name")

# Existance Validation
DIR_PATH="./$WORK_SPACE/$db_name"
ERROR_MESSAGE="Database '$db_name' doesn't exist."
validate_dir_exists "$DIR_PATH" "$ERROR_MESSAGE"

print_green "Connecting to '${db_name}' database..."
# clear_after_1.5_sec

./table_scripts/tables_menu.sh $db_name
