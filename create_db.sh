#! /bin/bash

read -rp "Enter the name of the database you want to create: " db_name

# Input Validation
result=$(validate_input "$db_name")  # DB name or Error message
status=$?

if [[ $status -eq 0 ]]; then
    # Existance Validation
    validate_dir_existance "./$WORK_SPACE/$result"
    status=$?

    if [[ $status -eq 0 ]]; then
        #Create the database directory
        mkdir -p "./$WORK_SPACE/$result"
        print_success "Database '$result' created successfully."
        clear_terminal "./main_menu.sh"
    else
        print_error "Database '$result' already exists."
        clear_terminal "./main_menu.sh"
    fi
    
else
    print_error "$result"
    clear_terminal "./main_menu.sh"
fi

