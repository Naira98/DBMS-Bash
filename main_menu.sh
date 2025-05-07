#! /bin/bash

PS3="Choose an option >> "

echo "  ===========================================================  "
echo " || Welcome to the Our Database Management System (DBMS) 👋 || "
echo "  ===========================================================  "

select choice in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"
do
    case $choice in
        "Create Database")
            echo "Creating Database..."
            ;;
        "List Database")
            echo "Listing Databases..."
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
