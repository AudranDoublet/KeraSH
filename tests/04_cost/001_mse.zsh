source ./blas/import.zsh
source ./training/cost.zsh
source ./memory/memory.zsh

matrix_create_direct 2 1 1 1 > ${TMP}/y
matrix_create_direct 2 1 0 0 > ${TMP}/x

if ! mpath=$(cost_mse "${TMP}/x" "${TMP}/y" 2 "test" 0 0 0 "test_cost");
then
    exit 1
fi

matrix_load < "${mpath}"

if ((array[1] != 0.5 || array[2] != 0.5))
then
    exit 2
fi

rm $mpath
exit 0
