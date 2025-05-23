#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/table_utils.sh
source ./utils/output_utils.sh

read col_name col_num col_data_type col_constraints <<< $(select_from_columns "drop" "${table_metadata_path}")

if [[ $col_num = 1 ]]; then
    echo_red "Error: Primary key column '$col_name' can't be deleted."
    exit 1
fi

sed -i "${col_num}d" "$table_metadata_path"

cut --complement -d: -f"$col_num" "$table_data_path" > "${table_data_path}.tmp" && mv "${table_data_path}.tmp" "$table_data_path"

echo_green "Column '$col_name' dropped successfully."
