#! /bin/bash

set -e
source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

read -rp "Enter the name of the database you want to drop: " db_name

# Input Validation
db_name=$(validate_name "$db_name")  # DB name or Error message

# Existance Validation
DIR_PATH="./$WORK_SPACE/$db_name"
ERROR_MESSAGE="Database '$db_name' doesn't exist."
validate_dir_exists "$DIR_PATH" "$ERROR_MESSAGE"

rm -rf "$DIR_PATH"
print_green "Database '$db_name' successfully dropped."
