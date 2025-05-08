#! /bin/bash

connected_db=$1
PS3="${connected_db}_db >> "

echo
echo "================== Tables Menu =================="
select choice in "Create Table" "List Tables" "Queries on Table" "Back To Main Menu" "Exit"
do
    case $choice in
        "Create Table")
            echo "Creating Table..."
            ;;
        "List Tables")
            echo "Listing Tables..."
            ;;
        "Queries on Table")
            echo "Quering on Table..."
            ;;
        "Back To Main Menu")
            echo "Back To main menu..."
            break
            ;;
        "Exit")
            echo "Exiting..."
            # exit
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
