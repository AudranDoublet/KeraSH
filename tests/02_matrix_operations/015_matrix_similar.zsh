#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 1 2 3 4 > $TMP/out;
then
    exit 1
fi

if ! matrix_create_direct 2 2 1 2 3 4.2 > $TMP/out2
then
    exit 2
fi

if ! matrix_similar 0.25 3< $TMP/out 4< $TMP/out2;
then
    exit 3
fi

if matrix_similar 0.0 3< $TMP/out 4< $TMP/out2;
then
    exit 4
fi

exit 0
