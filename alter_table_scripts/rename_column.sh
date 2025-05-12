#! /bin/bash

set -e

table_name=$1
table_metadata_path=$2

source ./utils/select_from_columns_utils.sh
source ./utils/create_table_utils.sh
source ./utils/output_utils.sh

col_name_number="$(select_from_columns "rename" "$table_metadata_path")"
col_num="$(awk -F' ' '{print $1}'  <<< $col_name_number)"
col_name="$(awk -F' ' '{print $2}'  <<< $col_name_number)"

new_col_name=$(ask_for_col_name "$table_metadata_path" "Enter new name for col '$col_name': " "-1")

sed -i "s/^$col_name/$new_col_name/" "$table_metadata_path"

print_green "Column '$col_name' renamed to '$new_col_name' successfully."