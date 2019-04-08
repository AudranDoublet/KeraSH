#!/bin/zsh

source ./kera.sh

# Init filesystem and load kerash data
init_fs

# Core
store_model "xor" ../test_data/test_model ../test_data/test_data ../test_data/test_label
create_genome "xor" "${MODEL}/xor.model"

fit 1000 "xor" 4 4 10

# Backup data and end file system
#mkdir -p "./kerash_data"
#end_fs
