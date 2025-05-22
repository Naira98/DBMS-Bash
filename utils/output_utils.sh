#!/usr/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No Color

function echo_green {
    local message=$@
    echo -e "${GREEN}$message${NC}" > /dev/stderr
}

function echo_red {
    local message=$@
    echo -e "${RED}$message${NC}" > /dev/stderr
}
