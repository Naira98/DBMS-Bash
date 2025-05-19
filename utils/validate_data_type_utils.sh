#! /usr/bin/bash

shopt -s extglob

source ./utils/output_utils.sh

function validate_data_type {
    local data_type=$1
    local not_null_constraint="$2"
    local input="$3"

    if [[ -z "$not_null_constraint" && -z "$input" ]]; then
        return 0
    fi

    case $data_type in
        "integer")
            if [[ ! "$input" =~ ^-?[0-9]+$ ]]; then
                print_red "Error: Value must be an integer."
                return 1
            fi
            ;;
        "string")
            if [[ "$input" =~ : || "$input" =~ $'\n' ]]; then
                print_red "Error: Value can't contain ':' or newlines."
                return 1
            fi
            ;;
        "boolean")
            if [[ ! "$input" =~ ^(true|false)$ ]]; then
                print_red "Error: Value must be 'true' or 'false'."
                return 1
            fi
            ;;
        *)
            print_red "Error: Unknown data type."
            return 1
            ;;
    esac
    return 0
}
