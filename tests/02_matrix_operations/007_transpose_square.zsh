#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 3 3 -1 -2 -3 -4 -5 -6 -7 -8 -9 > $TMP/out;
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

if ((width != 3 || height != 3));
then
    exit 4
fi

if ((      array[1] != -1 || array[2] != -4 || array[3] != -7
        || array[4] != -2 || array[5] != -5 || array[6] != -8
        || array[7] != -3 || array[8] != -6 || array[9] != -9));
then
    exit 6
fi

exit 0
