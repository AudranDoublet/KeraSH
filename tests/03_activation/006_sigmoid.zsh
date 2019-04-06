#!/bin/zsh

zmodload zsh/mathfunc

source ./training/activation.zsh

EPSILON=0.0001

function compare_floats()
{
    if (( abs($1 -$2) <= EPSILON ));
    then
        return 0
    fi

    return 1
}

if ! compare_floats $(activ_sigmoid 0.5) 0.6224593312018545646389;
then
    exit 1
fi

if ! compare_floats $(activ_sigmoid 0) 0.5;
then
    exit 2
fi

if ! compare_floats $(activ_sigmoid 1) 0.7310585786300048792512;
then
    exit 3
fi
