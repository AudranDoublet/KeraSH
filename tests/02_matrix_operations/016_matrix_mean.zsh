#!/bin/zsh

source ./blas/import.zsh

if ! matrix_create_direct 2 2 1 2 3 4 > $TMP/out;
then
    exit 1
fi

mean=$(matrix_mean < $TMP/out)

if (( abs(mean - 2.5) > 0.00001 ));
then
    exit 2
fi

exit 0
