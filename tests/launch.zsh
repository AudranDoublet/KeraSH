#!/bin/zsh

function run_test()
{
    local ABS="$(pwd)/$1"

    cd ../src

    if zsh $ABS;
    then
        printf "%-60s \e[033mOK\e[0m\n" "$1"
    else
        printf "%-60s \e[091mKO (error code $?)\e[0m\n" "$1"
    fi

    cd ../tests
}

cd tests

for v in $(find -mindepth 2 -type f -name '*.zsh' | sort);
do
    run_test $v
done
