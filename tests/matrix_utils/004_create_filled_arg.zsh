#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_fill 2 2 12 > $TMP/out;
then
    exit 1
fi

if ! matrix_load < $TMP/out;
then
    exit 2
fi

if ((array[1] != 12 || array[2] != 12 || array[3] != 12 || array[4] != 12));
then
    exit 3
fi

exit 0
