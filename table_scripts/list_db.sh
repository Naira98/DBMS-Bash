#!/bin/bash
#! /usr/bin/bash

source ./utils/output_utils.sh

# Function to list tables in the connected database
function list_tables {
    echo "================== Tables =================="
    DB_DIR="./$WORK_SPACE/$DB_NAME"

    # Check if the database exists
    if [[ ! -d "$DB_DIR" ]]; then
        print_red "Database '$DB_NAME' does not exist."
        return 1
    fi

    TABLES_DIR="$DB_DIR"

    # Get a list of tables
    tables=$(ls -F $TABLES_DIR | grep '/$' | sed 's/\/$//')

    if [[ -z $tables ]]; then
        echo "No tables found in '$DB_NAME'."
    else
        echo "Tables in '$DB_NAME':"
        echo "----------------------------------------"
        for table in $tables; do
            echo " - $table"
        done
    fi
    echo "==========================================="
}

# Call the function
list_tables
