#!/bin/zsh

source ./memory/memory.zsh
source ./blas/import.zsh
source ./util/data.zsh
source ./util/organization.zsh

# Init filesystem and load kerash data
init_fs

# Core
store_model "test" ../tests/test_model ../tests/test_data ../tests/test_label
create_genome "test" "${MODEL}/test.model"

# Backup data and end file system
#mkdir -p "./kerash_data"
#end_fs
