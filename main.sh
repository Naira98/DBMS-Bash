#! /bin/bash
#! /usr/bin/bash

# Get the current script's directory and cd into it
cd "$(dirname "${BASH_SOURCE[0]}")"

source ./utils/output_utils.sh
source ./utils/constants.sh

clear

# Display animated welcome message
# echo "=============================================="
# type_writer "🗃️  Welcome to Mohamed & Naira's DBMS Shell"
# type_writer "🕒  Started at: $(date)"
# echo "=============================================="

if [[ ! -d $WORK_SPACE ]]; then
    mkdir -p ./$WORK_SPACE
    print_blue "Your workspace '$WORK_SPACE' created successfully."
    # echo "[$(date)] Workspace created: $WORK_SPACE" >> logs.txt
else
    print_blue "Your workspace '$WORK_SPACE' already exists. Let's start working on it."
    # echo "[$(date)] Workspace already exists: $WORK_SPACE" >> logs.txt
fi

# sleep 1

# Main Menu
./db_scripts/main_menu.sh