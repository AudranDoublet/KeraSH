#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 3 -1 -2 -3 -4 -5 -6 > $TMP/out;
then
    exit 1
fi

if ! matrix_create_direct 2 3 1 2 3 4 5 6 > $TMP/out2
then
    exit 2
fi

if ! matrix_mul_p2p > $TMP/res 3< $TMP/out 4< $TMP/out2;
then
    exit 3
fi

if ! matrix_load < $TMP/res;
then
    exit 4
fi

if ((width != 2 || height != 3));
then
    exit 5
fi

if ((array[1] != -1 || array[2] != -4 || array[3] != -9
        || array[4] != -16 || array[5] != -25 || array[6] != -36));
then
    exit 6
fi

exit 0
