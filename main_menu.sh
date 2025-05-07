#! /bin/bash

PS3="Choose an option >> "

echo "  ===========================================================  "
echo " || Welcome to the Our Database Management System (DBMS) 👋 || "
echo "  ===========================================================  "

select choice in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"
do
    case $choice in
        "Create Database")
            source ./create_db.sh
            ;;
        "List Database")
            source ./list_db.sh
            ;;
        "Connect Database")
            echo "Connecting to Database..."
            ;;
        "Drop Database")
            echo "Dropping Database..."
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
