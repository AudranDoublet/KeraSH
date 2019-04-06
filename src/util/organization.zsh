function matrix_namer()
{
    local genotype_name="${1}"
    local epoch_nb="${2}"
    local sample_id="${3}"
    local layer_id="${4}"
    local mat_type="${5}"

    echo "${genotype_name}_${epoch_nb}_${layer_id}_${sample_id}_${mat_type}.dat"
}
