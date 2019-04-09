#!/bin/zsh

source ./kera.sh

init_fs

evolve_from_scratch 2 1 xor_ev ../test_data/test_data ../test_data/test_label 1 3
