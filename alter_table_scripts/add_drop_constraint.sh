#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/table_utils.sh

read col_name col_num col_data_type col_constraints <<< "$(select_from_columns "add or drop constraints from" "${TABLE_METADATA_PATH}")"

new_constraints=$(ask_for_all_constraints "$col_name" "$col_data_type" "$col_constraints" "$TABLE_DATA_PATH" "$col_num")

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
' "$TABLE_METADATA_PATH" > "${TABLE_METADATA_PATH}.tmp" && mv "${TABLE_METADATA_PATH}.tmp" "$TABLE_METADATA_PATH"

echo_green "Column '$col_name' constraints altered successfully."
