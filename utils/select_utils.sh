#!/usr/bin/bash
source ./utils/output_utils.sh

function select_from_databases {
    local reason=$1

    PS3="Select database to $reason >> "

    local dbs=($(ls -F ./$WORK_SPACE | grep '/$' | sed 's/\/$//'))

    if [[ ${#dbs[@]} -eq 0 ]]; then
        echo_red "Error: There's no databases to $reason"
        return 1
    fi

    echo > /dev/stderr
    echo 'Choose a database:' > /dev/stderr
    echo '━━━━━━━━━━━━━━━━━━' > /dev/stderr

    select chosen_db in "${dbs[@]}"; do
        if [[ -n $chosen_db ]]; then
            echo $chosen_db
            return 0
        else
            echo_red "Invalid database. Please try again."
        fi
    done
}


function select_from_tables {
    local reason=$1

    PS3="Select table to $reason >> "

    local tables=($(ls ./$WORK_SPACE/$CONNECTED_DB))

    if [[ ${#tables[@]} -eq 0 ]]; then
        echo_red "Error: There's no tables to $reason"
        return 1
    fi

    echo > /dev/stderr
    echo 'Choose a table:' > /dev/stderr
    echo '━━━━━━━━━━━━━━━' > /dev/stderr

    select chosen_table in "${tables[@]}"; do
        if [[ -n $chosen_table ]]; then
            echo $chosen_table
            return 0
        else
            echo_red "Invalid table. Please try again."
        fi
    done
}


function select_from_columns {
    local reason=$1
    local table_metadata_path=$2

    PS3="Select column to $reason >> "

    local columns=($(awk -F: '{ print $1 }' "$table_metadata_path"))

    echo > /dev/stderr
    echo 'Choose a column:' > /dev/stderr
    echo '━━━━━━━━━━━━━━━━' > /dev/stderr

    select chosen_col in ${columns[@]}; do
        if [[ -n $chosen_col ]]; then

            read col_data_type col_constraints <<< $(awk -F: -v col_name=$chosen_col '
                { if ( $1 == col_name ) {
                    data_type = $2
                    constraints = ""
                    for (i=3; i<=NF; i++) constraints = constraints (i > 3 ? ":" : "") $i
                    print data_type, constraints
                }}
            ' $table_metadata_path)

            echo "$chosen_col" "$REPLY" "$col_data_type" "$col_constraints"
            echo 
            return 0
        else
            echo_red "Invalid column. Please try again."
        fi    
    done
}