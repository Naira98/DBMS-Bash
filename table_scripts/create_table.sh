#! /usr/bin/bash

shopt -s extglob
set -e

source ./utils/create_table_utils.sh
source ./utils/output_utils.sh

while true; do

    read table_name table_path table_metadata_path <<< $(ask_for_table_name)

   cols_num=$(ask_for_number_of_columns)

    touch "$table_path"
    touch "$table_metadata_path"

    for (( i = 1; i <= "$cols_num"; i++ )); do

        col_name=$(ask_for_col_name "$table_metadata_path" "Enter name of column $i: " "$i")

        data_type=$(ask_for_data_type "$col_name")

        col_metadata="$col_name":"$data_type":
        
        if (( $i == 1 )); then
            col_metadata="$col_metadata"pk:unique:not_null:
        else
            constraints=$(ask_for_all_constraints $col_name $data_type "" "" "")
            
            col_metadata="$col_metadata""$constraints"
        fi

        echo "$col_metadata" >> "$table_metadata_path"

    done

    print_green "Table '$table_name' created successfully."
    break
done