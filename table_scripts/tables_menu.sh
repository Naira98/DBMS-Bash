#! /usr/bin/bash

export CONNECTED_DB=$1
PS3="${CONNECTED_DB}_db >> "

source ./utils/output_utils.sh
source ./utils/confirm_exit_utils.sh

while true; do
    echo
    echo "================== Tables Menu =================="
    select choice in "Create Table" "List Tables" "Queries on Table" "Alter Table" "Drop Table" "Back To Main Menu" "Exit"
    do
        case $choice in
            "Create Table")
                ./table_scripts/create_table.sh
                ;;
            "List Tables")
                ./table_scripts/list_tables.sh
                ;;
            "Queries on Table")
                ./table_queries_scripts/queries_menu.sh
                ;;
            "Alter Table")
                ./alter_table_scripts/alter_table_menu.sh 
                ;;
            "Drop Table")
                ./table_scripts/drop_table.sh
                ;;
            "Back To Main Menu")
                exit 0
                ;;
            "Exit")
                confirm_exit 1
                ;;
            *)
                print_red "Invalid option. Please try again."
                ;;
        esac
        break
    done
done
