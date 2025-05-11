#! /bin/bash

shopt -s extglob

source ./utils/output_utils.sh

function validate_data_type {
    local input=$1
    local data_type=$2

    case $data_type in
        "int")
            if [[ ! "$input" =~ ^-?[0-9]+$ ]]; then
                print_red "Error: Default value must be an integer."
                return 1
            fi
            ;;
        "varchar")
            if [[ "$input" =~ '[^a-zA-Z0-9_ ]' ]]; then
                print_red "Error: Default value must be alphanumeric."
                return 1
            fi
            ;;
        "boolean")
            if [[ ! "$input" =~ ^(true|false)$ ]]; then
                print_red "Error: Default value must be 'true' or 'false'."
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

function validate_no_colon_or_newlines {
    local input=$1

    if [[ "$input" =~ : || "$input" =~ $'\n' ]]; then
        print_red "Error: Default value cannot contain ':' or newlines."
        return 1
    fi
}