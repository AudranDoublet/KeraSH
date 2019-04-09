#!/bin/zsh

MUTATIONS=(add_layer resize_layer)

# Add a hidden layer with
# a random size
function add_layer()
{
    local genome_id=$1
    nb_unit=$(( int(rint((20 - 4) * rand48() + 4)) ))
    local activation=${ACTIVATION_FUNCS[$((int(rint( (${#ACTIVATION_FUNCS[@]} - 1) * rand48() + 1)) ))]}

    local layer_meta="${activation} dense"

    local genome_path="${MODEL}/genomes/gen_${genome_id}/"

    local old_layer_nb=$(cat "${genome_path}/meta.dat" | tail -n1)

    local new_layer_id=$((int(rint(old_layer_nb-1))))

    # Incrementing output layer id
    mv "${genome_path}/topology/layer_$new_layer_id" "${genome_path}/topology/layer_$((new_layer_id + 1))"

    # Creating new layer
    mkdir -p "${genome_path}/topology/layer_${new_layer_id}"
    echo "${layer_meta}" > "${genome_path}/topology/layer_${new_layer_id}/meta.dat"

    # Determining number of inputs of new layer
    matrix_load nb_input old_layer_output_nb v  < "${genome_path}/topology/layer_$((int(rint(new_layer_id - 1))))/weights.dat"

    # Generating new layer weights
    matrix_random $nb_unit $nb_input > "${genome_path}/topology/layer_${new_layer_id}/weights.dat"
    matrix_random $nb_input $nb_unit > "${genome_path}/topology/layer_${new_layer_id}/weights_t.dat"
    matrix_random $nb_unit 1 > "${genome_path}/topology/layer_${new_layer_id}/bias_weights.dat"

    # Updating genome meta
    matrix_create_direct 3 1 0 0 1 > "./temp_mat"
    matrix_add_inplace "${genome_path}/meta.dat" "./temp_mat" "${genome_path}/meta.dat"
    rm "./temp_mat"

    ensure_layers_compatibility "${genome_id}" "${new_layer_id}" $((nb_unit - old_layer_output_nb - 1))
}

# Resize layer
function resize_layer()
{
    local genome_id=$1
    local layer_id=$2
    local mutation_delta=$(( (20 - 4) * rand48() + 4 ))

    local layer_to_mutate="${MODEL}/genomes/gen_${genome_id}/topology/layer_${layer_id}/"
    local layer_nb=$(cat "${MODEL}/genomes/gen_${genome_id}/meta.dat" | tail -n1)

    if (( layer_id + 1 == layer_nb ));
    then
        return 0
    fi

    matrix_load w h a < "${layer_to_mutate}/weights.dat"

    local new_width=$(( int(rint(w + mutation_delta))  ))

    matrix_resize $new_width $h "${layer_to_mutate}/weights.dat"
    matrix_resize $new_width 1 "${layer_to_mutate}/bias_weights.dat"

    ensure_layers_compatibility "${genome_id}" "${layer_id}" "${mutation_delta}"
}

# Change activation function
# of a layer for a random other
function change_activation()
{
    local genome_id=$1
    local layer_id=$2

    local genome_path="${MODEL}/genomes/gen_${genome_id}/"
    local new_activation=${ACTIVATION_FUNCS[$((int(rint( (${#ACTIVATION_FUNCS[@]} - 1) * rand48() + 1)) ))]}
    local layer_meta="${activation} dense"
    echo "${layer_meta}" > "${genome_path}/topology/layer_${layer_id}/meta.dat"
}
