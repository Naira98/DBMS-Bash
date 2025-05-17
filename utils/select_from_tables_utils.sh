#! /usr/bin/bash

source ./utils/output_utils.sh
source ./utils/constants.sh

function select_from_tables {
    local reason=$1

    PS3="Select table to $reason >> "

    local tables=($(ls ./$WORK_SPACE/$CONNECTED_DB))

    if [[ ${#tables[@]} -eq 0 ]]; then
        print_red "There's no tables to $reason"
        return 1
    fi

    echo > /dev/stderr
    print_blue 'Available Tables:' > /dev/stderr
    print_blue '-----------------' > /dev/stderr

    select chosen_table in "${tables[@]}"; do
        if [[ -n $chosen_table ]]; then
            echo $chosen_table
            return 0
        else
            print_red "Invalid table. Please try again."
        fi
    done
}