#! /bin/bash

source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/variables.sh

read -rp "Enter the name of the database you want to drop: " db_name

# Input Validation
result=$(validate_input "$db_name")  # DB name or Error message
status=$?

if [[ $status -eq 0 ]]; then
    # Existance Validation
    DIR_PATH="./$WORK_SPACE/$result"
    validate_dir_existance "$DIR_PATH"
    status=$?

    if [[ $status -eq 1 ]]; then
        #Create the database directory
        rm -rf "$DIR_PATH"
        print_green "Database '$result' successfully dropped."
    else
        print_red "Database '$result' doesn't exist."
    fi
else
    print_red "$result"
fi
