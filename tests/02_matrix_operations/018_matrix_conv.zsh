#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 3 3 1 2 3 4 5 6 7 8 9 > $TMP/out;
then
    exit 1
fi

if ! matrix_create_direct 3 3 1 0 1 0 1 0 1 0 1 > $TMP/out2
then
    exit 2
fi

v=$(matrix_conv 3< $TMP/out 4< $TMP/out2)

if (( v != 25.0 ));
then
    exit 3
fi

exit 0
