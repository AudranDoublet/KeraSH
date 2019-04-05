#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 3 2 6 5 4 3 2 1 > $TMP/out;
then
    exit 1
fi

if ! matrix_create_direct 2 3 1 2 3 4 5 6 > $TMP/out2
then
    exit 2
fi

if ! matrix_mul > $TMP/res 3< $TMP/out 4< $TMP/out2;
then
    exit 3
fi

if ! matrix_load < $TMP/res;
then
    exit 4
fi

if ((width != 2 || height != 2));
then
    exit 5
fi

if ((array[1] != 41 || array[2] != 56 || array[3] != 14 || array[4] != 20));
then
    exit 6
fi

exit 0
