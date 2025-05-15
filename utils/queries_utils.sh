#! /usr/bin/bash

source ./utils/output_utils.sh
source ./utils/select_from_columns_utils.sh

function ask_for_some_columns {
    columns=($(awk -F: '{ print $1 }' "$table_metadata_path"))
    chosen_cols_nums=()

    while true; do
        menu_cols=()

        for i in "${!columns[@]}"; do
            col="${columns[$i]}"
            col_num=$((i + 1))
            if [[ " ${chosen_cols_nums[@]} " == *" $col_num "* ]]; then
                menu_cols+=("[*] $col")
            else
                menu_cols+=("[ ] $col")
            fi
        done

        echo > /dev/stderr
        select option in "${menu_cols[@]}" "# done"; do
            case $REPLY in
                [1-${#menu_cols[@]}])
                    if [[ " ${chosen_cols_nums[@]} " == *" $REPLY "* ]]; then
                        chosen_cols_nums=("${chosen_cols_nums[@]/$REPLY}")
                    else
                        chosen_cols_nums+=("$REPLY")
                    fi
                ;;

                $((${#menu_cols[@]}+1))) # done
                    if (( ${#chosen_cols_nums[@]} < 1 )); then
                        print_red "Error: You must select at least one column."
                    else
                        echo "${chosen_cols_nums[@]}"
                        return 0
                    fi
                ;;

                *)
                    print_red "Invalid option. Please try again."
                ;;
            esac
            break
        done
    done
}




function read_condition {
    col_name=$1
    operator=$2

    echo > /dev/stderr
    read -rp "WHERE "$col_name" "$operator" " value

    echo "$value"
    return 0
}


function get_matched_rows {
    value=$1
    operator=$2
    no_condition=$3

    matched_rows=$(awk -F : -v condition_col_num="$condition_col_num" -v value="$value" -v chosen_col_nums="$chosen_col_nums" -v operator="$operator" -v no_condition="$no_condition" '
    {
        if (no_condition) {
            if (chosen_col_nums == 'all') {
                print $0
            } else {
                split(chosen_col_nums, cols_array, " ")
                result = ""
                for (i in cols_array) {
                    result = result (i == 1 ? "" : ":") $cols_array[i]
                }
                print result
            }   
        } else if (operator == "=") {
            if ( $condition_col_num == value ) {
                if (chosen_col_nums == 'all') {
                    print $0
                } else {
                    split(chosen_col_nums, cols_array, " ")
                    result = ""
                    for (i in cols_array) {
                        result = result (result == "" ? "" : ":") $cols_array[i]
                    }
                    print result
                }                            
            }
        } else if (operator == "!=") {
            if ( $condition_col_num != value ) {
                if (chosen_col_nums == 'all') {
                    print $0
                } else {
                    split(chosen_col_nums, cols_array, " ")
                    result = ""
                    for (i in cols_array) {
                        result = result (result == "" ? "" : ":") $cols_array[i]
                    }
                    print result
                }                            
            }
        } else if (operator == ">") {
            if ( $condition_col_num > value ) {
                if (chosen_col_nums == 'all') {
                    print $0
                } else {
                    split(chosen_col_nums, cols_array, " ")
                    result = ""
                    for (i in cols_array) {
                        result = result (result == "" ? "" : ":") $cols_array[i]
                    }
                    print result
                }                            
            }
        } else if (operator == ">=") {
            if ( $condition_col_num >= value ) {
                if (chosen_col_nums == 'all') {
                    print $0
                } else {
                    split(chosen_col_nums, cols_array, " ")
                    result = ""
                    for (i in cols_array) {
                        result = result (result == "" ? "" : ":") $cols_array[i]
                    }
                    print result
                }                            
            }
        } else if (operator == "<") {
            if ( $condition_col_num < value ) {
                if (chosen_col_nums == 'all') {
                    print $0
                } else {
                    split(chosen_col_nums, cols_array, " ")
                    result = ""
                    for (i in cols_array) {
                        result = result (result == "" ? "" : ":") $cols_array[i]
                    }
                    print result
                }                            
            }
        } else if (operator == "<=") {
            if ( $condition_col_num <= value ) {
                if (chosen_col_nums == 'all') {
                    print $0
                } else {
                    split(chosen_col_nums, cols_array, " ")
                    result = ""
                    for (i in cols_array) {
                        result = result (result == "" ? "" : ":") $cols_array[i]
                    }
                    print result
                }                            
            }
        }
    }' $table_data_path)

    echo "${matched_rows[@]}" 
    return 0
}


function ask_for_condition {
    chosen_col_nums=$1

    query="SELECT col_names FROM $table_name WHERE condition"

    while true; do
        echo > /dev/stderr
        echo "$query" > /dev/stderr
        printf '%*s\n' "${#query}" '' | tr ' ' '-' > /dev/stderr

        select option in "Add condition" "No condition"; do
            case $option in
                "Add condition")
                    read col_name condition_col_num col_data_type col_constraints <<< $(select_from_columns "make condition on" "${table_metadata_path}")


                    if [[ $col_data_type = "integer" ]]; then
                        while true; do
                            echo > /dev/stderr
                            echo "Select comparison arithmetic operator" > /dev/stderr
                            echo "-------------------------------------" > /dev/stderr
                            select operator in "=" "!=" ">" ">=" "<" "<="; do
                                case $REPLY in
                                    [1-6]) # All 6 operators
                                        value=$(read_condition "$col_name" "$operator")

                                        if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
                                            print_red "Invalid input: Value must be a number."
                                            continue
                                        fi

                                        matched_rows=$(get_matched_rows "$value" "$operator" "false")

                                        echo "${matched_rows[@]}"
                                        return 0
                                    ;;
                                    *)
                                        print_red "Invalid option. Please try again."
                                esac
                                break
                            done
                        done
                    else 
                        value=$(read_condition "$col_name" "=")

                        matched_rows=$(get_matched_rows "$value" "=" "false")

                        echo "$matched_rows"
                        return 0
                    fi

                ;;

                "No condition")
                    matched_rows=$(get_matched_rows "" "" "true")

                    echo "$matched_rows" 
                    return 0
                ;;

                *)
                    print_red "Invalid option. Please try again."
                ;;
            esac
            break
        done
    done
}



function get_table_headers {
    col_nums=$1

    if [[ $col_nums = "all" ]]; then
        headers=$(awk -F: '{print $1}' "$table_metadata_path" | paste -sd:)
    else
        headers=$(awk -F: -v col_nums="$col_nums" '
        {
            split(col_nums, cols_array, " ")
            for (i in cols_array) {
                if (NR == cols_array[i]) {
                    print $1
                }
            }
        }' "$table_metadata_path" | paste -sd:)
    fi
    echo "$headers"
}

function print_table {
    headers=$1
    rows=$2

    echo > /dev/stderr
    echo "RAW DATA IN PRINT TABLE" > /dev/stderr
    echo "$headers" > /dev/stderr
    echo "${rows[@]}" > /dev/stderr
    echo > /dev/stderr

    # # Print headers
    # IFS=: read -r -a header_array <<< "$headers"
    # printf '%-20s' "${header_array[@]}"
    # echo > /dev/stderr
    # printf '%0.s-' {1..80}
    # echo > /dev/stderr

    # # Print rows
    # IFS=$'\n' read -r -d '' -a row_array <<< "$rows"
    # for row in "${row_array[@]}"; do
    #     IFS=: read -r -a col_array <<< "$row"
    #     printf '%-20s' "${col_array[@]}"
    #     echo > /dev/stderr
    # done
}