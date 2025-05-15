#! /bin/bash

set -e

source ./utils/select_from_columns_utils.sh
source ./utils/create_table_utils.sh

read col_name col_num col_data_type col_constraints <<< "$(select_from_columns "add or drop constraints from" "${table_metadata_path}")"

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