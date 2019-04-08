#!/bin/zsh

source ./kera.sh

if ! tensor_create_direct 3 3 2 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 > ${TMP}/out;
then
    exit 1
fi

if ! tensor_slice 1 1 0 2 2 2 0 < ${TMP}/out > ${TMP}/out2;
then
    exit 2
fi

tensor_load w h d a < ${TMP}/out2

if (( w != 2 || h != 2 || d != 2 ));
then
    exit 3
fi

if (( a[1] != 5 || a[2] != 6 || a[3] != 8  || a[4] != 9 || a[5] != 14 || a[6] != 15 || a[7] != 17 || a[8] != 18));
then
    exit 4
fi
