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

if ! matrix_add > $TMP/res 3< $TMP/out 4< $TMP/out2;
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

if ((array[1] != 0 || array[2] != 0 || array[3] != 0 || array[4] != 0));
then
    exit 6
fi

exit 0
