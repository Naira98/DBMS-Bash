#! /bin/bash

# Get the location where we run file
export RUNNING_DIR=$(pwd)

# Get the current script's directory and cd into it
cd "$(dirname "${BASH_SOURCE[0]}")"
export SCRIPT_DIR="$(pwd)"

source ./output_utils.sh
source ./variables.sh

if [[ ! -d $WORK_SPACE ]]; then
    mkdir ./$WORK_SPACE
    print_success "$WORK_SPACE created successfully."
else
    print_success "$WORK_SPACE already exists. Let's start working on it."
fi

sleep 1

# Main Menu
./main_menu.sh