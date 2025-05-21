#! /usr/bin/bash

source ./utils/validate_utils.sh
source ./utils/validate_constraints_utils.sh
source ./utils/validate_data_type_utils.sh
source ./utils/output_utils.sh
source ./utils/constants.sh

function ask_for_table_name {
    while true; do
        echo > /dev/stderr
        read -rp "Enter the name of the table you want to create: " table_name

        # Input Validation
        table_name=$(validate_name "$table_name" "Table") || continue

        # Existence Validation
        table_path="./$WORK_SPACE/$CONNECTED_DB/$table_name" 
        table_metadata_path="./$WORK_SPACE/$CONNECTED_DB/.$table_name"
        error_message="Table '$table_name' already exists."
        validate_file_does_not_exist "$table_path" "$error_message" || continue

        echo "$table_name" "$table_path" "$table_metadata_path"
        break
    done
}

function ask_for_number_of_columns {
    while true; do
        echo > /dev/stderr
        read -rp "Enter the number of columns: " cols_num

        if [[ ! $cols_num =~ ^-?[0-9]+$ ]]; then
            print_red 'Error: Number of columns must be a valid number'
            continue
        fi
        if (( cols_num < 0 )); then
            print_red "Error: Number of columns can't be negative"
            continue
        fi
        if (( cols_num == 0 )); then
            print_red "Error: Number of columns can't be zero"
            continue
        fi

        echo $cols_num
        break
    done
}

function ask_for_col_name {
    local table_metadata_path=$1
    local prompt=$2
    local col_num=$3

    while true; do

        if (( $col_num == 1 )); then
            echo > /dev/stderr
            echo "==========================================" > /dev/stderr
            echo " Make sure this column is the primary key " > /dev/stderr
            echo "==========================================" > /dev/stderr
        else
            echo > /dev/stderr
        fi

        read -rp "$prompt" col_name
        col_name=$(validate_name "$col_name" "Column") || continue

        col_names=$(awk -F : '{print $1}' $table_metadata_path)

        if echo "$col_names" | grep -qw "$col_name"; then
            print_red "Error: Column name '$col_name' already exists"
            continue
        fi

        echo $col_name
        break
    done
}

function ask_for_data_type {
    PS3="Select column data type >> "
    local col_name=$1

    while true; do
        echo > /dev/stderr
        echo "Data Type" > /dev/stderr
        echo "---------" > /dev/stderr
        select data_type in "integer" "string" "boolean"; do
            case $data_type in
                integer|string|boolean)
                    echo $data_type
                    return 0
                    ;;
                *)
                    print_red "Invalid data type. Please try again."
                    break
                    ;;
            esac
        done
    done
}

function ask_for_auto_increment {
    local col_name="$1"

    echo > /dev/stderr
    read -rp "Do you want column '$col_name' to be auto_incremented ? (y/n): " answer

    if [[ "$answer" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$answer" == "" ]]; then
        echo "auto_increment"
    fi
}

function ask_for_all_constraints {
    PS3="Select column constraints one at a time >> "

    local col_name=$1
    local data_type=$2
    local old_constraints=$3
    local table_data_path=$4
    local col_num=$5

    # pk:unique:not_null:auto_increment
    # :unique:not_null:default
    if [[ -n $old_constraints ]]; then
        local chosen_constraints=$old_constraints
    else
        local chosen_constraints=":::"
    fi

    while true; do
        unique_marker=$(awk -F: '{if ($2 == "unique") print "*"; else print " "}' <<< $chosen_constraints)
        not_null_marker=$(awk -F: '{if ($3 == "not_null") print "*"; else print " "}' <<< $chosen_constraints)

        # Last choice is either auto_increment in pk column or default value in any column else
        if [[ $col_num -eq 1 ]]; then
            auto_increment_marker=$(awk -F: '{if ($4 != "") print "*"; else print " "}' <<< $chosen_constraints)
            last_choice="[$auto_increment_marker] auto_increment"
        else
            default_marker=$(awk -F: '{if ($4 != "") print "*"; else print " "}' <<< $chosen_constraints)
            last_choice="[$default_marker] default"
        fi
        
        quote="Constraints for '$col_name' column"
        
        echo > /dev/stderr
        echo "$quote" > /dev/stderr
        printf '%*s\n' "${#quote}" '' | tr ' ' '-' > /dev/stderr

        select constraint in "[$unique_marker] unique" "[$not_null_marker] not null" "$last_choice" "# Done"; do
            case $REPLY in
                1) #unique
                    if [[ $chosen_constraints == *:unique:* ]]; then
                        if [[ $col_num -eq 1 ]]; then
                            print_red "Error: You can't delete unique constraint from primary key '$col_name'."
                        else
                            chosen_constraints=${chosen_constraints/:unique:/::}
                        fi
                    else
                        # Create table
                        if [[ -z $old_constraints ]]; then
                            chosen_constraints=$(awk -F: '{$2="unique"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                        else

                            # Add column - Alter table
                            if [[ $old_constraints = "::::" ]]; then
                            
                                if [[ $(wc -l < "$table_data_path") -gt 1 ]]; then
                                    print_red "Error: Can't add unique constraint. There is a data in table."
                                else
                                    chosen_constraints=$(awk -F: '{$2="unique"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                                fi

                            else

                                # Add or Drop contraints - Alter table
                                function handle_error {
                                    print_red "Error: There are duplicate values in column $col_num."
                                }

                                validate_stored_data_are_unique "$col_num" "$table_data_path" || handle_error
                                
                                chosen_constraints=$(awk -F: '{$2="unique"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                            fi
                        fi
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
                        # Create table
                        if [[ -z $old_constraints ]]; then
                            chosen_constraints=$(awk -F: '{$3="not_null"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)

                        else
                            # Alter table - Add column case
                            if [[ $old_constraints = "::::" ]]; then
                            
                                if [[ $(wc -l < "$table_data_path") -gt 1 ]]; then
                                    print_red "Error: Can't add not null constraint. There is a data in table."
                                else
                                    chosen_constraints=$(awk -F: '{$3="not_null"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                                fi
                            else

                                # Alter table - Add or Drop contraints
                                function handle_error {
                                    print_red "Error: Invalid not null constraint. There are duplicate values in column $col_name ."
                                }
                                validate_stored_data_have_no_null_values "$col_num" "$table_data_path" || handle_error

                                chosen_constraints=$(awk -F: '{$3="not_null"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                            fi
                        fi
                    fi
                    ;;

                3) #default value or auto_increment
                    if [[ $chosen_constraints =~ :$ ]]; then
                        if [[ $col_num -eq 1 ]]; then
                            if [[ $data_type = 'integer' ]]; then
                                chosen_constraints=$(awk -F: '{$4="auto_increment"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                            else
                                print_red "Error: You can't add auto_increment constraint to "$data_type" primary key '$col_name'."
                            fi
                        else
                            read -rp "Enter a default value for $col_name: " default_value

                            validate_data_type "$data_type" "not_null" "$default_value" || break

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
                    print_red "Invalid constraint. please try again"
                    ;;
            esac
            break
        done
    done
}