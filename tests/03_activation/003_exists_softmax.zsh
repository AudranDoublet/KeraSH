#!/bin/zsh

source ./training/activation.zsh

if ! activation_exists "relu";
then
    exit 1
fi

exit 0
