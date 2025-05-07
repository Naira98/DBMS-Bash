#! /bin/bash
# To start project $ source ./main.sh

# Get the current script's directory
# SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

relative_file_path=${BASH_SOURCE[0]}
suffix="/main.sh"
SCRIPT_DIR=${path%"$suffix"}

# Open utils files as sourcing
utils=(validate_utils.sh output_utils.sh variables.sh)
for file in ${utils[@]}; do
    if [[ ! -f $SCRIPT_DIR/$file ]]; then
        print_error "Error: $file not found."
    else
        source $SCRIPT_DIR/$file
    fi
done

if [[ ! -d $WORK_SPACE ]]; then
    mkdir ./$WORK_SPACE
    print_success "$WORK_SPACE created successfully."
else
    print_success "$WORK_SPACE already exists. Let's start working on it."
fi

sleep 0.5

# Main Menu
source $SCRIPT_DIR/main_menu.sh