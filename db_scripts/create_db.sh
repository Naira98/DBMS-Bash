#!/usr/bin/bash
set -e
source ./utils/output_utils.sh
source ./utils/validation_utils.sh

while true; do
    echo
    read -rp "Enter the name of the database you want to create: " db_name

    db_name=$(validate_name "$db_name" "Database") || continue

    db_path="./$WORK_SPACE/$db_name"
    error_message="Error: Database '$db_name' already exists."
    validate_dir_does_not_exist "$db_path" "$error_message"  || continue

    mkdir -p "$db_path"
    echo_green "Database '$db_name' created successfully."
    break
done
