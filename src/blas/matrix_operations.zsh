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
# print substraction of FD:3 and FD:4 matrix in stdout
function matrix_sub()
{
    matrix_load w1 h1 a1 <&3
    matrix_load w2 h2 a2 <&4

    if (( w1 != w2 || h1 != h2 ));
    then
        echo "matrix_sub: matrices have different size" >&2
        return 1
    fi

    size=$((w1 * h1))
    echo $w1 $h1

    for ((i = 1; i <= size; i++));
    do
        echo $((a1[i] - a2[i]))
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
            echo ${a1[x + y * w1 + 1]}
        done
    done
}

#   Usage
#
# print STDIN matrix muliplied by a scalar
# matrix_mul <scalar>
function matrix_mul_scalar()
{
    matrix_load w1 h1 a1

    local scalar
    typeset -F scalar
    scalar=$1

    size=$((w1 * h1))
    echo $w1 $h1

    for ((i = 1; i <= size; i++));
    do
        echo $((a1[i] * scalar))
    done
}

#  Usage
#
# point-to-point multiplication of matrix A (fd: 3) and B (fd: 4)
# print on stdout
function matrix_mul_p2p()
{
    matrix_load w1 h1 a1 <&3
    matrix_load w2 h2 a2 <&4

    if (( w1 != w2 || h1 != h2 ));
    then
        echo "matrix_mul_p2p: matrices have different size"
        return 1
    fi

    size=$((w1 * h1))
    echo $w1 $h1

    for ((i = 1; i <= size; i++));
    do
        echo $((a1[i] * a2[i]))
    done
}

#  Usage
#
# multiplication of matrix A (fd: 3) and B (fd: 4)
# print on stdout
function matrix_mul()
{
    matrix_load w1 h1 a1 <&3
    matrix_load w2 h2 a2 <&4

    if (( w1 != h2 ));
    then
        echo "matrix_mul: matrix A width <> matrix B height" >&2
        return 1
    fi

    local sum
    float sum

    echo $w2 $h1

    for ((i = 0; i < h1; i++));
    do
        for ((j = 0; j < w2; j++));
        do
            sum=0.

            for ((k = 0; k < w1; k++));
            do
                ((sum += a1[k + i * w1 + 1] * a2[j + k * w2 + 1]))
            done

            echo "$sum"
        done
    done
}

#  Usage
#
# square of matrix A (fd: stdin)
# print on stdout
function matrix_square()
{
    matrix_load w1 h1 a

    if (( w1 != h1 ));
    then
        echo "matrix_square: matrix width <> height" >&2
        return 1
    fi

    local sum
    float sum

    echo $w1 $h1

    for ((i = 0; i < h1; i++));
    do
        for ((j = 0; j < w1; j++));
        do
            sum=0.

            for ((k = 0; k < w1; k++));
            do
                ((sum += a1[k + i * w1 + 1] * a2[j + k * w1 + 1]))
            done

            echo "$sum"
        done
    done
}

#   Usage
#
# apply function to all elements of matrix A (stdin)
# print on stdout
function matrix_apply()
{
    matrix_load w1 h1 a1

    size=$((w1 * h1))
    echo $w1 $h1

    for ((i = 1; i <= size; i++));
    do
        $1 ${a1[i]}
    done
}
