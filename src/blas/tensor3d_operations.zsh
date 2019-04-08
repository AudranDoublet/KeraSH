#!/bin/zsh

#   Usage
#
# splice a tensor3d (stdin) in a tensor2d (stdout)
# Parameters:
#   depth
#   start_x
#   start_y
#   width
#   height
#   stride
#   pad
function tensor_splice()
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

    echo "$4" "$5" 1

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
                    echo ${a[x + y*w + d*w*h + 1]}
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

    local d=0
    local x=0
    local y=0

    read w1 h1 d1 <&3
    read w2 h2 d2 <&4

    if (( d1 != d2 ));
    then
        echo "tensor_apply_convolution: different depth"
        return 1
    fi

    for (( d = 0; d < d1; d++ ));
    do
        tensor_splice 0 0 $d $w2 $h2 1 1 0 > $(tmp_name 1)

        for (( y = 0; y < count_y; y++ ));
        do
            for (( x = 0; x < count_x; x++ ));
            do
                tensor_splice $((x * stride)) $((y * stride)) $d $w2 $h2 1 $pad > $(tmp_name 2)
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

    local f=$5

    local d=0
    local x=0
    local y=0

    read w1 h1 d1 <&3
    read w2 h2 d2 <&4

    if (( d1 != d2 ));
    then
        echo "tensor_apply_convreduce: different depth"
        return 1
    fi

    for (( d = 0; d < d1; d++ ));
    do
        for (( y = 0; y < count_y; y++ ));
        do
            for (( x = 0; x < count_x; x++ ));
            do
                tensor_splice $((x * stride)) $((y * stride)) $d $w2 $h2 1 $pad > $(tmp_name 1)
                $f < $(tmp_name 1)
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
    f=$1
    tensor_load w1 h1 d1 a1

    size=$((w1 * h1 * d1))

    typeset -F res="${a1[i]}"
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
