source ./util/organization.zsh

function cost_mse()
{
    # Formula: 1/m*(X-Y)^2
    local x_path="${1}"
    local y_path="${2}"
    local batch_size=$3

    local temp1_name=$(tmp_name 1)
    local temp2_name=$(tmp_name 2)

    matrix_sub > "${temp1_name}" 4< "${y_path}" 3< "${x_path}"
    matrix_mul_self_p2p < "${temp1_name}" > "${temp2_name}"
    matrix_mul_scalar $(( 1.0 / $batch_size )) < "${temp2_name}"
}

function cost_d_mse()
{
    # Formula (X-Y)
    local x_path="${1}"
    local y_path="${2}"
    local batch_size=$3

local temp1_name=$(tmp_name 1)

    matrix_sub > "${temp1_name}" 4< "${y_path}" 3< "${x_path}"
}
