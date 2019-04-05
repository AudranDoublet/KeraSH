#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create 3 6 > $TMP/out;
then
    exit 1
fi

if ! matrix_load < $TMP/out;
then
    exit 2
fi

if ((width != 3 || height != 6));
then
    exit 3
fi

exit 0
