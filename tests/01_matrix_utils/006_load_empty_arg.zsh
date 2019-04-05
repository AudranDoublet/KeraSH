#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 3 12 11 9 -4 3 1 > $TMP/out;
then
    exit 1
fi

if ! matrix_load w h a < $TMP/out;
then
    exit 2
fi

if ((w != 2 || h != 3));
then
    exit 3
fi

if ((a[1] != 12 || a[2] != 11 || a[3] != 9 || a[4] != -4 || a[5] != 3
        || a[6] != 1));
then
    exit 4
fi

exit 0
