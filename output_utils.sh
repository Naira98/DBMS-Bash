#! /bin/bash

source ./variables.sh

function print_success {
    local message=$1
    echo -e "${GREEN}$message${NC}"
}

function print_error {
    local message=$1
    echo -e "${RED}$message${NC}"
}

function clear_after_1.5_sec {
    sleep 1.5
    clear
}