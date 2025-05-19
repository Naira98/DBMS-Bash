#! /usr/bin/bash

source ./utils/output_utils.sh

function validate_new_and_stored_data_are_unique {
    local col_num=$1
    local table_data_path=$2
    local new_value=$3

    awk -F : -v col_num=$col_num -v new_value="$new_value" '
        {values[$col_num]++}
        END {
            for (val in values) {
                if (values[val] > 1 || values[new_value] >= 1) exit 1
            }
        }
    ' "$table_data_path"

    if [[ $? -ne 0 ]]; then
        print_red "Error: Duplicate value violates unique constraint"
        return 1
    fi

    return 0
}

function validate_stored_data_have_no_null_values {
    local col_num=$1
    local table_data_path=$2

    awk -F : -v col_num=$col_num '
        {if ($col_num == "") exit 1}
    ' "$table_data_path"

    if [[ $? -ne 0 ]]; then
        return 1
    fi

    return 0
}

function validate_new_data_is_not_null {
    local new_value=$1

    if [[ -z "$new_value" ]]; then
        print_red "Error: Empty value violates not null constraint"
        return 1
    fi

    return 0
}

function validate_constraints {
    local contraints=$1
    local col_num=$2
    local table_data_path=$3
    local input=$4

    IFS=: read pk unique not_null default <<< "$contraints"

    if [[ "$unique" = "unique" ]]; then
        validate_new_and_stored_data_are_unique "$col_num" "$table_data_path" "$input" || return 1
    fi

    if [[ "$not_null" = "not_null" ]]; then
        validate_new_data_is_not_null "$input" || return 1
    fi
}

