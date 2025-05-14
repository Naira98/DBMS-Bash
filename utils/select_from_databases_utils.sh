#! /bin/bash

source ./utils/constants.sh

function select_from_databases {
    local reason=$1

    PS3="Select database to $reason >> "

    dbs=($(ls -F ./$WORK_SPACE | grep '/$' | sed 's/\/$//'))

    if [[ ${#dbs[@]} -eq 0 ]]; then
        print_red "There's no databases to $reason"
        return 1
    fi

    echo > /dev/stderr
    print_blue 'Available Databases:'
    print_blue '--------------------'

    select chosen_db in "${dbs[@]}"; do
        if [[ -n $chosen_db ]]; then
            echo $chosen_db
            return 0
        else
            print_red "Invalid database. Please try again."
        fi
    done
}
