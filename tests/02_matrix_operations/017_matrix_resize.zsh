#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 1 2 3 4 > $TMP/out;
then
    exit 1
fi

matrix_resize 1 3 "${TMP}/out"
matrix_load w h a < "${TMP}/out"

if (( w != 1 || h != 3));
then
    exit 2
fi

if (( a[1] != 1 || a[2] != 2));
then
    exit 3
fi
