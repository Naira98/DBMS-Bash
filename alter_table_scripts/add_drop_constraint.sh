#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/table_utils.sh

read col_name col_num col_data_type col_constraints <<< "$(select_from_columns "add or drop constraints from" "${table_metadata_path}")"

new_constraints=$(ask_for_all_constraints "$col_name" "$col_data_type" "$col_constraints" "$table_data_path" "$col_num")

awk -F: -v col_num="$col_num" -v new_constraints="$new_constraints" '
BEGIN { OFS = ":" }
{
    if (NR == col_num) {
        $3 = new_constraints
        for (i = 4; i <= NF; i++) $i = ""
        print $1, $2, $3
    } else {
        print $0
    }
}
' "$table_metadata_path" > "${table_metadata_path}.tmp" && mv "${table_metadata_path}.tmp" "$table_metadata_path"

echo_green "Column '$col_name' constraints altered successfully."
