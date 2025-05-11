#! /bin/bash

set -e

source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

read -rp "Enter the name of the database you want to create: " db_name

# Input Validation
db_name=$(validate_name "$db_name" "Database")

# Existence Validation
db_path="./$WORK_SPACE/$db_name"
error_message="Database '$db_name' already exists."
validate_dir_does_not_exist "$db_path" "$error_message"

#Create the database directory
mkdir -p "$db_path"
print_green "Database '$db_name' created successfully."
