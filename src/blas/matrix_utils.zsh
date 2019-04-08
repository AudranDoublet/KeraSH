#!/bin/zsh

zmodload zsh/mathfunc
zmodload zsh/mapfile

#   Usage
# print matrix from stdin in stdout
function matrix_print()
{
    matrix_load

    echo $width $height

    for ((y = 0; y < height; y++));
    do
        for ((x = 0; x < width; x++));
        do
            printf "%f " "${array[x + y * width + 1]}"
        done

        printf "\n"
    done
}

#   Usage
# load a matrix from stdin
#
# matrix_load <width:var (width)> <height:var (height)> <array:var (array)>
function matrix_load()
{
    if (($# == 0));
    then
        tensor_load
    elif (($# == 3))
    then
        tensor_load "$1" "$2" "_" "$3"
    else
        return 1
    fi
}

#   Usage
# print a new matrix in stdout
#
# matrix_create <width> <height>
function matrix_create()
{
    tensor_create $1 $2 1
}

#   Usage
# print a new matrix initialized with random values in stdout
#
# matrix_random <width> <height>
function matrix_random()
{
    tensor_random $1 $2 1
}

#   Usage
# print a new matrix initialized with a specified value
#
# matrix_create_fill <width> <height> <value:float (1)>
function matrix_create_fill()
{
    tensor_create_fill $1 $2 1 $3
}

#   Usage
#
# print a new matrix initialized with arguments 
# matrix_create_direct <width> <height> <floats...>
function matrix_create_direct()
{
    w=$1
    h=$2

    shift 2

    tensor_create_direct $w $h 1 "$@"
}
