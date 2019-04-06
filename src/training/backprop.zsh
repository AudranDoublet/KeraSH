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
