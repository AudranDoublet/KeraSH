#!/bin/zsh

function fit_dense()
{
    local activation="$1"
    local layerid="$2"
    local out="$3"
    local nextlayer=$((layerid + 1))
    local prevlayer=$((layerid - 1))
    local dir="${MODEL}/genomes/gen_${gen_id}/topology/layer_$layerid"

    local gradients="$(predict_name $layerid gradients)"

    if (( $out == 1 ));
    then
        cost_d_mse $(predict_name $layerid activation) $label_file $batch_size > $(tmp_name 1)
        matrix_mul_scalar $(( -1.0 )) < $(tmp_name 1) > $(predict_name $nextlayer delta)
        cost_mse $(predict_name $layerid activation) $label_file $batch_size > $(predict_name $layerid cost)
    fi

    # S'(Zn)
    matrix_apply "activ_d_$activation" < $(predict_name $layerid activity) \
                                       > "$(tmp_name 2)"

    # DELTAn = DELTA(n+1) o S'(Zn)
    matrix_mul_p2p 3< "$(predict_name $nextlayer delta)"  4< "$(tmp_name 2)" > "$(tmp_name 4)"

    # A_t(n-1)
    matrix_transpose < "$(predict_name $prevlayer activation)" > "$(tmp_name 3)"

    # Gradient = A_t(n-1)*DELTAn
    matrix_mul 4< "$(tmp_name 4)" 3< "$(tmp_name 3)" > "$(tmp_name 2)"

    # Bias Gradient = DELTAn
    matrix_mul_scalar 1.0 < "$(tmp_name 4)" > "$(predict_name $layerid bias_gradients)"

    # Gradient sum
    matrix_add_inplace $gradients $(tmp_name 2) $gradients

    # DELTA(n) = DELTA(n) * W_Tn
    matrix_mul 3< "$(tmp_name 4)" 4< "$dir/weights_t.dat" \
                     > "$(predict_name $layerid delta)"
}

function fit_input()
{

}

#   Usage
#
# fit_sample <x_vec> <x_label>
function fit_sample()
{
    predict "$1"

    output_file="$(predict_name 0 output)"
    label_file=$2

    typeset -i i
    for ((i = nb_layer - 1; i >= 0; i--));
    do
        read activation layer_type < "$genome_dir/topology/layer_$i/meta.dat"

        if (( i == nb_layer - 1 ));
        then
            if matrix_similar $error_margin 3< "$(predict_name $i activation)" 4< "${label_file}";
            then
                matrix_create_direct 1 1 1.0 > $(tmp_name 1)
                matrix_add_inplace $(predict_name 0 accuracy) $(tmp_name 1) $(predict_name 0 accuracy)
            fi

            fit_"$layer_type" "$activation" "$i" 1
        else
            fit_"$layer_type" "$activation" "$i" 0
        fi
    done
    #echo "Input:"
    #cat < "$1"
    #echo "Output:"
    #cat < "$(predict_name 2 activation)"
    #echo "Expected:":
    #cat < "$2"
}

function fit_batch_part()
{
    gen_id=$1
    batch_size=$2

    shift 2

    matrix_create_direct 1 1 0.0 > $(predict_name 0 accuracy)

    local v
    for v in "$@";
    do
        fit_sample "${MODEL}/x_train/$v" "${MODEL}/y_train/$v"
    done
}

#   Usage
#
# Backpropagation for a batch
function fit_batch()
{
    local i
    local j
    for ((i = 0; i < nb_layer; i++));
    do
        local p="${MODEL}/genomes/gen_$gen_id/topology/layer_$i"
        matrix_transpose < "$p/weights.dat" > "$p/weights_t.dat"
    done

    # Fork nb_proc times in order to train a part of the batch
    pids=()
    for (( i = 0; i < nb_proc; i++ ));
    do
        beg=$((i * batch_size / nb_proc))
        en=$(((i + 1.0) * batch_size / nb_proc))
        en=$((int(rint(en))))

        if (( beg == en ));
        then 
            continue
        fi

        vec=()

        for (( j = beg; j < en; j++ ));
        do
            vec[$((j - beg + 1))]=$1
            shift 1
        done

        zsh ./training/_batch_part.zsh "$gen_id" "$batch_size" $vec &
        pids[$((i + 1))]="$!"
    done

    # Wait for all process
    wait $pids

    # Sum all gradients from all process for each layer
    for pid in $pids;
    do
        for (( i = 1; i < nb_layer; i++ ));
        do
            matrix_add_inplace "$(predict_name $i gradients)" \
                "${MAT}/$pid/${i}_gradients.dat" "$(predict_name $i gradients)"

            matrix_add_inplace "$(predict_name $i bias_gradients)" \
                "${MAT}/$pid/${i}_bias_gradients.dat" "$(predict_name $i bias_gradients)"
        done

        typeset -i last
        last=$((nb_layer-1))

        matrix_add_inplace "$(predict_name 0 cost)" \
                "${MAT}/$pid/${last}_cost.dat" "$(predict_name 0 cost)"

        matrix_add_inplace "$(predict_name 0 accuracy)" \
                "${MAT}/$pid/0_accuracy.dat" "$(predict_name 0 accuracy)"

        rm -rf "${MAT}/$pid/"
    done

    # Apply learning rate/gradient on each layer
    for (( i = 1; i < nb_layer; i++ ));
    do
        matrix_mul_scalar $(( 1.0 * learning_rate / batch_size)) \
                < "$(predict_name $i gradients)" > "$(tmp_name 0)"

        matrix_mul_scalar $(( 1.0 * learning_rate / batch_size)) \
                < "$(predict_name $i bias_gradients)" > "$(tmp_name 2)"

        matrix_add_inplace "$genome_dir/topology/layer_$i/weights.dat" "$(tmp_name 0)" "$genome_dir/topology/layer_$i/weights.dat"
        matrix_add_inplace "$genome_dir/topology/layer_$i/bias_weights.dat" "$(tmp_name 2)" "$genome_dir/topology/layer_$i/bias_weights.dat"
    done

    matrix_mul_scalar $(( 1.0 / batch_size )) < "$(predict_name 0 cost)" > "$(tmp_name 0)"
    cost=$(matrix_mean < "$(tmp_name 0)")
    echo "${cost}" > "${genome_dir}"

    accuracy=$(matrix_mean < $(predict_name 0 accuracy))
    accuracy=$((100 * accuracy / batch_size))

    printf "Epoch: %4i Batch: %4i cost: %f accuracy: %.1f%%\n" ${epoch_counter} ${batch_counter} "${cost}" "${accuracy}"
    rm -f ${MAT}/$$/*.dat
}

function fit_epoch()
{
    # Get features vector in a random order
    cd ${MODEL}/x_train
    local features=($(echo "$(ls)" | shuf)) 
    cd -

    local batch_counter=0
    local i
    for (( nb=${#features[@]}; nb > 0; nb -= batch_size ));
    do
        if (( nb < batch_size ));
        then
            batch_size=$nb
        fi

        local start=$((nb - batch_size))
        fit_batch ${features:$start:$nb}
        batch_counter=$(( batch_counter + 1))
    done
}

function fit()
{
    export epoch_count=$1
    export epoch_num=0
    export gen_id=$2
    export batch_size=$3
    export nb_proc=$4
    export learning_rate=$5
    export error_margin=$6
    export genome_dir="${MODEL}/genomes/gen_$gen_id"

    # Get model's layer count
    matrix_load _ _ metadata < "${genome_dir}/meta.dat"
    nb_layer=${metadata[3]}

    local epoch_counter=0
    local i
    for (( i = 0; i < epoch_count; i++ ));
    do
        fit_epoch
        epoch_counter=$((epoch_counter + 1))
    done
}
