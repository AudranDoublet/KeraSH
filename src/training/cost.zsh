function matrix_namer()
{
    local genotype_name="${1}"
    local epoch_nb="${2}"
    local sample_id="${3}"
    local layer_id="${4}"
    local mat_type="${5}"

    echo "${genotype_name}_${epoch_nb}_${layer_id}_${sample_id}_${mat_type}.dat"
}

function cost_mse()
{
    # Formula: 1/m*(Y-X)^2
    local x_path="${1}"
    local y_path="${2}"
    local batch_size=$3
    local temp1_name=$(matrix_namer "${4}" $5 $6 $7 "cost_temp1")
    local temp2_name=$(matrix_namer "${4}" $5 $6 $7 "cost_temp2")
    local output_name=$(matrix_namer "${4}" $5 $6 $7 "cost")
    matrix_sub > "${MAT}/${temp1_name}" 3< "${y_path}" 4< "${x_path}"
    matrix_mul_self_p2p < "${MAT}/${temp1_name}" > "${MAT}/${temp2_name}"
    matrix_mul_scalar $(( 1.0 / $batch_size )) < "${MAT}/${temp2_name}" > "${MAT}/${output_name}"

    echo "${MAT}/${output_name}"
}
