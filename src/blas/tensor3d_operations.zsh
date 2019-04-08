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
#   padding
function tensor_splice()
{
    local d=$1
    local s_x=$2
    local s_y=$3
    local e_x=$((s_x + $4))
    local e_y=$((s_y + $5))
    local stride=$6
    local padding=$7

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
