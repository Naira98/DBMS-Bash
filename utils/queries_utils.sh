#! /usr/bin/bash

source ./utils/output_utils.sh
source ./utils/select_from_columns_utils.sh

function ask_for_some_columns {
    local columns=($(awk -F: '{ print $1 }' "$table_metadata_path"))
    local chosen_column_nums=()

    while true; do
        local menu_cols=()

        for i in "${!columns[@]}"; do
            local col="${columns[$i]}"
            local col_num=$((i + 1))
            if [[ " ${chosen_column_nums[@]} " == *" $col_num "* ]]; then
                menu_cols+=("[*] $col")
            else
                menu_cols+=("[ ] $col")
            fi
        done

        echo > /dev/stderr
        echo "SELECT col_names" > /dev/stderr
        echo "----------------" > /dev/stderr
        select option in "${menu_cols[@]}" "# done"; do
            case $REPLY in
                [1-${#menu_cols[@]}])
                    if [[ " ${chosen_column_nums[@]} " == *" $REPLY "* ]]; then
                        local chosen_column_nums=("${chosen_column_nums[@]/$REPLY}")
                        # Remove empty elements caused by the above operation
                        chosen_column_nums=(${chosen_column_nums[@]})
                    else
                        local chosen_column_nums+=("$REPLY")
                    fi
                ;;

                $((${#menu_cols[@]}+1))) # done
                    if (( ${#chosen_column_nums[@]} < 1 )); then
                        print_red "Error: You must select at least one column."
                    else
                        echo "${chosen_column_nums[@]}"
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
    local col_name=$1
    local operator=$2

    echo > /dev/stderr
    read -rp "WHERE "$col_name" "$operator" " value

    echo "$value"
    return 0
}


function get_matched_rows {
    local value=$1
    local operator=$2
    local no_condition=$3

    local matched_rows=$(awk -F : -v condition_col_num="$condition_col_num" -v value="$value" -v chosen_col_nums="$chosen_col_nums" -v operator="$operator" -v no_condition="$no_condition" '
    {
        if (no_condition == "true") {
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

function delete_matched_rows {
    local value=$1
    local operator=$2


    awk -F : -v condition_col_num="$condition_col_num" -v value="$value" -v operator="$operator" '
    {
        to_delete=0
        if (operator == "=" && $condition_col_num == value) to_delete=1
        else if (operator == "!=" && $condition_col_num != value) to_delete=1
        else if (operator == ">" && $condition_col_num > value) to_delete=1
        else if (operator == ">=" && $condition_col_num >= value) to_delete=1
        else if (operator == "<" && $condition_col_num < value) to_delete=1
        else if (operator == "<=" && $condition_col_num <= value) to_delete=1

        if (! to_delete) {
            print $0
        }
    }
    ' "$table_data_path" > "${table_data_path}.tmp" && mv "${table_data_path}.tmp" "$table_data_path"

    return 0
}


function ask_for_condition {
    local chosen_col_nums=$1
    local reason=$2
    local query=$3

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
                            select operator in "=" "!=" ">" ">=" "<" "<=" "IS NULL" "IS NOT NULL"; do
                                case $REPLY in
                                    [1-8]) # All 8 operators

                                        if [[ "$operator" = "IS NULL" || "$operator" = "IS NOT NULL" ]]; then
                                            value=""
                                            if [[ "$operator" = "IS NULL" ]]; then
                                                operator="="
                                            else
                                                operator="!="
                                            fi

                                        else
                                            local value=$(read_condition "$col_name" "$operator")

                                            if [[ $operator = ">" || $operator = ">=" || $operator = "<" || $operator = "<=" ]]; then
                                                if [[ -z "$value" ]]; then
                                                    print_red "Invalid input: Value with this operator can't be empty."
                                                    break
                                                fi
                                            fi

                                            if ! [[ -z "$value" || "$value" =~ ^-?[0-9]+$ ]]; then
                                                print_red "Invalid input: Value must be a number."
                                                break
                                            fi
                                        fi

                                        if [[ "$reason" = "delete" ]]; then
                                            deleted_count=$(delete_matched_rows "$value" "$operator")
                                            echo "$deleted_count"
                                            return 0
                                        fi

                                        local matched_rows=$(get_matched_rows "$value" "$operator" "false")

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
                        while true; do
                            echo > /dev/stderr
                            echo "Select comparison operator" > /dev/stderr
                            echo "--------------------------" > /dev/stderr
                            select operator in "=" "!=" "IS NULL" "IS NOT NULL"; do
                                case $REPLY in
                                    [1-4])
                                        if [[ "$operator" = "IS NULL" || "$operator" = "IS NOT NULL" ]]; then
                                            value=""
                                            if [[ "$operator" = "IS NULL" ]]; then
                                                operator="="
                                            else
                                                operator="!="
                                            fi

                                        else
                                            local value=$(read_condition "$col_name" "$operator")
                                        fi

                                        if [[ "$reason" = "delete" ]]; then
                                            deleted_count=$(delete_matched_rows "$value" "$operator")
                                            echo "$deleted_count"
                                            return 0
                                        fi

                                        local matched_rows=$(get_matched_rows "$value" "$operator" "false")

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
                    fi

                ;;

                "No condition")
                    if [[ "$reason" == "delete" ]]; then
                        sed -i '1,$d' "$table_data_path"
                        return 0
                    fi

                    local matched_rows=$(get_matched_rows "" "" "true")

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
    local col_nums=$1

    if [[ $col_nums = "all" ]]; then
        local headers=$(awk -F: 'BEGIN {ORS=":"} {print $1}' "$table_metadata_path" | sed 's/:$//')
    else
        local headers=$(awk -F: -v col_nums="$col_nums" '
        BEGIN {ORS=":"} {
            split(col_nums, cols_array, " ")
            for (i in cols_array) {
                if (NR == cols_array[i]) {
                    print $1
                }
            }
        }' "$table_metadata_path" | sed 's/\:$//')
    fi
    echo "$headers"
}

function print_horizontal_separator() {
    local vertical_position="$1"
    local columns_lengths=(${@:2})

    local box_left_var="BOX_"$vertical_position"_LEFT"
    local box_middle_var="BOX_"$vertical_position"_MIDDLE"
    local box_right_var="BOX_"$vertical_position"_RIGHT"

    # Dynamic Variable Name
    local box_left=${!box_left_var}
    local box_middle=${!box_middle_var}
    local box_right=${!box_right_var}

    for ((column = 0; column < ${#columns_lengths[@]}; column++)); do
        if [[ $column == 0 ]]; then
            echo -n $box_left
        else
            echo -n $box_middle
        fi

        print_horizontal_line $vertical_position $((${columns_lengths[$column]} + 4)) #extra 4 spaces
    done

    echo $box_right
}

function print_horizontal_line() {
    local vertical_position="$1"
    local width="$2"

    for ((i = 0; i < $width; i++)); do
        if [[ $vertical_position = "MIDDLE" ]]; then
            echo -n $BOX_HORIZONTAL
        else
            echo -n $BOX_DOUBLE_HORIZONTAL
        fi
    done
}

function print_row() {
    local row="$1"
    local columns_lengths=(${@:2})

    for ((column = 0; column < ${#columns_lengths[@]}; column++)); do
        local cell_table_content=$(echo -n $row | cut -d : -f $(($column + 1)))

        if [[ -z "$cell_table_content" ]]; then
            cell_table_content="[null]"
        fi

        if [[ $column -eq 0 ]]; then
            prefix=$BOX_DOUBLE_VERTICAL
        else
            prefix=$BOX_VERTICAL
        fi

        printf "$prefix %-$(( ${columns_lengths[$column]} + 2 ))s " "$cell_table_content"
    done

    echo "$BOX_DOUBLE_VERTICAL"
}

function print_table {
    local table_content="$1"

    BOX_TOP_LEFT=╔
    BOX_TOP_MIDDLE=╤
    BOX_TOP_RIGHT=╗
    BOX_MIDDLE_LEFT=╟
    BOX_MIDDLE_MIDDLE=┼
    BOX_MIDDLE_RIGHT=╢
    BOX_BOTTOM_LEFT=╚
    BOX_BOTTOM_MIDDLE=╧
    BOX_BOTTOM_RIGHT=╝
    BOX_VERTICAL=│
    BOX_HORIZONTAL=─
    BOX_DOUBLE_HORIZONTAL=═
    BOX_DOUBLE_VERTICAL=║

    local column_nums=$(($(head -n 1 <<< "$table_content" | tr -dc ":" | wc -c) + 1))

    local columns_lengths=()

    for ((column = 1; column <= $column_nums; column++)); do
        local length=0

        while read row; do
            cell_table_content=$(echo -n "$row" | cut -d : -f $column)
            cell_length=$(echo -n "$cell_table_content" | wc -c)

            if [[ $cell_length -eq 0 ]]; then
                cell_length=6 # [null]
            fi

            if [[ $cell_length -gt $length ]]; then
                length=$cell_length
            fi
        done <<< "$table_content"

        columns_lengths[$column]=$length
    done

    local is_first_row=true

    while read row; do

        if [[ $is_first_row = 'false' ]]; then
            print_horizontal_separator MIDDLE "${columns_lengths[@]}" 
        else
            print_horizontal_separator TOP "${columns_lengths[@]}" 
            is_first_row=false
        fi

        print_row "$row" "${columns_lengths[@]}"
    done <<< "$table_content"

    print_horizontal_separator BOTTOM "${columns_lengths[@]}" 
}