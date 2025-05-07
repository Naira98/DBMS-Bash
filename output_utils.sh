#! /bin/bash

function print_success {
    local message=$1
    echo -e "${GREEN}$message${NC}"
}

function print_error {
    local message=$1
    echo -e "${RED}$message${NC}"
}

function clear_terminal {
    local path=$1

    sleep 1.5
    clear
    source $path
}