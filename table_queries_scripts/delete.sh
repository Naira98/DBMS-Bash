#! /usr/bin/bash

source ./utils/queries_utils.sh
source ./utils/select_from_columns_utils.sh

set -e

PS3="Choose an option: "

query="DELETE FROM $table_name WHERE condition"

$(ask_for_condition "" "delete" "$query")    