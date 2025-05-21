#! /usr/bin/bash

source ./utils/queries_utils.sh
source ./utils/select_from_columns_utils.sh

set -e

PS3="Choose an option: "

query="DELETE FROM $table_name WHERE condition"

deleted_count=$(ask_for_condition "" "delete" "$query")   

if [[ $deleted_count -eq 0 ]]; then
    print_green "No matched rows to delete"
elif [[ "$deleted_count" -gt 1 ]]; then
    print_green "(-$deleted_count) rows deleted successfully"
elif [[ "$deleted_count" -eq 1 ]]; then
    print_green "(-1) row deleted successfully"
fi