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
        IFS=,
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

    local x_train_path="${MODEL}/${model}/x_train"
    local x_val_path="${MODEL}/${model}/x_val/"
    local y_train_path="${MODEL}/${model}/y_train/"
    local y_val_path="${MODEL}/${model}/y_val/"

    local sample_size=$(wc -l ${file_x} | cut -d ' ' -f 1)
    local train_samples=$(( int(rint(sample_size * 0.8)) ))

    mkdir -p "${x_train_path}"
    mkdir -p "${x_val_path}"
    mkdir -p "${y_train_path}"
    mkdir -p "${y_val_path}"

    vectorize "${x_train_path}" "${x_val_path}" "${file_x}" "${train_samples}"
    vectorize "${y_train_path}" "${y_val_path}" "${file_y}" "${train_samples}"
}
