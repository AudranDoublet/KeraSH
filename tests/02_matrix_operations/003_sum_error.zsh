#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 -1 -2 -3 -4 > $TMP/out;
then
    exit 1
fi

if ! matrix_create_direct 3 2 1 2 3 4 5 6 > $TMP/out2
then
    exit 2
fi

if matrix_add > $TMP/res 3< $TMP/out 4< $TMP/out2 2> /dev/null;
then
    exit 3
fi

exit 0
