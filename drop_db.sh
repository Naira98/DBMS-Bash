#! /bin/bash

read -rp "Enter the name of the database you want to drop: " db_name

# Input Validation
result=$(validate_input "$db_name")  # DB name or Error message
status=$?

if [[ $status -eq 0 ]]; then
    # Existance Validation
    validate_dir_existance "$SCRIPT_DIR/$WORK_SPACE/$result"
    status=$?

    if [[ $status -eq 1 ]]; then
        #Create the database directory
        rm -rf "$SCRIPT_DIR/$WORK_SPACE/$result"
        print_success "Database '$result' successfully dropped."
    else
        print_error "Database '$result' doesn't exist."
    fi
else
    print_error "$result"
fi

clear_terminal "$SCRIPT_DIR/main_menu.sh"

