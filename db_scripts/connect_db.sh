#!/usr/bin/bash
set -e
source ./utils/selection_utils.sh
source ./utils/output_utils.sh

db_name=$(select_from_databases "connect")

echo_green "Connecting to '${db_name}' database..."

echo $db_name