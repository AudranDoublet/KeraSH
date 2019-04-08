#!/bin/zsh

source ./training/activation.zsh

if activation_exists "aaabbbccc";
then
    exit 1
fi

exit 0
