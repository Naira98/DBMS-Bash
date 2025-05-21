#!/usr/bin/bash

source ./utils/output_utils.sh

shopt -s extglob

function confirm_exit {
    local exit_status=$1

    echo > /dev/stderr
    read -rp "Do you really want to exit? (y/n): " confirm

    if [[ "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ || "$confirm" == "" ]]; then
        print_blue "Exiting... Goodbye!"
        echo > /dev/stderr
        exit $exit_status
    fi
}