#!/bin/zsh

function predict_dense()
{

    matrix_load w h input < 
}

function predict()
{
    input_file=$2
    tmp="${MAT}/$!"

    local genome_dir="${MODELS}/genomes/gen_${$1}"
    matrix_load _ _ metadata < "${genome_dir}/meta.dat"

    nb_layer=${metadata[3]}

    for ((i = 0; i < nb_layer; i++));
    do
        read activation layer_type < "$genome_dir/topology/layer_$i/meta.dat"

        "$predict"_"$layer_type" "$genome_dir/topology/layer_$i" \
                "$activation" "$input_file" "$tmp"
    done
}
