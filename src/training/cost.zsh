source ./util/organization.zsh

function cost_mse()
{
    # Formula: 1/m*(Y-X)^2
    local x_path="${1}"
    local y_path="${2}"
    local batch_size=$3

    local temp1_name=$(tmp_name 1)
    local temp2_name=$(tmp_name 2)

    matrix_sub > "${temp1_name}" 3< "${y_path}" 4< "${x_path}"
    matrix_mul_self_p2p < "${temp1_name}" > "${temp2_name}"
    matrix_mul_scalar $(( 1.0 / $batch_size )) < "${temp2_name}"
}
