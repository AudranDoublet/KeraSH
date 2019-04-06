#!/bin/zsh

source ./kera.sh
mkdir -p "${MAT}/$$/tmp"

fit_batch_part "$@"
