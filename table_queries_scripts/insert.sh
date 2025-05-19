#! /usr/bin/bash

set -e

source ./utils/validate_data_type_utils.sh
source ./utils/validate_constraints_utils.sh

columns=()
types=()
constraints=()

while IFS=: read -r col type cons; do
    columns+=("$col")
    types+=("$type")
    constraints+=("${cons}")
done < "$table_metadata_path"

row=""

while true; do
    echo
    quote="Insert values for '"$table_name"' table"
    echo "$quote"
    printf '%*s\n' "${#quote}" '' | tr ' ' '-' > /dev/stderr

    for ((i = 0; i < ${#columns[@]}; i++)); do
        default_value=$(awk -F: '{if ($4 != "") print $4}' <<< "${constraints[$i]}")

        while true; do
            if [[ -z "$default_value" ]]; then
                read -rp "${columns[$i]}: " input
            else
                read -rp "${columns[$i]} ($default_value): " input

                if [[ -z "$input" ]]; then
                    input="$default_value"
                fi
            fi

            not_null_constraint=$(cut -d: -f3 <<< "${constraints[$i]}")
            validate_data_type "${types[$i]}" "$not_null_constraint" "$input" || continue

            validate_constraints "${constraints[$i]}" "$(($i+1))"  "${table_data_path}" "$input" || continue


            if [[ $i -eq $((${#columns[@]} - 1)) ]]; then
                row+="$input"
            else
                row+="$input:"
            fi

            break
        done
    done

    print_green "(+1) Row inserted successfully"
    echo "$row" >> "$table_data_path"

    read -rp $'Do you want to insert more values (y/n)? ' confirm

    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
        continue
    fi

    break
done


# TODO pk auto increment