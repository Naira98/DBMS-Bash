#! /bin/bash

shopt -s extglob

function validate_input {
    local input=$1
    input=$(tr ' ' '_' <<< "$input")

    # Check if the database name is empty
    if [[ -z "$input" ]]; then
        echo -e "Error: Database name cannot be empty."
        return 1
    fi

    # Check if the database name starts with a number or contains invalid characters
    if [[ $input =~ ^[0-9] ]]; then
        echo -e "Error: Database name cannot start with a number."
        return 1
    elif [[ ! $input =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo -e "Error: Database name can only contain alphanumeric characters and underscores."
        return 1
    fi

    # Check if the database name is too long
    if [[ ${#input} -gt 64 ]]; then
        echo -e "Error: Input is too long. Maximum length is 64 characters."
        return 1
    fi

    echo $input
    return 0
}

function validate_dir_existance {
    local dir_path=$1

    # Check if the dir already exists
    if [[ -d "$dir_path" ]]; then
        return 1
    fi
    return 0
}
