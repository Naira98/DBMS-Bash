#! /bin/bash

source ./utils/output_utils.sh
source ./utils/select_from_tables_utils.sh

TABLE_NAME=$(select_from_tables)
PS3="${TABLE_NAME}_table >> "

while true; do
    echo
    echo "================== Queries Menu =================="
    select choice in "Select" "Insert" "Update" "Delete" "Back To Tables Menu"
    do
        case $choice in
            "Select")
                ./table_queries_scripts/select.sh
                ;;
            "Insert")
                ./table_queries_scripts/insert.sh
                ;;
            "Update")
                ./table_queries_scripts/update.sh 
                ;;
            "Delete")
                ./table_queries_scripts/delete.sh 
                ;;
            "Back To Tables Menu")
                exit 0
                ;;
            *)
                print_red "Invalid option. Please try again."
                ;;
        esac
        break
    done
done
