#! /bin/bash

PS3="Choose an option >> "

echo "  ===========================================================  "
echo " || Welcome to the Our Database Management System (DBMS) 👋 || "
echo "  ===========================================================  "

select choice in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"
do
    case $choice in
        "Create Database")
            source $SCRIPT_DIR/create_db.sh
            ;;
        "List Database")
            source $SCRIPT_DIR/list_db.sh
            ;;
        "Connect Database")
            echo "Connecting to Database..."
            ;;
        "Drop Database")
            source $SCRIPT_DIR/drop_db.sh
            ;;
        "Exit")
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
