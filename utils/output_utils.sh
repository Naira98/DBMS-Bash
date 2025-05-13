#! /bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

function type_writer {
    local message="$1"
    for (( i=0; i<${#message}; i++ )); do
        echo -n "${message:$i:1}"
        sleep 0.03
    done
    echo
}

function print_green {
    local message=$@
    echo -e "${GREEN}$message${NC}" > /dev/stderr
}

function print_red {
    local message=$@
    echo -e "${RED}$message${NC}" > /dev/stderr
}

function print_blue {
    local message=$@
    echo -e "${BLUE}$message${NC}" > /dev/stderr
}

# function clear_after_1.5_sec {
#     sleep 1.5
#     clear
# }