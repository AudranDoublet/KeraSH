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
        v=(${sample})

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

function parse_dense()
{
    layer_activation=$2

    height="$width"
    width="$1"
}

function parse_input()
{
    layer_activation="-"
}

function parse_output()
{
    layer_activation="$1"
    height="$width"
}

function parse_model()
{
    local model_file=$1
    local genome_dir=$2

    read width height < "${model_file}"

    local layer_id=0
    local layer_path=""
    local last_layer_size=$input_size

    local layer_activation=""

    tail -n +2 "${model_file}" | while read layer_type layer_param;
    do
        layer_path="${genome_dir}/topology/layer_${layer_id}"
        mkdir -p "${layer_path}"

        parse_"$layer_type" $layer_param

        echo "${layer_activation} ${layer_type}" > "${layer_path}/meta.dat"

        matrix_random $width $height > "${layer_path}/weights.dat"
        matrix_random $width  1 > "${layer_path}/bias_weights.dat"
        layer_id=$(( layer_id + 1 ))
    done

    matrix_create_direct 3 1 $width $height $layer_id \
                                                > "${genome_dir}/meta.dat"
}
