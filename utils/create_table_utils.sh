#! /bin/bash

source ./utils/validate_utils.sh
source ./utils/validate_constraints_utils.sh
source ./utils/validate_table_data_utils.sh
source ./utils/output_utils.sh

function ask_for_col_name {
    local table_metadata_path=$1
    local prompt=$2
    local col_num=$3

    if (( $col_num == 1 )); then
        echo "========================================" > /dev/stderr
        echo Make sure this column is the primary key > /dev/stderr
        echo "========================================" > /dev/stderr
    fi

    read -rp "$prompt" col_name
    col_name=$(validate_name "$col_name" "Column") || return $?

    col_names=$(awk -F : '{print $1}' $table_metadata_path)

    if echo "$col_names" | grep -qw "$col_name"; then
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

function ask_for_all_constraints {
    PS3="Select column constraints one at a time >> "

    local col_name=$1
    local data_type=$2
    local old_constraints=$3
    local table_data_path=$4
    local col_num=$5

    # pk:unique:not_null:default
    if [[ -n $old_constraints ]]; then
        local chosen_constraints=$old_constraints
    else
        local chosen_constraints=":::"
    fi

    while true; do
        unique_marker=$(awk -F: '{if ($2 == "unique") print "*"; else print " "}' <<< $chosen_constraints)
        not_null_marker=$(awk -F: '{if ($3 == "not_null") print "*"; else print " "}' <<< $chosen_constraints)
        default_marker=$(awk -F: '{if ($4 != "") print "*"; else print " "}' <<< $chosen_constraints)
        
        select constraint in "[$unique_marker] unique" "[$not_null_marker] not null" "[$default_marker] default" "Done"; do
            case $REPLY in
                1) #unique
                    if [[ $chosen_constraints == *:unique:* ]]; then
                        if [[ $col_num -eq 1 ]]; then
                            print_red "Error: You can't delete unique constraint from primary key '$col_name'."
                        else
                            chosen_constraints=${chosen_constraints/:unique:/::}
                        fi
                    else
                        if [[ -n $old_constraints ]]; then
                            function handle_error {
                                print_red "Error: There are duplicate values in column $col_num."
                            }

                            validate_stored_data_are_unique "$col_num" "$table_data_path" || handle_error
                        fi
                        chosen_constraints=$(awk -F: '{$2="unique"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                2) #not_null
                    if [[ $chosen_constraints == *:not_null:* ]]; then
                        if [[ $col_num -eq 1 ]]; then
                            print_red "Error: You can't delete not null constraint from primary key '$col_name'."
                        else
                            chosen_constraints=${chosen_constraints/:not_null:/::}
                        fi
                    else
                        if [[ -n $old_constraints ]]; then
                            validate_stored_data_have_no_null_values "$col_num" "$table_data_path"
                            if [[ $? -ne 0 ]]; then
                                print_red "Error: Invalid not null constraint. There are duplicate values in column $col_name ."
                                return 1
                            fi
                        fi
                        chosen_constraints=$(awk -F: '{$3="not_null"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                3) #default
                    if [[ $chosen_constraints =~ :$ ]]; then
                        if [[ $col_num -eq 1 ]]; then
                            print_red "Error: You can't add default value for the primary key '$col_name'."
                        else
                            read -rp "Enter a default value for $col_name: " default_value

                            validate_data_type $default_value $data_type

                            if [[ $? -eq 0 ]]; then
                                chosen_constraints=$(awk -F: -v default_value="$default_value" '{$4=default_value; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                            fi
                        fi
                    else
                        chosen_constraints=$(awk -F: '{$4=""; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                4) # Done
                    echo $chosen_constraints
                    return 0
                ;;

                *)
                    print_red "Invalid input. please try again"
            esac
            break
        done
    done
}

function delete_table_and_abort {
    echo in delete table and abort
    local table_path=$1
    local table_metadata_path=$2

    rm -f "$table_path" "$table_metadata_path"

    return 1
}

