#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 -1 -2 -3 -4 > $TMP/out;
then
    exit 1
fi

if ! matrix_mul_scalar 2 > $TMP/res < $TMP/out;
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

if ((array[1] != -2 || array[2] != -4 || array[3] != -6 || array[4] != -8));
then
    exit 6
fi

exit 0
