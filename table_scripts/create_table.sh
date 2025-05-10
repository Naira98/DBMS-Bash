#! /bin/bash

set -e

shopt -s extglob

source ./utils/output_utils.sh
source ./utils/validate_utils.sh
source ./utils/constants.sh

read -rp "Enter the name of the table you want to create: " table_name

# Input Validation
table_name=$(validate_name "$table_name") 

# Existence Validation
FILE_PATH="./$WORK_SPACE/$CONNECTED_DB/$table_name"
METADATA_PATH="./$WORK_SPACE/$CONNECTED_DB/.$table_name"
ERROR_MESSAGE="Table '$table_name' already exists."
validate_file_does_not_exist "$FILE_PATH" "$ERROR_MESSAGE"




read -rp "Enter the number of the columns : " cols_num
if ! [[ cols_num =~ ^[0-9]+$ ]]; then
    print_red 'You have to enter a number'
    exit 1
fi

# EDIT
if [[ cols_num =~ ^0+$ ]]; then
    print_red 'You must provide a positive number'
    exit 1
fi

for (( i = 1; i < "$cols_num"; i++ )); do
    # col_name
    # type
    # enter pk first

    # col_name2
    # type (int, varchar, boolean,      date)

    # Constraints
    # 1) [*] unique
    # 2) [ ] not null 
    # ...
    # 5) Done
    1
    # constraint+=(unique)

done

    # composite_pk




#Create the table directory
touch "$FILE_PATH"
touch "$METADATA_PATH"
print_green "Table '$table_name' created successfully."
