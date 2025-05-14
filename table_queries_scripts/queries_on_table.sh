#! /usr/bin/bash
#! /usr/bin/bash

set -e

# Enable extended pattern matching
shopt -s extglob

# Load utility functions for output, validation, and constants
source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

# Prompt user to enter table name and validate it
read -rp "Enter the table name to alter: " table_name
table_name=$(validate_name "$table_name" "Table")

# Define the paths for the table's data and metadata files
DATA_FILE="./$WORK_SPACE/$CONNECTED_DB/$table_name"
META_FILE="./$WORK_SPACE/$CONNECTED_DB/.$table_name"

# Ensure the table data file exists
validate_file_exists "$DATA_FILE" "Table '$table_name' does not exist."

# Load columns, data types, and constraints from the metadata file
columns=()
types=()
constraints=()

while IFS=: read -r name type cons; do
    columns+=("$name")
    types+=("$type")
    constraints+=("$cons")
done < "$META_FILE"

# Function to display table contents in tabular format
function print_table_data {
    print_blue "\n=========== Table: $table_name ==========="
    printf "| %-20s" "${columns[@]}"  # Print column headers
    echo "|"
    echo "-----------------------------------------------"

    # Read and print each row (excluding header)
    while IFS='|' read -r $(IFS=' ' ; echo "${columns[*]}"); do
        for col in "${columns[@]}"; do
            printf "| %-20s" "${!col}"  # Print each value aligned under its column
        done
        echo "|"
    done < <(tail -n +2 "$DATA_FILE")  # Skip header line
    echo "==============================================="
}

# Function to check if a value exists in a specific column
function value_exists_in_column {
    local value="$1"
    local col_index="$2"
    cut -d'|' -f$((col_index + 1)) "$DATA_FILE" | tail -n +2 | grep -qx "$value"
}

# Main menu loop for table operations
while true; do
    echo
    PS3="${CONNECTED_DB}_db [${table_name}] >> "
    select action in "Insert" "Update" "Delete" "Select" "Back" "Exit"; do
        case $action in
            "Insert")
                echo "Insert new row:"
                new_row=""
                # Loop through each column to collect input
                for i in "${!columns[@]}"; do
                    col="${columns[$i]}"
                    type="${types[$i]}"
                    cons="${constraints[$i]}"
                    val=""

                    # Input loop for a valid value
                    while true; do
                        read -rp "Enter value for '$col': " val
                        if [[ -z "$val" ]]; then
                            if [[ "$cons" == *notnull* ]]; then
                                print_red "This field cannot be null."
                                continue
                            else
                                val="NULL"
                            fi
                        fi

                        # Check for unique or primary key constraint
                        if [[ "$cons" == *pk* || "$cons" == *unique* ]]; then
                            if value_exists_in_column "$val" "$i"; then
                                print_red "Value '$val' already exists for column '$col' (must be unique)."
                                continue
                            fi
                        fi
                        break
                    done
                    new_row+="$val|"
                done

                # Remove trailing '|' and insert the row
                new_row=${new_row%|}
                echo "$new_row" >> "$DATA_FILE"
                print_green "Row inserted successfully."
                break
                ;;

            "Update")
                print_table_data
                read -rp "Enter row number to update: " row_num
                total_rows=$(($(wc -l < "$DATA_FILE") - 1))  # Exclude header
                if [[ $row_num -lt 1 || $row_num -gt $total_rows ]]; then
                    print_red "Invalid row number."
                    break
                fi

                # Fetch and split old row values
                old_row=$(sed "$((row_num + 1))q;d" "$DATA_FILE")
                IFS='|' read -ra old_vals <<< "$old_row"
                new_row=""

                echo "Enter new values (leave blank to keep old value):"
                for i in "${!columns[@]}"; do
                    col="${columns[$i]}"
                    type="${types[$i]}"
                    cons="${constraints[$i]}"
                    read -rp "New value for '${col}' [${old_vals[$i]}]: " val

                    if [[ -z "$val" ]]; then
                        val="${old_vals[$i]}"  # Keep old value if left blank
                    fi

                    # Check uniqueness constraint for updated value
                    if [[ "$cons" == *pk* || "$cons" == *unique* ]]; then
                        if [[ "$val" != "${old_vals[$i]}" && $(cut -d'|' -f$((i+1)) "$DATA_FILE" | tail -n +2 | grep -cx "$val") -gt 0 ]]; then
                            print_red "Value '$val' already exists for column '$col' (must be unique)."
                            continue 2
                        fi
                    fi

                    # Check NOT NULL constraint
                    if [[ -z "$val" && "$cons" == *notnull* ]]; then
                        print_red "This field cannot be null."
                        continue 2
                    fi

                    [[ -z "$val" ]] && val="NULL"
                    new_row+="$val|"
                done

                # Replace old row with new row in the file
                new_row=${new_row%|}
                sed -i "$((row_num + 1))s/.*/$new_row/" "$DATA_FILE"
                print_green "Row updated successfully."
                break
                ;;

            "Delete")
                print_table_data
                read -rp "Enter row number to delete: " row_num
                # Delete the specified row (skip header)
                sed -i "$((row_num + 1))d" "$DATA_FILE"
                print_green "Row deleted successfully."
                break
                ;;

            "Select")
                print_table_data  # Display all table contents
                break
                ;;

            "Back")
                ./table_scripts/table_menu.sh "$CONNECTED_DB"  # Go back to table menu
                exit 0
                ;;

            "Exit")
                echo "Exiting table operations..."
                exit 0
                ;;

            *)
                print_red "Invalid option. Try again."  # Handle invalid menu choice
                ;;
        esac
    done
done
