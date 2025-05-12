#! /bin/bash

function select_from_tables {
    local reason=$1

    PS3="Select table to $reason >> "

    tables=($(ls ./$WORK_SPACE/$CONNECTED_DB))

    if [[ ${#tables[@]} -eq 0 ]]; then
        print_red "There's no tables to $reason"
        return 1
    fi

    select choosen_table in "${tables[@]}"; do
        if [[ -n $chosen_table ]]; then
            echo $chosen_table
            return 0
        else
            print_red "Invalid selection. Please choose again."
        fi
    done
}