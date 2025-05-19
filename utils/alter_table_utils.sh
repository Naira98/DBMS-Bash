#! /usr/bin/bash

function ask_for_unique_and_default_constraints {
    PS3="Select column constraints one at a time >> "

    local col_name=$1
    local data_type=$2
    # pk:unique:not_null:default
    local chosen_constraints=":::"

    while true; do
        unique_marker=$(awk -F: '{if ($2 == "unique") print "*"; else print " "}' <<< $chosen_constraints)
        default_marker=$(awk -F: '{if ($4 != "") print "*"; else print " "}' <<< $chosen_constraints)

        select constraint in "[$unique_marker] unique" "[$default_marker] default" "Done"; do
            case $REPLY in
                1) #unique
                    if [[ $chosen_constraints == *:unique:* ]]; then
                        chosen_constraints=${chosen_constraints/:unique:/::}

                    else
                        chosen_constraints=$(awk -F: '{$2="unique"; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                2) #default
                    if [[ $chosen_constraints =~ :$ ]]; then
                        read -rp "Enter a default value for $col_name: " default_value

                        validate_data_type $data_type "not_null" $default_value
                        first_validation=$?

                        validate_no_colon_or_newlines $default_value
                        second_validation=$?
                        
                        if [[ $first_validation = 0 && $second_validation = 0 ]]; then
                            chosen_constraints=$(awk -F: -v default_value="$default_value" '{$4=default_value; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                        fi
                    else
                        chosen_constraints=$(awk -F: '{$4=""; print $1":"$2":"$3":"$4}' <<< $chosen_constraints)
                    fi
                ;;

                3) # Done
                    echo $chosen_constraints
                    return 0
                ;;

                *)
                    print_red "Invalid input. please try again"
            esac
            echo $chosen_constraints >/stderr
            break
        done
    done
}