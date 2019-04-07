#!/bin/zsh

# Add a hidden layer with
# a random size
function add_layer()
{
    local genome_id=$1
    local nb_unit=rng
    local activation=rng

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
