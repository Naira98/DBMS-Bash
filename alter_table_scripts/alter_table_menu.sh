#! /bin/bash

source ./utils/select_from_tables_utils.sh

table_name=$(select_from_tables "alter")
table_data_path=./$WORK_SPACE/$CONNECTED_DB/$table_name
table_metadata_path=./$WORK_SPACE/$CONNECTED_DB/.$table_name

PS3="Choose an option >> "

while true; do
    echo "============== Alter Table $table_name =============="
    select option in "Rename Table" "Add Column" "Rename Column" "Drop Column" "Add Or Drop Constraint" "Back to Tables Menu"; do
        case $option in
            "Rename Table")
            ./alter_table_scripts/rename_table.sh $table_name $table_data_path $table_metadata_path
            ;;
            "Add Column")
            ./alter_table_scripts/add_column.sh $table_name $table_data_path $table_metadata_path
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
        esac
        break
    done
done