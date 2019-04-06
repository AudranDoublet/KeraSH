#!/bin/zsh

function fit_dense()
{
    local dir="$1"
    local activation="$2"
    local layerid="$3"
    local nextlayer=$((layerid + 1))
    local prevlayer=$((layerid - 1))

    local gradients="$(predict_name $layerid gradients)"

    # Tmp = (DELTAn+1 * W_t(n+1)
    matrix_mult 3< "$(predict_name $nextlayer delta)" 4< "$dir/weights_t.dat" \
                 > $(tmp_file 1)

    # S'(Zn)
    matrix_apply "activ_d_$activation" < $(predict_name $layerid activity) \
                                       > "$(tmp_file 2)"

    # DELTAn = Tmp*S'(Zn)
    matrix_mul_p2p 3< "$(tmp_file 1)"  4< "$(tmp_file 2)" > "$(predict_name $layerid delta)"

    # A_t(n-1)
    matrix_transpose < "$(predict_name $prevlayer activation)" > "$(tmp_file 1)"

    # Gradient = DELTAn * A_t(n-1)
    matrix_mul 3< "$(predict_name $layerid delta)" 4< "$(tmp_file 1)" > "$(tmp_file 2)"

    # Gradient sum
    matrix_add_inplace $gradients $(tmp_file 2) $gradients
}

function fit_output()
{
    local cost="$2"
    local layerid="$3"

    local gradients="$(predict_name $layerid gradients)"

    cost_"$cost" $output_file $label_file $batch_size > $(predict_name $layerid delta)
    matrix_add_inplace $gradients $(predict_name $layerid delta) $gradients
}

#   Usage
#
# fit_sample <x_vec> <x_label>
function fit_sample()
{
    predict "$1"

    output_file="$(predict_name 0 output)"
    label_file=$2


    for ((i = nb_layer - 1; i >= 0; i--));
    do
        read activation layer_type < "$genome_dir/topology/layer_$i/meta.dat"

        fit_"$layer_type" "$genome_dir/topology/layer_$i" "$activation" "$i"
    done
}
