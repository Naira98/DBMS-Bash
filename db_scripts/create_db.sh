#! /bin/bash

set -e

source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

read -rp "Enter the name of the database you want to create: " db_name

# Input Validation
db_name=$(validate_name "$db_name")
echo $db_name

# Existence Validation
DIR_PATH="./$WORK_SPACE/$db_name"
ERROR_MESSAGE="Database '$db_name' already exists."
validate_dir_does_not_exist "$DIR_PATH" "$ERROR_MESSAGE"

#Create the database directory
mkdir -p "$DIR_PATH"
print_green "Database '$db_name' created successfully."
