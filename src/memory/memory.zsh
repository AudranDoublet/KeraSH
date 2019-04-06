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
    local data_x=$3
    local data_y=$4

    mkdir -p "${MODEL}/"
    cp "${model_file}" "${MODEL}/${name}.model"

    generate_data "${data_x}" "${data_y}" "${name}"
}
