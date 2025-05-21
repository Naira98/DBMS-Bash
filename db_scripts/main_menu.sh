#!/usr/bin/bash
source ./utils/output_utils.sh
source ./utils/confirmation_utils.sh

PS3="Choose an option >> "

echo "╔═════════════════════════════════════════════════════════╗"
echo "║ Welcome to the Our Database Management System (DBMS) 👋 ║ "
echo "╚═════════════════════════════════════════════════════════╝ "

while true; do
    echo
    echo "================== Main Menu =================="
    select choice in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"
    do
        case $choice in
            "Create Database")
                ./db_scripts/create_db.sh
                ;;
            "List Database")
                ./db_scripts/list_db.sh
                ;;
            "Connect Database")
                db_name=$(./db_scripts/connect_db.sh)
                return_connect_db_status=$?

                if [[ $return_connect_db_status == 0 ]]; then
                    # Handling exit program from tables menu
                    ./table_scripts/tables_menu.sh "$db_name" || exit 0
                fi
                ;;
            "Drop Database")
                ./db_scripts/drop_db.sh
                ;;
            "Exit")
                confirm_exit 0
                ;;
            *)
                echo_red "Invalid option. Please try again."
                ;;
        esac
        
        # break main_menu select loop
        break
    done
done
