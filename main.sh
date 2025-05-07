#! /bin/bash

# To start project $ source ./main.sh

work_space='DBMS'

if [[ ! -d $work_space ]]; then
    mkdir ./$work_space
    echo $work_space created successfully
else
    echo $work_space already exists. Let\'s start working on it.
fi

sleep 0.5

# Main Menu
source ./main_menu.sh