zmodload zsh/mathfunc
source ./blas/import.zsh

function vectorize()
{
    local train_path=$1
    local val_path=$2

    local file=$3

    local train_samples=$4
    local sample_id=0

    setopt shwordsplit

    while read sample;
    do
        local IFS=,
        v=("${sample}")

        v_length="${#v[@]}"

        if (( ${sample_id} < ${train_samples} ))
        then
            matrix_create_direct $v_length 1 $v \
                > "${train_path}/sample_${sample_id}.dat"
        else
            matrix_create_direct $v_length 1 $v \
                > "${val_path}/sample_${sample_id}.dat"
        fi

        sample_id=$(( sample_id + 1 ))

    done < "${file}"

}

function generate_data()
{
    local file_x="${1}"
    local file_y="${2}"
    local model="${3}"

    local x_train_path="${MODEL}/x_train"
    local x_val_path="${MODEL}/x_val/"
    local y_train_path="${MODEL}/y_train/"
    local y_val_path="${MODEL}/y_val/"

    local sample_size=$(wc -l ${file_x} | cut -d ' ' -f 1)
    local train_samples=$(( int(rint(sample_size * 0.8)) ))

    mkdir -p "${x_train_path}"
    mkdir -p "${x_val_path}"
    mkdir -p "${y_train_path}"
    mkdir -p "${y_val_path}"

    vectorize "${x_train_path}" "${x_val_path}" "${file_x}" "${train_samples}"
    vectorize "${y_train_path}" "${y_val_path}" "${file_y}" "${train_samples}"
}

function parse_model()
{
    local model_file=$1
    local genome_dir=$2

    read x_y_sizes < "${model_file}"

    matrix_create_direct 2 1 ${x_y_sizes} > "${genome_dir}/meta.dat"
    matrix_load < "${genome_dir}/meta.dat"
    local input_size=$array[1]
    local output_size=$array[2]

    local layer_id=0
    local layer_path=""
    local last_layer_size=$input_size
    for layer_type layer_size layer_activation in $(tail -n +2 "${model_file}");
    do
        layer_path="${genome_dir}/topology/layer_${layer_id}_${layer_type}"
        mkdir -p "${layer_path}"
        echo "${layer_activation}\n${layer_type}" > "${layer_path}/meta.dat"
        matrix_random $layer_size $last_layer_size > "${layer_path}/weights.dat"
        last_layer_size=$layer_size
        layer_id=$(( layer_id + 1 ))
    done
}
