#! /bin/bash

source ./utils/validate_utils.sh
source ./utils/output_utils.sh

read -rp "Enter the name of the database you want to connect to: " db_name


# Input Validation
result=$(validate_input "$db_name")  # DB name or Error message
status=$?

if [[ $status -eq 0 ]]; then
    # Existance Validation
    DIR_PATH="./$WORK_SPACE/$result"
    validate_dir_existance "$DIR_PATH"
    status=$?

    if [[ $status -eq 0 ]]; then
        print_red "Database '$result' doesn't exist."
    else
        print_green "Connecting to '${result}' database..."
        clear_after_1.5_sec

        ./table_scripts/tables_menu.sh $result
    fi
else
    print_red "$result"
fi
