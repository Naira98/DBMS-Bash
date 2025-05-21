#! /usr/bin/bash

source ./utils/queries_utils.sh
source ./utils/select_from_columns_utils.sh

set -e

PS3="Choose an option: "

query="DELETE FROM $table_name WHERE condition"

while true; do
    lines_count_before_deletion=$(wc -l < "$table_data_path")

    ask_for_condition "" "delete" "$query"

    lines_count_after_deletion=$(wc -l < "$table_data_path")

    deleted_count=$(( "$lines_count_before_deletion" - "$lines_count_after_deletion" ))
 
    if [[ $deleted_count -eq 0 ]]; then
        print_green "No matched rows to delete"
    elif [[ "$deleted_count" -gt 1 ]]; then
        print_green "(-$deleted_count) rows deleted successfully"
    elif [[ "$deleted_count" -eq 1 ]]; then
        print_green "(-1) row deleted successfully"
    fi

    echo
    read -rp $'Do you want to delete more values? (y/n): ' confirm

    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
        row=""
        continue
    fi
    break
done