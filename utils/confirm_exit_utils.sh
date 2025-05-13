#! /bin/bash

source ./utils/output_utils.sh

function exit_confirmation {

    read -p "Do you really want to exit? (y/n): " confirm

    if [[ "$confirm" == [Yy] || "$confirm" == "" ]]; then
        print_blue "Exiting... Goodbye!"
        exit 0
    else
        print_blue "Back to main menu..."
    fi
}