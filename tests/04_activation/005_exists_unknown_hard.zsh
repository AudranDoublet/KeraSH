#!/bin/zsh

source ./training/activation.zsh

if activation_exists "lu";
then
    exit 1
fi

exit 0
