#! /bin/bash

source ./utils/constants.sh

function print_green {
    local message=$1
    echo -e "${GREEN}$message${NC}"
}

function print_red {
    local message=$1
    echo -e "${RED}$message${NC}"
}

function print_blue {
    local message=$1
    echo -e "${BLUE}$message${NC}"
}

function clear_after_1.5_sec {
    sleep 1.5
    clear
}