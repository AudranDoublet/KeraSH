#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 3 2 -1 -2 -3 -4 -5 -6 > $TMP/out;
then
    exit 1
fi

if ! matrix_create_direct 3 2 9 3 7 -8 4 0 > $TMP/out2
then
    exit 2
fi

if ! matrix_sub > $TMP/res 3< $TMP/out 4< $TMP/out2;
then
    exit 3
fi

if ! matrix_load < $TMP/res;
then
    exit 4
fi

if ((width != 3 || height != 2));
then
    exit 5
fi

if ((      array[1] != -10 || array[2] != -5 || array[3] != -10
        || array[4] != 4 || array[5] != -9 || array[6] != -6));
then
    exit 6
fi

exit 0
