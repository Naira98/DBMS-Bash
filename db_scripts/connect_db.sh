#!/usr/bin/bash

set -e

source ./utils/select_from_databases_utils.sh
source ./utils/output_utils.sh

db_name=$(select_from_databases "connect")

print_green "Connecting to '${db_name}' database..."

echo $db_name