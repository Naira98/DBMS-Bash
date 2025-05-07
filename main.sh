#! /bin/bash
# To start project $ source ./main.sh

source ./variables.sh

if [[ ! -d $WORK_SPACE ]]; then
    mkdir ./$WORK_SPACE
    echo $WORK_SPACE created successfully
else
    echo $WORK_SPACE already exists. Let\'s start working on it.
fi

sleep 0.5

# Main Menu
source ./main_menu.sh