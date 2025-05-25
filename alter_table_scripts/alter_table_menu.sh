#!/usr/bin/bash
source ./utils/selection_utils.sh
source ./utils/output_utils.sh

export TABLE_NAME=$(select_from_tables "alter")
export TABLE_DATA_PATH="./$WORK_SPACE/$CONNECTED_DB/$TABLE_NAME"
export TABLE_METADATA_PATH="./$WORK_SPACE/$CONNECTED_DB/.$TABLE_NAME"

if [[ -z "$TABLE_NAME" || ! -f "$TABLE_DATA_PATH" || ! -f "$TABLE_METADATA_PATH" ]]; then
    echo_red "Error: Table files for '$TABLE_NAME' are missing."
    echo_red "Exiting..."
    exit 1
fi

PS3="Choose an option >> "

while true; do
    echo
    echo "═══════════ Alter Table $TABLE_NAME ═══════════"
    select option in "Rename Table" "Add Column" "Rename Column" "Drop Column" "Add Or Drop Constraint" "Back to Tables Menu"; do
        case $option in
            "Rename Table")
                ./alter_table_scripts/rename_table.sh
                exit 0
                ;;
            "Add Column")
                ./alter_table_scripts/add_column.sh
                ;;
            "Rename Column")
                ./alter_table_scripts/rename_column.sh
                ;;
            "Drop Column")
                ./alter_table_scripts/drop_column.sh
                ;;
            "Add Or Drop Constraint")
                ./alter_table_scripts/add_drop_constraint.sh
                ;;
            "Back to Tables Menu")
                exit 0
                ;;
            "*")
                echo_red "Invalid option. Please try again."
            ;;
        esac
        break
    done
done
