#!/usr/bin/bash

export WORK_SPACE=".DBMS"

# Get the current script's directory and cd into it
cd "$(dirname "${BASH_SOURCE[0]}")"

source ./utils/output_utils.sh

clear

if [[ ! -d $WORK_SPACE ]]; then
    mkdir -p ./$WORK_SPACE
fi

# Main Menu
./db_scripts/main_menu.sh