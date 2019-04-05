generate_data()
{
    local file=$1
    local model=$2

    local sample_size=$(wc -l ${file})
    local train_samples=$((sample_size * 0.8))
    local sample_id=0

    while read x y
    do
        if [[ "${sample_id}" -lt "${train_samples}" ]]
        then
            x >> "${MODEL}/${model}/x_train.dat"
            y >> "${MODEL}/${model}/y_train.dat"
        else
            x >> "${MODEL}/${model}/x_val.dat"
            y >> "${MODEL}/${model}/y_val.dat"
        fi
    done < $file
}
