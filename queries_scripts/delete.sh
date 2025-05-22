#!/usr/bin/bash
set -e
source ./utils/queries_utils.sh

PS3="Choose an option: "

query="DELETE FROM $table_name WHERE condition"

while true; do
    lines_count_before_deletion=$(wc -l < "$table_data_path")

    ask_for_condition "" "delete" "$query"

    lines_count_after_deletion=$(wc -l < "$table_data_path")

    deleted_count=$(( "$lines_count_before_deletion" - "$lines_count_after_deletion" ))
 
    if [[ $deleted_count -eq 0 ]]; then
        echo_green "No matched records to delete."
    elif [[ "$deleted_count" -gt 1 ]]; then
        echo_green "(-$deleted_count) records deleted successfully."
    elif [[ "$deleted_count" -eq 1 ]]; then
        echo_green "(-1) record deleted successfully."
    fi

    echo
    read -rp $'Do you want to delete more values? (y/n): ' confirm

    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
        row=""
        continue
    fi
    break
done
