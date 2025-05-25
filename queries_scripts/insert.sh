#!/usr/bin/bash
set -e
source ./utils/queries_utils.sh
source ./utils/validation_utils.sh

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
    quote="INSERT INTO "$table_name" VALUES"
    echo "$quote"
    printf '%*s\n' "${#quote}" '' | tr ' ' '-' > /dev/stderr

    for ((i = 0; i < ${#columns[@]}; i++)); do
        default_value_or_auto_increment=$(awk -F: '{if ($4 != "") print $4}' <<< "${constraints[$i]}")

        while true; do
            if [[ -z "$default_value_or_auto_increment" ]]; then
                read -rp "${columns[$i]}: " input
            else
                read -rp "${columns[$i]} ($default_value_or_auto_increment): " input

                if [[ -z "$input" ]]; then
                    # PK with auto increment
                    if [[ $i -eq 0 && "$default_value_or_auto_increment" = "auto_increment" ]]; then
                        input=$(auto_increment_pk "$table_data_path")
                    else
                    # Normal column with default value
                        input="$default_value_or_auto_increment"
                    fi
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

    echo_green "(+1) record inserted successfully."
    echo "$row" >> "$table_data_path"

    echo
    read -rp $'Do you want to insert more records? (y/n): ' confirm

    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
        row=""
        continue
    fi

    break
done
