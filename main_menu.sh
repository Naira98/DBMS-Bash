#! /bin/bash

source ./output_utils.sh

PS3="Choose an option >> "

echo "  ===========================================================  "
echo " || Welcome to the Our Database Management System (DBMS) 👋 || "
echo "  ===========================================================  "

while true; do
    echo
    echo "================== Main Menu =================="
    select choice in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"
    do
        case $choice in
            "Create Database")
                source $SCRIPT_DIR/create_db.sh
                clear_after_1.5_sec
                ;;
            "List Database")
                source $SCRIPT_DIR/list_db.sh
                ;;
            "Connect Database")
                echo "Connecting to Database..."
                clear_after_1.5_sec
                ;;
            "Drop Database")
                source $SCRIPT_DIR/drop_db.sh
                clear_after_1.5_sec
                ;;
            "Exit")
                echo "Exiting..."
                exit
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
        
        # break select menu loop
        break
    done
done
