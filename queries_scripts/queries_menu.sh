#!/usr/bin/bash
source ./utils/output_utils.sh
source ./utils/selection_utils.sh

export table_name=$(select_from_tables "query on")
export table_data_path="./$WORK_SPACE/$CONNECTED_DB/$table_name"
export table_metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$table_name"

if [[ -z "$table_name" ]]; then
    exit 1
fi

PS3="${table_name}_table >> "

while true; do
    echo
    echo "============== Queries Menu $table_name =============="
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
