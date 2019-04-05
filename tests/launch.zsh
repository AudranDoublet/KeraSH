#!/bin/zsh

function run_test()
{
    local ABS="$(pwd)/$1"

    cd ../src

    if zsh $ABS;
    then
        printf "%-60s \e[033mOK\e[0m\n" "$1"
    else
        echo "$1 \e[088mKO\e[0m"
    fi

    cd ../tests
}

cd tests

for v in $(find -mindepth 2 -type f -name '*.zsh' | sort);
do
    run_test $v
done
