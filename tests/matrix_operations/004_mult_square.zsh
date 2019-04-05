#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 -1 -2 -3 -4 > $TMP/out;
then
    exit 1
fi

if ! matrix_create_direct 2 2 1 2 3 4 > $TMP/out2
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

if ((array[1] != -7 || array[2] != -10 || array[3] != -15 || array[4] != -22));
then
    exit 6
fi

exit 0
