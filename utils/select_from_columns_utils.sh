#! /bin/bash

source ./utils/output_utils.sh
source ./utils/constants.sh

function select_from_columns {
    local reason=$1
    local table_metadata_path=$2

    PS3="Select column to $reason >> "

    columns=($(awk -F: '{ print $1 }' "$table_metadata_path"))

    echo > /dev/stderr
    print_blue 'Available Columns:' > /dev/stderr
    print_blue '------------------' > /dev/stderr

    select chosen_col in ${columns[@]}; do
        if [[ -n $chosen_col ]]; then
            echo $chosen_col $REPLY 
            echo 
            return 0
        else
            print_red "Invalid column. Please try again."
        fi    
    done
}