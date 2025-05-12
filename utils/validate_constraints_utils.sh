#! /bin/bash

source ./utils/output_utils.sh

function validate_stored_data_have_no_null_values {
    col_num=$1
    table_data_path=$2

    # Check if the column number and file path are provided
    if [[ -z "$col_num" || -z "$table_data_path" ]]; then
        echo "Column number or table data path not provided."
        return 1
    fi

    # Validate that the file exists
    if [[ ! -f "$table_data_path" ]]; then
        echo "File does not exist: $table_data_path"
        return 1
    fi

    awk -F : -v col_num=$col_num '
        {if ($col_num == "") exit 1}
    ' "$table_data_path"

    if [[ $? -ne 0 ]]; then
        return 1
    fi

    return 0
}

function validate_stored_data_are_unique {
    col_num=$1
    table_data_path=$2

    # Check if the column number and file path are provided
    if [[ -z "$col_num" || -z "$table_data_path" ]]; then
        echo "Column number or table data path not provided."
        return 1
    fi

    # Validate that the file exists
    if [[ ! -f "$table_data_path" ]]; then
        echo "File does not exist: $table_data_path"
        return 1
    fi

    awk -F : -v col_num=$col_num '
        {values[$col_num]++}
        END {
            for (val in values) {
                if (values[val] > 1) exit 1
            }
        }
    ' "$table_data_path"

    if [[ $? -ne 0 ]]; then
        return 1
    fi

    return 0
}

