#!/bin/zsh

# Add a hidden layer with
# a random size
function add_layer()
{
    local genome_id=$1
    local nb_unit=rng
    local activation=rng

}

function resize_layer()
{
    local genome_id=$1
    local layer_id=$2
    local mutation_delta=$3

    local layer_to_mutate="${MODEL}/genomes/curr_generation/gen_${genome_id}/topology/layer_${layer_id}/"

    matrix_load w h < "${layer_to_mutate}/weights.dat"
    local new_width=$((w + mutation_delta))
    matrix_resize $new_width $h "${layer_to_mutate}/weights.dat"
    matrix_resize $w $new_width "${layer_to_update}/weights_t.dat"

    ensure_layers_compatibility "${genome_id}" "${layer_id}" "${mutation_delta}"
}

# Change activation function
# of a layer for a random other
function change_activation()
{
    local genome_id=$1
    local layer_id=$2

    local new_activation=rng
}

# Randomly scramble all weights
# in a layer
function scramble_layer()
{
    local genome_id=$1
    local layer_id=$1

    local factor=rng
}

# Randomly scramble a specific
# weight in a layer
local scramble_weight()
{
    local genome_id=$1
    local layer_id=$2

    local i=rng
    local j=rng
    local factor=rng
}
