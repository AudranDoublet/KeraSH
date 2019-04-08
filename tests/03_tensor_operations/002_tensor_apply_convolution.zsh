#!/bin/zsh

source ./kera.sh

mkdir -p ./kerash_mountpoint/mat/$$/tmp

if ! tensor_create_direct 3 3 1 1 2 3 4 5 6 7 8 9 > ${TMP}/out;
then
    exit 1
fi

if ! tensor_create_direct 2 2 1 1 0 0 1 > ${TMP}/out2;
then
    exit 2
fi

{
    echo 3 3 1
    if ! tensor_apply_convolution 1 1 3 3 matrix_conv 3< ${TMP}/out 4< ${TMP}/out2;
    then
        exit 3
    fi
} > ${TMP}/out3

tensor_load w h d a < ${TMP}/out3

if (( w != 3 || h != 3 || d != 1 ));
then
    exit 3
fi

if ((      a[1] != 6  || a[2] != 8  || a[3] != 3 \
        || a[4] != 12 || a[5] != 14 || a[6] != 6 \
        || a[7] != 7  || a[8] != 8  || a[9] != 9));
then
    exit 4
fi
