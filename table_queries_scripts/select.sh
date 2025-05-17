#! /usr/bin/bash

source ./utils/queries_utils.sh

set -e

PS3="Choose an option: "

query="SELECT col_names FROM $table_name WHERE condition"

while true; do
    echo
    echo "SELECT col_name"
    echo "---------------"
    select cols in "All Columns" "Some Columns"; do
        case $cols in
            "All Columns")
                headers=$(get_table_headers "all")
                matched_rows=$(ask_for_condition "all" "select" "$query")
                
                content=$(echo -e "$headers\n$matched_rows")

                print_table "$content"
                exit 0
                ;;

            "Some Columns")
                chosen_cols_nums=$(ask_for_some_columns)
                headers=$(get_table_headers "${chosen_cols_nums}")
                matched_rows=$(ask_for_condition "${chosen_cols_nums}" "select" "$query")


                content=$(echo -e "$headers\n$matched_rows")

                print_table "$content"
                exit 0
            
                ;;
            *)
                print_red "Invalid option. Please try again."
                ;;
        esac
        break
    done
done
