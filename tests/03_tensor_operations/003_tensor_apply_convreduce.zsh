#!/bin/zsh

source ./kera.sh

mkdir -p ./kerash_mountpoint/mat/$$/tmp

if ! tensor_create_direct 3 3 1 1 2 3 4 5 6 7 8 9 > ${TMP}/out;
then
    exit 1
fi

{
    echo 2 2 1
    if ! tensor_apply_convreduce 2 1 2 2 2 "tensor_reduce g_max" 3< ${TMP}/out;
    then
        exit 3
    fi
} > ${TMP}/out3

tensor_load w h d a < ${TMP}/out3

if (( w != 2 || h != 2 || d != 1 ));
then
    exit 3
fi

if ((      a[1] != 5 || a[2] != 6 \
        || a[3] != 8 || a[4] != 9));
then
    exit 4
fi
