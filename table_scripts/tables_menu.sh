#! /bin/bash

export CONNECTED_DB=$1
PS3="${CONNECTED_DB}_db >> "

while true; do
    echo "================== Tables Menu =================="
    select choice in "Create Table" "List Tables" "Queries on Table" "Drop Table" "Back To Main Menu" "Exit"
    do
        case $choice in
            "Create Table")
                ./table_scripts/create_table.sh
                ;;
            "List Tables")
                ./table_scripts/list_tables.sh
                ;;
            "Queries on Table")
                echo "Quering on Table..."
                ;;
            "Drop Table")
                ./table_scripts/drop_table.sh
                ;;
            "Back To Main Menu")
                exit 0
                ;;
            "Exit")
                echo "Exiting..."
                exit 1
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
        break
    done
done
