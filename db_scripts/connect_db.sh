#! /bin/bash

set -e
source ./utils/validate_utils.sh
source ./utils/output_utils.sh

read -rp "Enter the name of the database you want to connect to: " db_name

# Input Validation
db_name=$(validate_name "$db_name" "Database")

# Existance Validation
db_path="./$WORK_SPACE/$db_name"
error_message="Database '$db_name' doesn't exist."
validate_dir_exists "$db_path" "$error_message"

print_green "Connecting to '${db_name}' database..."

echo $db_name