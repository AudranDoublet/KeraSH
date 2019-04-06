#!/bin/zsh

function predict_dense()
{
    local dir="$1"
    local activation="$2" 
    local layerid="$3"

    matrix_mul  3< "${input_file}" \
                4< "${dir}/weights.dat" \
                 > "$(predict_name $layerid activity)"

    matrix_map activ_$activation < "$(predict_name $layerid activity)" \
                                 > "$(predict_name $layerid activation)"

    input_file="$(predict_name $layer activation)"
}

function predict_output()
{
    cp "$input_file" "$(predict_name 0 output)"
}

function predict_input()
{
    cp "$input_file" "$(predict_name $layer activation)"
}
