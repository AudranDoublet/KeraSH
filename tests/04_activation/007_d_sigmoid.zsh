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

if ! compare_floats $(activ_d_sigmoid 0.5) 0.2350037122015944890693;
then
    exit 1
fi

if ! compare_floats $(activ_d_sigmoid 0) 0.25;
then
    exit 2
fi

if ! compare_floats $(activ_d_sigmoid 1) 0.1966119332414818525374;
then
    exit 3
fi
