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
                ./create_db.sh
                clear_after_1.5_sec
                ;;
            "List Database")
                ./list_db.sh
                sleep 1.5
                ;;
            "Connect Database")
                ./connect_db.sh
                clear_after_1.5_sec
                ;;
            "Drop Database")
                ./drop_db.sh
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
