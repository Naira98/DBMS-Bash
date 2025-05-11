#! /bin/bash

shopt -s extglob
set -e

source ./utils/create_table_utils.sh
source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

read -rp "Enter the name of the table you want to create: " table_name

# Input Validation
table_name=$(validate_name "$table_name" "Table") 

# Existence Validation
table_path="./$WORK_SPACE/$CONNECTED_DB/$table_name"
table_metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$table_name"
error_message="Table '$table_name' already exists."
validate_file_does_not_exist "$table_path" "$error_message"

read -rp "Enter the number of the columns : " cols_num

if [[ ! $cols_num =~ ^[0-9]+$ ]]; then
    print_red 'Error: Number of columns must be a number'
    exit 1
fi
if [[ $cols_num =~ ^0+$ ]]; then
    print_red 'Error: Number of columns must be a positive number'
    exit 1
fi

touch "$table_path"
touch "$table_metadata_path"

for (( i = 1; i <= "$cols_num"; i++ )); do

    col_name=$(ask_for_col_name "$table_metadata_path" "$i")
    data_type=$(ask_for_data_type "$col_name")

    meta_row="$col_name":"$data_type":
    if (( $i == 1 )); then
        meta_row="$meta_row"pk:unique:not_null:
        echo $meta_row
    else
        constraints=$(ask_for_chosen_constraints $col_name $data_type)
        meta_row="$meta_row""$constraints"
    fi


    echo $meta_row >> $table_metadata_path

done





#Create the table directory
# print_green "Table '$table_name' created successfully."
