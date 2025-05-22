#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/output_utils.sh

db_name=$(select_from_databases "drop")

rm -rf "./$WORK_SPACE/$db_name"
echo_green "Database '$db_name' dropped successfully."
