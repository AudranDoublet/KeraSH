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

function fit_batch_part()
{
    gen_id=$1
    batch_size=$2
    first_feature=$3
    last_feature=$4

    for (( i = first_feature; i < last_feature; i++ ))
    do
        fit_sample "${MODEL}/x_train/sample_$i.dat" "${MODEL}/y_train/sample_$i.dat"
    done
}

#   Usage
#
# Backpropagation for a batch
# Parameters:
#   genome id
#   batch size
#   number of processor
#   first feature
#   last feature
#   learniong rate
function fit_batch()
{
    local gen_id=$1
    local batch_size=$2
    local nb_proc=$3
    local first_feature=$4
    local last_feature=$((first_feature + batch_size))
    local learning_rate=$5

    local genome_dir="${MODEL}/genomes/gen_${$1}"

    # Get model's layer count
    matrix_load _ _ metadata < "${genome_dir}/meta.dat"
    local nb_layer=${metadata[3]}

    # Fork nb_proc times in order to train a part of the batch
    pids=()

    for (( i = 0; i < nb_proc; i++ ));
    do
        beg=$((i * batch_size / nb_proc))
        en=$(((i + 1) * batch_size / nb_proc - 1))

        clone $TTY 2> /dev/null >&2

        if (( $! == 0 ));
        then
            fit_batch_part "$gen_id" "$batch_size" "$beg" "$en"
            exit 0
        fi

        pids[$(i + 1)]=$!
    done

    # Wait for all process
    wait $pids

    # Sum all gradients from all process for each layer
    for pid in $pids;
    do
        for (( i = 0; i < nb_layers; i++ ));
        do
            matrix_add_inplace "$(predict_name $i gradients)" "${MAT}/$pid/${i}_gradients.dat"
        done
    done

    # Apply learning rate/gradient on each layer
    for (( i = 0; i < nb_layers; i++ ));
    do
        matrix_mul_scalar $((1.0 * learning_rate / batch_size)) \
                < "$(predict_name $i gradients)" > "$(tmp_file 0)"

        matrix_add_inplace "$genome_dir/topology/layer_$i/weights.dat" "$(tmp_file 0)"
    done
}
