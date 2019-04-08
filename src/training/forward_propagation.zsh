#!/bin/zsh

function predict_dense()
{
    local dir="$1"
    local activation="$2" 
    local layerid="$3"

    matrix_mul  3< "${input_file}" \
                4< "${dir}/weights.dat" \
                 > "$(predict_name $layerid activity)"

    #matrix_add_inplace "$(predict_name $layerid activity)" "${dir}/bias_weights.dat" "$(predict_name $layerid activity)"

    matrix_apply activ_$activation < "$(predict_name $layerid activity)" \
                                   > "$(predict_name $layerid activation)"

    input_file="$(predict_name $layerid activation)"
}

function predict_convolution()
{
    local dir="$1"
    local activation="$2"
    local layerid="$3"
    local filter_count="$4"
    local stride="$5"
    local pad="$6"
    local kernel_w="$7"
    local kernel_h="$8"

    local i

    read w1 h1 d1 < "${input_file}"

    if (( pad == 0 ));
    then
        w1=$((w1 - w1 % kernel_w))
        h1=$((h1 - h1 % kernel_h))
    fi

    w1=$(( (w1 - kernel_w + 2 * pad) / stride + 1 ))
    h1=$(( (h1 - kernel_h + 2 * pad) / stride + 1 ))
    d1=$(( d1 * filter_count ))

    {
        echo $w1 $h1 $d1

        for ((i = 0; i < filter_count; i++));
        do
            tensor_apply_convolution $stride $pad $w1 $h1\
                    3< "${input_file}" 4< "${dir}/filter_$i.dat"
        done
    } > "$(predict_name $laerid activity)"

    input_file="$(predict_name $layerid activation)"
    tensor_apply activ_$activation < "$(predict_name $layerid activity)" \
                                   > "${input_file}"
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

    local i

    for ((i = 0; i < nb_layer; i++))
    do
        read activation layer_type custom < "$genome_dir/topology/layer_$i/meta.dat"
        predict_"$layer_type" "$genome_dir/topology/layer_$i" "$activation" "$i" $custom
    done
}
