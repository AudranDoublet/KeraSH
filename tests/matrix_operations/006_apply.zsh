#!/bin/zsh

source ./blas/import.zsh

function f()
{
    echo $((fabs($1)))
}

if ! matrix_create_direct 2 2 -1 -2 -3 -4 > $TMP/out;
then
    exit 1
fi

if ! matrix_apply f > $TMP/res < $TMP/out;
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

if ((array[1] != 1 || array[2] != 2 || array[3] != 3 || array[4] != 4));
then
    exit 6
fi

exit 0
