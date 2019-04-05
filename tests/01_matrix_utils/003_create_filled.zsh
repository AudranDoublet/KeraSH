#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_fill 2 2 > $TMP/out;
then
    exit 1
fi

if ! matrix_load < $TMP/out;
then
    exit 2
fi

if ((array[1] != 1 || array[2] != 1 || array[3] != 1 || array[4] != 1));
then
    exit 3
fi

exit 0
