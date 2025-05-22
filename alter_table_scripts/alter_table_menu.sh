#!/usr/bin/bash
source ./utils/selection_utils.sh
source ./utils/output_utils.sh

export table_name=$(select_from_tables "alter")
export table_data_path="./$WORK_SPACE/$CONNECTED_DB/$table_name"
export table_metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$table_name"

if [[ -z "$table_name" ]]; then
    exit 1
fi

PS3="Choose an option >> "

while true; do
    echo
    echo "═══════════ Alter Table $table_name ═══════════"
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
