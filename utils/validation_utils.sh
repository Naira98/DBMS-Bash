#!/usr/bin/bash
source ./utils/output_utils.sh
shopt -s extglob

function validate_name {
    local input=$1
    local type=$2  # Database Or Table Or Column

    input=$(tr ' ' '_' <<< "$input")

    # Check if the input is empty
    if [[ -z "$input" ]]; then
        echo_red "Error: ${type} name can't be empty. Please try again."
        return 1
    fi

    # Check if the input starts with a number or contains invalid characters
    if [[ $input =~ ^[0-9] ]]; then
        echo_red "Error: ${type} name can't start with a number. Please try again."
        return 1
    elif [[ ! $input =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo_red "Error: ${type} name can only contain alphanumeric characters and underscores. Please try again."
        return 1
    fi

    # Check if the input is too long
    if [[ ${#input} -gt 64 ]]; then
        echo_red "Error: ${type} name is too long. Maximum length is 64 characters. Please try again."
        return 1
    fi

    echo "$input"

    return 0
}

function validate_dir_does_not_exist {
    local dir_path=$1
    local error_message=$2

    # Check if the dir does not exist
    if [[ -d "$dir_path" ]]; then
        echo_red "$error_message"
        return 1
    fi

    return 0
}

function validate_file_does_not_exist {
    local file_path=$1
    local error_message=$2

    # Check if the file does not exist
    if [[ -f "$file_path" ]]; then
        echo_red "$error_message"
        return 1
    fi

    return 0
}



function validate_data_type {
    local data_type=$1
    local not_null_constraint="$2"
    local input="$3"

    if [[ -z "$not_null_constraint" && -z "$input" ]]; then
        return 0
    fi

    case $data_type in
        "integer")
            if [[ ! "$input" =~ ^-?[1-9][0-9]*$ && "$input" != "0" ]]; then
                echo_red "Error: Value must be a valid integer (no leading zeros, no -0)."
                return 1
            fi
            ;;
        "string")
            if [[ "$input" =~ : || "$input" =~ $'\n' ]]; then
                echo_red "Error: Value can't contain ':' or newlines."
                return 1
            fi
            ;;
        "boolean")
            if [[ ! "$input" =~ ^(true|false)$ ]]; then
                echo_red "Error: Value must be 'true' or 'false'."
                return 1
            fi
            ;;
        *)
            echo_red "Error: Unknown data type."
            return 1
            ;;
    esac

    return 0
}



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
        echo_red "Error: There are duplicate values violate unique constraint."
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
        echo_red "Error: Empty value violates not null constraint."
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
