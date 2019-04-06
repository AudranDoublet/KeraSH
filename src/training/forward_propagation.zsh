#!/bin/zsh

function predict_dense()
{
    local dir="$1"
    local activation="$2" 
    local layerid="$3"

    matrix_mul  3< "${input_file}" \
                4< "${dir}/weights.dat" \
                 > "$(predict_name $layerid activity)"

    matrix_apply activ_$activation < "$(predict_name $layerid activity)" \
                                   > "$(predict_name $layerid activation)"

    input_file="$(predict_name $layer activation)"
}

function predict_output()
{
    cp "$input_file" "$(predict_name 0 output)"
}

function predict_input()
{
    local layer="$3"
    cp "$input_file" "$(predict_name $layer activation)"
}

function predict()
{
    input_file=$1
    local genome_dir="${MODEL}/genomes/gen_$gen_id"

    matrix_load _ _ metadata < "${genome_dir}/meta.dat"

    nb_layer=${metadata[3]}

    for ((i = 0; i < nb_layer; i++));
    do
        read activation layer_type < "$genome_dir/topology/layer_$i/meta.dat"

        predict_"$layer_type" "$genome_dir/topology/layer_$i" "$activation" "$i"
    done
}
