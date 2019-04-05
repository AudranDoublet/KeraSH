#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 12 11 9 -4 > $TMP/out;
then
    exit 1
fi

if ! matrix_load < $TMP/out;
then
    exit 2
fi

if ((array[1] != 12 || array[2] != 11 || array[3] != 9 || array[4] != -4));
then
    exit 3
fi

exit 0
