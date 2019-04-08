#!/bin/zsh

#   Usage
#
# load tensor from STDIN
#
# tensor_load <width (def: width)> <height (def: height)> <depth (def: depth)>
function tensor_load()
{
    local val=( "${(f)mapfile[/proc/self/fd/0]}" )

    if (($# == 0));
    then
        read width height depth <<< ${val[1]}
        array=( ${val:1} )
    elif (($# == 4))
    then
        read "$1" "$2" "$3" <<< ${val[1]}
        eval "$4=(${val:6})"
    else
        return 1
    fi
}

#   Usage
#
# write a new tensor in STDOUT
#
# tensor_create <width> <height> <depth>
function tensor_create()
{
    if (($# != 3));
    then
        echo "tensor_create: bad usage" >&2
        return 1
    fi

    echo "$1" "$2" "$3"
}

#   Usage
#
# write a new random tensor in STDOUT
#
# tensor_random <width> <height> <depth>
function tensor_random()
{
    if ! tensor_create $1 $2 $3; then
        return 1
    fi

    size=$(($1*$2*$3))

    local i
    for ((i = 0; i < size; i++));
    do
        echo $(( rand48() ))
    done
}

#   Usage
#
# write a new tensor in STDOUT, filled with 1 or parameters.
#
# tensor_create_fill <width> <height> <depth> <value (def: 1.0)>
function tensor_create_fill()
{
    if ! tensor_create $1 $2 $3; then
        return 1
    fi

    local val
    typeset -F val

    if (($# != 4));
    then
        val=1.0
    else
        val="$4"
    fi

    size=$(($1*$2*$3))

    local i
    for ((i = 0; i < size; i++));
    do
        echo "$val"
    done
}

#   Usage
#
# write a new tensor in STDOUT, filled with parameters
#
# tensor_create_direct <width> <height> <depth> <values...>
function tensor_create_direct()
{
    if ! tensor_create $1 $2 $3; then
        return 1
    fi

    local val
    typeset -F val

    size=$(($1 * $2 * $3))

    shift 3

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
