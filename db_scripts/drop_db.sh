#! /usr/bin/bash

set -e

source ./utils/select_from_databases_utils.sh
source ./utils/output_utils.sh
source ./utils/constants.sh

db_name=$(select_from_databases "drop")

rm -rf "./$WORK_SPACE/$db_name"
print_green "Database '$db_name' dropped successfully."
