#! /bin/bash

# Get the current script's directory and cd into it
cd "$(dirname "${BASH_SOURCE[0]}")"

source ./utils/output_utils.sh
source ./utils/constants.sh

if [[ ! -d $WORK_SPACE ]]; then
    mkdir ./$WORK_SPACE
    print_blue "Your wrokspace '$WORK_SPACE' created successfully."
else
    print_blue "Your wrokspace '$WORK_SPACE' already exists. Let's start working on it."
fi

sleep 1

# Main Menu
./db_scripts/main_menu.sh