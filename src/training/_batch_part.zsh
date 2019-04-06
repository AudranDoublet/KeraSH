#!/bin/zsh

source ./kera.sh

mkdir -p "${MAT}/$$"
fit_batch_part "$@"
