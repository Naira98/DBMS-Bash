#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/table_utils.sh
source ./utils/output_utils.sh

read col_name col_num col_data_type col_constraints <<< $(select_from_columns "rename" "${table_metadata_path}")

new_col_name=$(ask_for_col_name "$table_metadata_path" "Enter new name for col '$col_name': " "-1")

sed -i "s/^$col_name/$new_col_name/" "$table_metadata_path"

echo_green "Column '$col_name' renamed to '$new_col_name' successfully."
