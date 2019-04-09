source ./memory/memory.zsh
source ./util/data.zsh
source ./blas/import.zsh

function matrix_namer()
{
    local genome_name="${1}"
    local epoch_nb="${2}"
    local sample_id="${3}"
    local layer_id="${4}"
    local mat_type="${5}"

    echo "${genome_name}_${epoch_nb}_${layer_id}_${sample_id}_${mat_type}.dat"
}

function predict_name()
{
    local layer_id=$1
    local mat_type=$2

    echo "${MAT}/$$/${layer_id}_${mat_type}.dat"
}

function tmp_name()
{
    echo "${MAT}/$$/tmp/$1.dat"
}

function create_genome()
{
    local genome_name="${1}"
    local model_file="${2}"
    local genome_dir="${MODEL}/genomes/gen_${genome_name}"
    mkdir -p "${genome_dir}/topology"
    parse_model "${model_file}" "${genome_dir}"
}

function ensure_layers_compatibility()
{
    local genome_id=$1
    local curr_layer_id=$2
    local curr_layer_mutation_delta=$3

    local layer_to_update_id=$((curr_layer_id + 1))

    if [ -e "${MODEL}/genomes/gen_${genome_id}/topology/layer_$layer_to_update_id" ];
    then
        local layer_to_update="${MODEL}/genomes/gen_${genome_id}/topology/layer_${layer_to_update_id}/"
        local prev_layer="${MODEL}/genomes/gen_${genome_id}/topology/layer_$((layer_to_update_id - 1))/"

        matrix_load w h d < "${layer_to_update}/weights.dat"
        matrix_load w2 h2 d2 < "${prev_layer}/weights.dat"

        matrix_resize $w $w2 "${layer_to_update}/weights.dat"
        matrix_resize $w 1 "${layer_to_update}/bias_weights.dat"
    fi
}
