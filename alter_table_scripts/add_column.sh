#! /bin/bash

set -e

source ./utils/create_table_utils.sh
source ./utils/alter_table_utils.sh
source ./utils/output_utils.sh

table_name=$1
table_data_path=$2
table_metadata_path=$3

col_name=$(ask_for_col_name "$table_metadata_path" "Enter the name of new column: " "-1")

data_type=$(ask_for_data_type "$col_name")
    
constraints=$(ask_for_unique_and_default_constraints $col_name $data_type)

col_metadata="$col_name":"$data_type":"$constraints"

sed -i 's/$/:/' "$table_data_path"

echo "$col_metadata" >> "$table_metadata_path"


print_green "Column '$col_name' added to '$table_name' table successfully."