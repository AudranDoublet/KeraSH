source ./memory/memory.zsh
source ./util/data.zsh

function matrix_namer()
{
    local genome_name="${1}"
    local epoch_nb="${2}"
    local sample_id="${3}"
    local layer_id="${4}"
    local mat_type="${5}"

    echo "${genome_name}_${epoch_nb}_${layer_id}_${sample_id}_${mat_type}.dat"
}

function create_genome()
{
    local genome_name="${1}"
    local model_file="${2}"
    local genome_dir="${MODEL}/genomes/gen_${genome_name}"
    mkdir -p "${genome_dir}/topology"
    parse_model "${model_file}" "${genome_dir}"
    echo "${genome_dir}"
}
