#!/bin/zsh

#   Usage
#
# slice a tensor3d (stdin) in a tensor2d (stdout)
# Parameters:
#   depth
#   start_x
#   start_y
#   width
#   height
#   stride
#   pad
function tensor_slice()
{
    local s_x=$1
    local s_y=$2
    local s_z=$3
    local e_x=$((s_x + $4))
    local e_y=$((s_y + $5))
    local e_z=$((s_z + $6))
    local pad=$7

    tensor_load w h d a

    if (( e_x > w + pad || e_y > h + pad || e_z > d + pad ));
    then
        return 1
    fi

    local x
    local y
    local z

    echo "$4" "$5" "$6"

    for ((z = s_z; z < e_z; z++));
    do
        for ((y = s_y; y < e_y; y++));
        do
            for ((x = s_x; x < e_x; x++));
            do
                if ((x >= w || y >= h || z >= e_z));
                then
                    echo 0.0
                else
                    echo ${a[x + y*w + z*w*h + 1]}
                fi
            done
        done
    done
}

#   Usage
#
# Apply a convolution filter on tensor
# Parameters:
#   stride
#   pad
#   count (x) of kernel application
#   count (y) of kernel application
#
# Write on stdout
function tensor_apply_convolution()
{
    local stride=$1
    local pad=$2
    local count_x=$3
    local count_y=$4

    local f=$5

    local z=0 x=0 y=0

    read _w1 _h1 _d1 <&3
    read _w2 _h2 _d2 <&4

    if (( _d1 != _d2 ));
    then
        echo "tensor_apply_convolution: different depth" >&2
        return 1
    fi

    for (( z = 0; z < _d1; z++ ));
    do
        tensor_slice 0 0 $z $_w2 $_h2 1 1 0 <&4 > $(tmp_name 1)

        for (( y = 0; y < count_y; y++ ));
        do
            for (( x = 0; x < count_x; x++ ));
            do
                tensor_slice $((x * stride)) $((y * stride)) $z $_w2 $_h2 1 $pad <&3 > $(tmp_name 2)
                $f 3< $(tmp_name 1) 4< $(tmp_name 2)
            done
        done
    done
}

function tensor_apply_convreduce()
{
    local stride=$1
    local pad=$2
    local count_x=$3
    local count_y=$4
    local kernel=$5 

    local f=$6

    local z=0 x=0 y=0

    read _w1 _h1 _d1 <&3

    for (( z = 0; d < _d1; z++ ));
    do
        for (( y = 0; y < count_y; y++ ));
        do
            for (( x = 0; x < count_x; x++ ));
            do
                tensor_slice $((x * stride)) $((y * stride)) $z $kernel $kernel 1 $pad <&3 > $(tmp_name 1)
                $(echo $f) < $(tmp_name 1)
            done
        done
    done
}

#   Usage
#
# Reduce tensor (stdin) with function <f>
# Print result on stdout
#
# tensor_reduce <f>
function tensor_reduce()
{
    local f="$1"
    tensor_load w1 h1 d1 a1

    size=$((w1 * h1 * d1))

    typeset -F res="${a1[1]}"
    local i

    for ((i = 2; i <= size; i++));
    do
        res=$($f $res ${a1[i]})
    done

    echo $res
}

function tensor_apply()
{
    tensor_load w1 h1 d1 a1

    size=$((w1 * h1 * d1))
    echo $w1 $h1 $d1

    local i

    for ((i = 1; i <= size; i++));
    do
        $1 ${a1[i]}
    done
}

#   Usage
#
# Flatten STDIN tensor
# Write in STDOUT
function tensor_flatten()
{
    tensor_load
    tensor_create_direct $((width * height * depth)) 1 1 $array
}
