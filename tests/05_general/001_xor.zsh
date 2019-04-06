#!/bin/zsh

source ./kera.sh

# Init filesystem and load kerash data
init_fs

# Core
store_model "xor" ../test_data/test_model ../test_data/test_data ../test_data/test_label
create_genome "xor" "${MODEL}/xor.model"

# Backup data and end file system
#mkdir -p "./kerash_data"
#end_fs