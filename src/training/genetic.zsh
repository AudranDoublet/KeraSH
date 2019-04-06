#!/bin/zsh

# current generation vars
#
generation=() # should be only names
generation_size=0
overall_best=0.0


# genetic configuration

parent_count=0 # parent count for each generation
evaluate_parent="" # evaluate parent function
create_child="" # create child function
delete_old_gen="" # delete old generation and put new one function


#   Usage
#
# Should be only used by genetic_mk_gens
# Get scores of each elements of the generation and create a new one with prents
#
# genetic_mk_gen <num> <total>
function genetic_mk_gen()
{
    local i=1
    local p1
    local p2

    local parents="$( (
        for p in $generation;
        do
            echo $("$evaluate_parent" "$p") $p
            $((i += 1))
        done
    ) | sort -g -r | head -n"$parent_count")"

    local b=$(echo "$parents" | head -n1 | cut -d' ' -f1)

    if (( b < overall_best ));
    then
        overall_best=b
        printf "Generation $1/$2: \e[032mNEW BEST: $b\e[0m\n"
    else
        echo "Generation $1/$2: generation_best=$b, overall_best=$overall_best"
    fi

    local parents="$(echo "$parents" | cut -d' ' -f2-)"

    for (( i = 1; i < generation_size; i++ ));
    do
        echo "$parents" | shuffle | head -n1 | read p1
        echo "$parents" | shuffle | head -n1 | read p2

        $generation[$i]="$( "$create_child" "$p1" "$p2" )"
    done

    $delete_old_gen
}

#   Usage
#
# Process multiple generation
#
# genetic_mk_gens <count> <parents...>
function genetic_mk_gens()
{
    local total=$1
    shift 1

    overall_best=0.0
    generation=("$@")
    generation_size="$#"

    for ((i = 1; i <= $1; i++));
    do
        process_generation "$i" "$1"
    done
}
