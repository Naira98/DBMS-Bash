#!/usr/bin/bash
set -e
source ./utils/queries_utils.sh

PS3="Choose an option: "

query="DELETE FROM $TABLE_NAME WHERE condition"

while true; do
    lines_count_before_deletion=$(wc -l < "$TABLE_DATA_PATH")

    ask_for_condition "" "delete" "$query"

    lines_count_after_deletion=$(wc -l < "$TABLE_DATA_PATH")

    deleted_count=$(( "$lines_count_before_deletion" - "$lines_count_after_deletion" ))
 
    if [[ $deleted_count -eq 0 ]]; then
        echo_green "No matched records to delete."
    elif [[ "$deleted_count" -gt 1 ]]; then
        echo_green "(-$deleted_count) records deleted successfully."
    elif [[ "$deleted_count" -eq 1 ]]; then
        echo_green "(-1) record deleted successfully."
    fi

    echo
    read -rp $'Do you want to delete more records? (y/n): ' confirm

    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
        row=""
        continue
    fi
    break
done
