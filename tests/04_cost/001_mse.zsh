source ./blas/import.zsh
source ./training/import.zsh
source ./util/organization.zsh
source ./memory/memory.zsh

mkdir -p ./kerash_mountpoint/mat/$$/tmp

matrix_create_direct 2 1 1 1 > ${TMP}/y
matrix_create_direct 2 1 0 0 > ${TMP}/x

if ! cost_mse "${TMP}/x" "${TMP}/y" 2 "test" 0 0 0 "test_cost" > $(tmp_name 3);
then
    exit 1
fi

matrix_load < "$(tmp_name 3)"

if ((array[1] != 0.5 || array[2] != 0.5))
then
    exit 2
fi

exit 0
