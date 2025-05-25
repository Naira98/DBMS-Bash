#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/table_utils.sh
source ./utils/output_utils.sh

read col_name col_num col_data_type col_constraints <<< $(select_from_columns "drop" "${TABLE_METADATA_PATH}")

if [[ $col_num = 1 ]]; then
    echo_red "Error: Primary key column '$col_name' can't be deleted."
    exit 1
fi

sed -i "${col_num}d" "$TABLE_METADATA_PATH"

cut --complement -d: -f"$col_num" "$TABLE_DATA_PATH" > "${TABLE_DATA_PATH}.tmp" && mv "${TABLE_DATA_PATH}.tmp" "$TABLE_DATA_PATH"

echo_green "Column '$col_name' dropped successfully."
