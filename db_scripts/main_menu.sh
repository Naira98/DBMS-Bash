#! /bin/bash

source ./utils/output_utils.sh

PS3="Choose an option >> "

echo "  ===========================================================  "
echo " || Welcome to the Our Database Management System (DBMS) 👋 || "
echo "  ===========================================================  "
echo

while true; do
    echo "================== Main Menu =================="
    select choice in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"
    do
        case $choice in
            "Create Database")
                ./db_scripts/create_db.sh
                # clear_after_1.5_sec
                ;;
            "List Database")
                ./db_scripts/list_db.sh
                # sleep 1
                ;;
            "Connect Database")
                db_name=$(./db_scripts/connect_db.sh)
                return_connect_db_status=$?

                # clear_after_1.5_sec

                if [[ $return_connect_db_status == 0 ]]; then
                    # Handling exit program from tables menu
                    ./table_scripts/tables_menu.sh "$db_name" || exit 0

                    # Exit with status 1
                    # set -e
                    # ./table_scripts/tables_menu.sh "$db_name"
                    # set +e
                fi
                ;;
            "Drop Database")
                ./db_scripts/drop_db.sh
                # clear_after_1.5_sec
                ;;
            "Exit")
                echo "Exiting..."
                exit
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
        
        # break main_menu select loop
        break
    done
done
