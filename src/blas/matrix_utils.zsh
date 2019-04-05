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
