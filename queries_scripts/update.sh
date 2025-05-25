#!/usr/bin/bash
set -e
source ./utils/output_utils.sh
source ./utils/queries_utils.sh
source ./utils/validation_utils.sh

PS3="Choose an option: "

columns=()
types=()
constraints=()

while IFS=: read -r col type cons; do
    columns+=("$col")
    types+=("$type")
    constraints+=("${cons}")
done < "$table_metadata_path"

function ask_for_update_condition {
    query="UPDATE $table_name WHERE condition"
    matched_rows=$(ask_for_condition "all" "update" "$query")
    matched_rows_length=$(awk -F" " '{if ($1 != "") count+=1} END {print count}' <<< "$matched_rows")

    if [[ "$matched_rows_length" -eq 0 ]]; then
        echo_red "Error: There is no matched records to update."
        exit 1
    fi

    matched_ids=$(echo "$matched_rows" | cut -d: -f1 | tr '\n' ':' | sed "s/:$//")

    updated_values=$(printf ':%.0s' $(seq 1 $((${#columns[@]} - 1))))  # ":::"
    selected_values=$(printf '0:%.0s' $(seq 1 $((${#columns[@]} - 1))))
    selected_values="${selected_values}0"    # "0:0:0:0"
    return 0
}

ask_for_update_condition

while true; do
    quote="UPDATE $table_name SET columns"

    echo
    echo "$quote"
    printf '%*s\n' "${#quote}" '' | tr ' ' '-' > /dev/stderr

    options=()
    for ((i = 0; i < "${#columns[@]}"; i++)); do
        update_indicator=$(awk -F: -v idx=$((i+1)) '{ if ($idx != 0) print "*"; else print " "; }' <<< "$selected_values")
        options+=("[$update_indicator] ${columns[$i]}")
    done

    select option in "${options[@]}" "# done"; do
        case $REPLY in
            [1-${#options[@]}])
                is_updated=$(cut -d: -f$REPLY <<< "$selected_values")

                if [[ $is_updated -eq 1 ]]; then
                    updated_values=$(awk -F: -v col_num="$REPLY" '
                    BEGIN {OFS=":"} {$col_num=""; print $0}' <<< "$updated_values")

                    selected_values=$(awk -F: -v col_num="$REPLY" '
                    BEGIN {OFS=":"} {$col_num=0; print $0}' <<< "$selected_values")

                else
                    col_index=$(($REPLY - 1))

                    echo
                    read -rp "${columns[$col_index]}: " new_value

                    unique_constraint=$(cut -d: -f2 <<< "${constraints[$col_index]}")

                    if [[ $unique_constraint = "unique" && $matched_rows_length -gt 1 ]]; then
                        echo_red "Error: There is a unique constraint. you can't update multiple records with the same value."
                        break
                    fi

                    not_null_constraint=$(cut -d: -f3 <<< "${constraints[$col_index]}")
                    validate_data_type "${types[$col_index]}" "$not_null_constraint" "$new_value" || break

                    validate_constraints "${constraints[$col_index]}" "$REPLY" "${table_data_path}" "$new_value" || break

                    updated_values=$(awk -F: -v new_value="$new_value" -v col_num="$REPLY" '
                    BEGIN {OFS=":"} {$col_num=new_value; print $0}' <<< "$updated_values")

                    selected_values=$(awk -F: -v col_num="$REPLY" '
                    BEGIN {OFS=":"} {$col_num=1; print $0}' <<< "$selected_values")
                fi
                ;;

            $((${#options[@]}+1))) # done
                awk -F: -v matched_ids="$matched_ids" -v selected_values="$selected_values" -v updated_values="$updated_values" '
                BEGIN { OFS=":" }
                {
                    split(matched_ids, matched_ids_arr, ":")
                    split(selected_values, selected_values_arr, ":")
                    split(updated_values, updated_values_arr, ":")

                    is_found = "false"

                    for (idx in matched_ids_arr) {
                        matched_id = matched_ids_arr[idx]
                        if (matched_id == $1) {
                            is_found = "true"
                            break
                        }
                    }

                    if (is_found == "false") {
                        print $0
                    } else {
                        for (i in selected_values_arr) {
                            selected_value = selected_values_arr[i]

                            if (selected_value == "1") {
                                $i = updated_values_arr[i]
                            }
                        }
                        print $0
                    }
                }
                ' "$table_data_path" > "${table_data_path}.tmp" && mv "${table_data_path}.tmp" "$table_data_path"

                if [[ "$matched_rows_length" -gt 1 ]]; then
                    echo_green "(+$matched_rows_length) records updated successfully"
                elif [[ "$matched_rows_length" -eq 1 ]]; then
                    echo_green "(+1) record updated successfully"
                fi

                echo
                read -rp $'Do you want to update more records? (y/n): ' confirm

                if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
                    ask_for_update_condition
                else
                    exit 0
                fi
                ;;

            *)
                echo_red "Invalid option. Please try again."
                ;;
        esac
        break
    done
done
