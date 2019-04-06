#!/bin/zsh

source ./memory/memory.zsh
source ./blas/import.zsh
source ./util/data.zsh
source ./util/organization.zsh

# Init filesystem and load kerash data
init_fs

# Core
store_model "test" ./test_model ./test_data ./test_label
create_genome "test" "${MODEL}/test.model"

# Backup data and end file system
#mkdir -p "./kerash_data"
#end_fs
