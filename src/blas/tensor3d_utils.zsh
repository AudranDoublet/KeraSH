#!/bin/zsh

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
