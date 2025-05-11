#! /bin/bash
#! /usr/bin/bash
<<COMMENT
# Get the current script's directory and cd into it
cd "$(dirname "${BASH_SOURCE[0]}")"

source ./utils/output_utils.sh
source ./utils/constants.sh

if [[ ! -d $WORK_SPACE ]]; then
    mkdir ./$WORK_SPACE
    print_blue "Your wrokspace '$WORK_SPACE' created successfully."
else
    print_blue "Your workspace '$WORK_SPACE' already exists. Let's start working on it."
fi

sleep 1

# Main Menu
./db_scripts/main_menu.sh
COMMENT

#!/bin/bash
#! /usr/bin/bash

# ===============================================
# Bash DBMS - Entry Point
# Authors: Mohamed Abdrabou & Naira Mokhtar
# ===============================================

# Navigate to the script's directory (ensures relative paths work correctly)
cd "$(dirname "${BASH_SOURCE[0]}")"

# Source utility scripts for output formatting and constants
source ./utils/output_utils.sh
source ./utils/constants.sh

# ================== Helper Functions ==================

# Check if essential project directories exist (utils, db_scripts, table_scripts)
function check_required_dirs {
    for dir in "utils" "db_scripts" "table_scripts"; do
        if [[ ! -d "$dir" ]]; then
            print_red "Missing required directory: $dir"
            echo "[$(date)] Error: Missing directory '$dir'" >> logs.txt
            exit 1
        fi
    done
}

# Ensure the script has write permissions in the current directory
function check_write_permissions {
    if [[ ! -w "." ]]; then
        print_red "Error: No write permissions in the current directory."
        echo "[$(date)] Error: No write permissions" >> logs.txt
        exit 1
    fi
}

# Create the workspace directory if it does not exist
function create_workspace_if_not_exists {
    if [[ ! -d $WORK_SPACE ]]; then
        mkdir -p "$WORK_SPACE"
        print_blue "Your workspace '$WORK_SPACE' created successfully."
        echo "[$(date)] Workspace created: $WORK_SPACE" >> logs.txt
    else
        print_blue "Your workspace '$WORK_SPACE' already exists. Let's start working on it."
        echo "[$(date)] Workspace already exists: $WORK_SPACE" >> logs.txt
    fi
}

# ================== Animation Function ==================

# Typing animation effect for welcome messages
function type_writer {
    local message="$1"
    for (( i=0; i<${#message}; i++ )); do
        echo -n "${message:$i:1}"
        sleep 0.03
    done
    echo
}

# ================== Main Script Execution ==================

# Clear the screen
clear

# Display animated welcome message
echo "=============================================="
type_writer "🗃️  Welcome to Mohamed & Naira's DBMS Shell"
type_writer "🕒  Started at: $(date)"
echo "=============================================="

# Perform environment checks
check_required_dirs
check_write_permissions
create_workspace_if_not_exists

# Small pause before launching main menu
sleep 1

# Launch the main menu
./db_scripts/main_menu.sh
