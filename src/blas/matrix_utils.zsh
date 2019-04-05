#!/bin/zsh

zmodload zsh/mathfunc

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
        read width height
        array=($(<&0))
    elif (($# == 3))
    then
        read "$1" "$2"
        eval "$3=($(<&0))"
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
    if (($# != 2));
    then
        echo "matrix_create: bad usage" >&2
        return 1
    fi

    echo "$1 $2" # nb_lines, nb_col
}
