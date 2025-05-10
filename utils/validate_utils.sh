#! /bin/bash

shopt -s extglob
source ./utils/output_utils.sh

function validate_name {
    local input=$1
    input=$(tr ' ' '_' <<< "$input")

    # Check if the database name is empty
    if [[ -z "$input" ]]; then
        echo 'here'
        print_red "Error: Database name cannot be empty."
        return 1
    fi

    # Check if the database name starts with a number or contains invalid characters
    if [[ $input =~ ^[0-9] ]]; then
        echo 'input start with number'
        print_red "Error: Database name cannot start with a number."
        return 1
    elif [[ ! $input =~ ^[a-zA-Z0-9_]+$ ]]; then
        print_red "Error: Database name can only contain alphanumeric characters and underscores."
        return 1
    else
        print_red "Error: Invalid name."
        return 1
    fi

    # Check if the database name is too long
    if [[ ${#input} -gt 64 ]]; then
        print_red "Error: Input is too long. Maximum length is 64 characters."
        return 1
    fi

    echo $input
    return 0
}

function validate_dir_exists {
    local dir_path=$1
    local error_message=$2

    # Check if the dir already exists
    if [[ ! -d "$dir_path" ]]; then
        print_red "$error_message"
        return 1
    fi
    return 0
}

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
