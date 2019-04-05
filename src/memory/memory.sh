MOUNTPOINT="./kerash_mountpoint"
MAT="./kerash_mountpoint/mat"
MODEL="./kerash_mountpoint/models/"

init_fs()
{
    mkdir -p "${MOUNTPOINT}"
    sudo mount -t tmpfs -o size="${1}m" tmpfs "${MOUNTPOINT}"
    mkdir -p "${MAT}"
    mkdir -p "${MODEL}"
}

end_fs()
{
    sudo umount "${MOUNTPOINT}"
    rm -rf "${MOUNTPOINT}"
}

free_matrix()
{
    rm -f "${MAT}/${1}.mat"
}

store_model()
{
    local name=$1
    local model_file=$2
    local data_file=$3

    local model_path="${MODEL}/${name}"
    mkdir -p "${model_path}"
    cp "${model_file}" "${model_path}"

    source ./util/data.sh
    generate_data "${data_file}" "${name}"
}
