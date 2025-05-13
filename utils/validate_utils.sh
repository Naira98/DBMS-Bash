#! /bin/bash

shopt -s extglob
source ./utils/output_utils.sh

function validate_name {
    local input=$1
    local type=$2  # Database Or Table Or Column

    input=$(tr ' ' '_' <<< "$input")

    # Check if the input is empty
    if [[ -z "$input" ]]; then
        print_red "Error: ${type} name can't be empty."
        return 1
    fi

    # Check if the input starts with a number or contains invalid characters
    if [[ $input =~ ^[0-9] ]]; then
        print_red "Error: ${type} name can't start with a number."
        return 1
    elif [[ ! $input =~ ^[a-zA-Z0-9_]+$ ]]; then
        print_red "Error: ${type} name can only contain alphanumeric characters and underscores."
        return 1
    fi

    # Check if the input is too long
    if [[ ${#input} -gt 64 ]]; then
        print_red "Error: ${type} name is too long. Maximum length is 64 characters."
        return 1
    fi

    echo $input
    return 0
}

# function validate_dir_exists {
#     local dir_path=$1
#     local error_message=$2

#     # Check if the dir already exists
#     if [[ ! -d "$dir_path" ]]; then
#         print_red "$error_message"
#         return 1
#     fi
#     return 0
# }

function validate_dir_does_not_exist {
    local dir_path=$1
    local error_message=$2

    # Check if the dir does not exist
    if [[ -d "$dir_path" ]]; then
        print_red "$error_message"
        return 1
    fi
    return 0
}

function validate_file_exists {
    local file_path=$1
    local error_message=$2

    # Check if the file already exists
    if [[ ! -f "$file_path" ]]; then
        print_red "$error_message"
        return 1
    fi
    return 0
}

function validate_file_does_not_exist {
    local file_path=$1
    local error_message=$2

    # Check if the file does not exist
    if [[ -f "$file_path" ]]; then
        print_red "$error_message"
        return 1
    fi
    return 0
}
