#!/bin/zsh

export TMP="$(mktemp -d)"

mkdir -p ./src/kerash_mountpoint/mat

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

if (( $# == 1 ));
then
    for v in "$@";
    do
        run_test $v
    done
else
    for v in $(find -mindepth 2 -type f -name '*.zsh' | sort);
    do
        run_test $v
    done
fi

cd ..

#rm -rf ./src/kerash_mountpoint
