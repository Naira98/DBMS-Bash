#!/usr/bin/bash
source ./utils/output_utils.sh
source ./utils/selection_utils.sh

export TABLE_NAME=$(select_from_tables "query on")
export TABLE_DATA_PATH="./$WORK_SPACE/$CONNECTED_DB/$TABLE_NAME"
export TABLE_METADATA_PATH="./$WORK_SPACE/$CONNECTED_DB/.$TABLE_NAME"

if [[ -z "$TABLE_NAME" || ! -f "$TABLE_DATA_PATH" || ! -f "$TABLE_METADATA_PATH" ]]; then
    echo_red "Error: Table files for '$TABLE_NAME' are missing."
    echo_red "Exiting..."
    exit 1
fi

PS3="${TABLE_NAME}_table >> "

while true; do
    echo
    echo "═══════════ Queries Menu $TABLE_NAME ═══════════"
    select choice in "Select" "Insert" "Update" "Delete" "Back To Tables Menu"
    do
        case $choice in
            "Select")
                ./queries_scripts/select.sh
                ;;
            "Insert")
                ./queries_scripts/insert.sh
                ;;
            "Update")
                ./queries_scripts/update.sh 
                ;;
            "Delete")
                ./queries_scripts/delete.sh 
                ;;
            "Back To Tables Menu")
                exit 0
                ;;
            *)
                echo_red "Invalid option. Please try again."
                ;;
        esac
        break
    done
done
