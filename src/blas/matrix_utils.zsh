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
    local val=( "${(f)mapfile[/proc/self/fd/0]}" )

    if (($# == 0));
    then
        read width height <<< ${val[1]}
        array=( ${val:1} )
    elif (($# == 3))
    then
        read "$1" "$2" <<< ${val[1]}
        eval "$3=(${val:4})"
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

#   Usage
# print a new matrix initialized with random values in stdout
#
# matrix_random <width> <height>
function matrix_random()
{
    if ! matrix_create "$1" "$2"; then
        return 1
    fi

    size=$(($1*$2))

    local i
    for ((i = 0; i < size; i++));
    do
        echo $(( rand48() ))
    done
}

#   Usage
# print a new matrix initialized with a specified value
#
# matrix_create_fill <width> <height> <value:float (1)>
function matrix_create_fill()
{
    if ! matrix_create "$1" "$2"; then
        return 1
    fi

    local val
    typeset -F val

    if (($# != 3));
    then
        val=1.0
    else
        val="$3"
    fi

    size=$(($1*$2))

    local i
    for ((i = 0; i < size; i++));
    do
        echo "$val"
    done
}

#   Usage
#
# print a new matrix initialized with arguments 
# matrix_create_direct <width> <height> <floats...>
function matrix_create_direct()
{
    if ! matrix_create "$1" "$2"; then
        return 1
    fi

    local val
    typeset -F val

    size=$(($1*$2))

    shift 2

    local i
    for ((i = 0; i < size; i++))
    do
        if (($# > 0));
        then
            val=$1
            shift 1
        else
            val=0.
        fi

        echo $val
    done
}
