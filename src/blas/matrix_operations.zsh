#!/bin/zsh

#   Usage
#
# print sum of FD:3 and FD:4 matrix in stdout
function matrix_add()
{
    matrix_load w1 h1 a1 <&3
    matrix_load w2 h2 a2 <&4

    if (( w1 != w2 || h1 != h2 ));
    then
        echo "matrix_add: matrices have different size" >&2
        return 1
    fi

    size=$((w1 * h1))
    echo $w1 $h1

    for ((i = 1; i <= size; i++));
    do
        echo $((a1[i] + a2[i]))
    done
}


#   Usage
#
# print transposed STDIN matrix in STDOUT
function matrix_transpose()
{
    matrix_load w1 h1 a1

    echo $h1 $w1

    for ((x = 0; x < w1; x++));
    do
        for ((y = 0; y < h1; y++));
        do
            echo ${a1[x + y * size + 1]}
        done
    done
}
