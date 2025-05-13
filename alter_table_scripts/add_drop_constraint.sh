#! /bin/bash

set -e

source ./utils/select_from_columns_utils.sh
source ./utils/create_table_utils.sh

table_name=$1
table_data_path=$2
table_metadata_path=$3

col_name_number="$(select_from_columns "add or drop constraints from" "$table_metadata_path")"
col_name="$(awk -F' ' '{print $1}' <<< $col_name_number)"
col_num="$(awk -F' ' '{print $2}' <<< $col_name_number)"

read col_data_type col_constraints <<< $(awk -F: -v col_name=$col_name '
   { if ( $1 == col_name ) {
        data_type = $2
        constraints = ""
        for (i=3; i<=NF; i++) constraints = constraints (i > 3 ? ":" : "") $i
        print data_type, constraints
    }}
' $table_metadata_path)

new_constraints=$(ask_for_all_constraints "$col_name" "$col_data_type" "$col_constraints" "$table_data_path" "$col_num")

awk -F: -v col_num="$col_num" -v new_constraints="$new_constraints" '
BEGIN { OFS = ":" }
{
    if (NR == col_num) {
        $3 = new_constraints
        $4 = ""
        for (i = 5; i <= NF; i++) $i = ""
        sub(/:::$/, "")  # Remove trailing colon
    }
    print $0
}' "$table_metadata_path" > "${table_metadata_path}.tmp" && mv "${table_metadata_path}.tmp" "$table_metadata_path"

print_green "Column '$col_name' constraints altered successfully."