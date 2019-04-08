#!/bin/zsh

g_max()
{
    echo $(( $1 < $2 ? $2 : $1 ))
}
