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
    local d=$1
    local s_x=$2
    local s_y=$3
    local e_x=$((s_x + $4))
    local e_y=$((s_y + $5))
    local stride=$6
    local pad=$7

    tensor_load w h d a

    if ((padding == 0 && (e_x >= w || e_y >= h)));
    then
        return 1
    fi

    local x
    local y

    echo "$4" "$5" 1

    for ((y = s_y; y < e_y; y++));
    do
        for ((x = s_x; x < e_x; x++));
        do
            if ((x >= w || y >= h));
            then
                echo 0.0
            else
                echo ${a[x + y*w + d*w*h + 1]}
            fi
        done
    done
}

function tensor_apply_convolution()
{
    local splice=$1
    local pad=$2

    local d=0
    local x=0
    local y=0

    tensor_load w1 h1 d1 a1 <&3
    tensor_load w2 h2 d2 a2 <&3

    if (( d1 != d2 ));
    then
        echo "tensor_apply_convolution: different depth"
        return 1
    fi

    for (( d = 0; d < d1; d++ ));
    do
        tensor_splice 0 0 $w2 $h2 1 0 > $(tmp_name 1)

        for (( y = 0; y < h1; y++ ));
        do
            for (( x = 0; x < w1; x++ ));
            do
                tensor_splice x y $w2 $h2 "$splice" "$pad" > $(tmp_name 2)
                matrix_conv 3< $(tmp_name 1) 4< $(tmp_name 2)
            done
        done
    done
}
