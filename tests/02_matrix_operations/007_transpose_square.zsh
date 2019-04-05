#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 -1 -2 -3 -4 > $TMP/out;
then
    exit 1
fi

if ! matrix_transpose > $TMP/res < $TMP/out;
then
    exit 2
fi

if ! matrix_load < $TMP/res;
then
    exit 3
fi

if ((width != 2 || height != 2));
then
    exit 4
fi

if ((array[1] != -1 || array[2] != -3 || array[3] != -2 || array[4] != -4));
then
    exit 6
fi

exit 0
