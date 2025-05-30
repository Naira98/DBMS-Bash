#!/usr/bin/bash
set -e
source ./utils/queries_utils.sh

PS3="Choose an option: "

query="SELECT col_names FROM $TABLE_NAME WHERE condition"

while true; do
    echo
    echo "SELECT col_name"
    echo "---------------"
    select cols in "All Columns" "Some Columns"; do
        case $cols in
            "All Columns")
                matched_rows=$(ask_for_condition "all" "select" "$query")

                matched_rows_length=$(awk -F" " '{if ($1 != "") count+=1} END {print count}' <<< "$matched_rows")

                if [[ "$matched_rows_length" -eq 0 ]]; then
                    echo_red "Error: There is no matched records to select."
                    exit 1
                fi
                
                headers=$(get_table_headers "all")
                content=$(echo -e "$headers\n$matched_rows")

                print_table "$content"

                echo
                read -rp $'Do you want to select more records? (y/n): ' confirm

                if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
                    row=""
                    break
                fi

                exit 0
                ;;

            "Some Columns")
                chosen_cols_nums=$(ask_for_some_columns)

                matched_rows=$(ask_for_condition "${chosen_cols_nums}" "select" "$query")

                matched_rows_length=$(awk -F" " '{if ($1 != "") count+=1} END {print count}' <<< "$matched_rows")

                if [[ "$matched_rows_length" -eq 0 ]]; then
                    echo_red "Error: There is no matched records to select."
                    exit 1
                fi

                headers=$(get_table_headers "${chosen_cols_nums}")
                content=$(echo -e "$headers\n$matched_rows")

                print_table "$content"

                echo
                read -rp $'Do you want to select more records? (y/n): ' confirm

                if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
                    row=""
                    break
                fi

                exit 0
                ;;
            *)
                echo_red "Invalid option. Please try again."
                ;;
        esac
        break
    done
done
