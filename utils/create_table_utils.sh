#! /bin/bash

source ./utils/validate_utils.sh
source ./utils/validate_table_data_utils.sh
source ./utils/output_utils.sh

function ask_for_col_name {
    local table_metadata_path=$1
    local col_num=$2

    if (( $col_num == 1 )); then
        echo "========================================" > /dev/stderr
        echo Make sure this column is the primary key > /dev/stderr
        echo "========================================" > /dev/stderr
    fi

    read -rp "Enter name of column $col_num: " col_name
    col_name=$(validate_name "$col_name" "Column")

    col_names=$(awk -F : '{print $1}' $table_metadata_path)

    if echo "$col_names" | grep -qwq "$col_name"; then
        print_red "Error: Column name '$col_name' already exists"
        return 1
    fi

    echo $col_name
    return 0
}

function ask_for_data_type {
    PS3="Select column data type >> "
    local col_name=$1

    select data_type in "int" "varchar" "boolean"; do
        case $data_type in
            int|varchar|boolean)
                break
                ;;
            *)
                print_red "Invalid type. Please choose again."
                ;;
        esac
    done
    echo $data_type
    return 0
}

function ask_for_chosen_constraints {
    PS3="Select column constraints one at a time >> "

    local col_name=$1
    local data_type=$2
    # pk:unique:not_null:default
    local chosen_constraints=":::"

    while true; do
        unique_marker=$(awk -F: '{if ($2 == "unique") print "*"; else " "}' <<< $chosen_constraints)
        not_null_marker=$(awk -F: '{if ($3 == "not_null") print "*"; else " "}' <<< $chosen_constraints)
        default_marker=$(awk -F: '{if ($4 != "") print "*"; else " "}' <<< $chosen_constraints)

        select constraint in "[$unique_marker] unique" "[$not_null_marker] not null" "[$default_marker] default" "Done"; do
            case $REPLY in
                1) #unique
                    if [[ $chosen_constraints == *:unique:* ]]; then
                        chosen_constraints=${chosen_constraints/:unique:/::}
                    else
                        chosen_constraints=$(awk -F: '{$2="unique"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                2) #not_null
                    if [[ $chosen_constraints == *:not_null:* ]]; then
                        chosen_constraints=${chosen_constraints/:not_null:/::}
                    else
                        chosen_constraints=$(awk -F: '{$3="not_null"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                3) #default
                    if [[ $chosen_constraints =~ :$ ]]; then
                        read -rp "Enter a default value for $col_name: " default_value

                        validate_data_type $default_value $data_type
                        validate_no_colon_or_newlines $default_value
                        

                        chosen_constraints=$(awk -F: -v default_value="$default_value" '{$4=default_value; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    else
                        chosen_constraints=$(awk -F: '{$4=""; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                4) # Done
                    echo $chosen_constraints
                    return 0
                ;;

            esac
            echo $chosen_constraints
            break
        done
    done
}

