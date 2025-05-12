#! /bin/bash

set -e

table_name=$1
table_data_path=$2
table_metadata_path=$3

source ./utils/select_from_columns_utils.sh
source ./utils/create_table_utils.sh
source ./utils/output_utils.sh

col_name_number="$(select_from_columns "drop" "$table_metadata_path")"
col_name="$(awk -F' ' '{print $1}'  <<< $col_name_number)"
col_num="$(awk -F' ' '{print $2}'  <<< $col_name_number)"

if [[ $col_num = 1 ]]; then
    print_red "Error: Primary key column '$col_name' can't be deleted"
    return 1
fi

sed -i "${col_num}d" "$table_metadata_path"

cut --complement -d: -f"$col_num" "$table_data_path" > "${table_data_path}.tmp" && mv "${table_data_path}.tmp" "$table_data_path"

print_green "Column '$col_name' dropped successfully."