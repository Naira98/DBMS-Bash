#! /bin/bash

source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/variables.sh

read -rp "Enter the name of the database you want to create: " db_name

# Input Validation
result=$(validate_input "$db_name")  # DB name or Error message
status=$?

if [[ $status -eq 0 ]]; then
    # Existance Validation
    DIR_PATH="./$WORK_SPACE/$result"
    validate_dir_existance "$DIR_PATH"
    status=$?

    if [[ $status -eq 0 ]]; then
        #Create the database directory
        mkdir -p "$DIR_PATH"
        print_green "Database '$result' created successfully."
    else
        print_red "Database '$result' already exists."
    fi
else
    print_red "$result"
fi
