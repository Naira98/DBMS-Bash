#! /bin/bash
# To start project $ source ./main.sh

# Open utils files as sourcing
utils=(validate_utils.sh output_utils.sh variables.sh)
for file in ${utils[@]}; do
    if [[ ! -f $file ]]; then
        echo "Error: $file not found."
    else
        source ./$file
    fi
done


if [[ ! -d $WORK_SPACE ]]; then
    mkdir ./$WORK_SPACE
    echo $WORK_SPACE created successfully
else
    echo $WORK_SPACE already exists. Let\'s start working on it.
fi

sleep 0.5

# Main Menu
source ./main_menu.sh