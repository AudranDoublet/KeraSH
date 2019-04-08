#!/bin/zsh

function mutate_genome()
{
    local origin_genome_id=$1
    local new_genome_id=$2
    local generation_id=$3
    local model_name=$4

    local new_genome_path="${MODEL}/genomes/gen_${generation}_${new_genome_id}"
    mkdir -p "${new_genome_path}"

    cp "${MODEL}/genomes/gen_${origin_genome_id}/*" "${new_genome_path}/"

    local nb_layer=$(tac "${MODEL}/genomes/gen_${origin_genome_id}/meta.dat" | head -n 1)

    local target_layer_id=$(( (nb_layer - 1) * rand48() + 1 ))
    local mutation=MUTATIONS[$((int(rint( (${#MUTATIONS[@]} - 1) * rand48() + 1)) ))]
    "${mutation}" "${new_genome_id}" "${target_layer_id}"
}

function repopulate()
{
    local generation_id=$1
    local model_name=$2
    local population_size=$3
    local origin_genome_id=$4

    local i
    for (( i=0; i < ${population_size}; i++));
    do
        mutate "${origin_genome_id}" "${i}" "${generation_id}" "${model_name}"
    done
}

function evolve_from_scratch()
{
    local input_size=$1
    local output_size=$2
    local model_name=$3
    local input_file=$4
    local label_file=$5
    local population_size=$6
    local generation_nb=$7

    echo "${input_size} 1 1\ninput\ndense ${output_size} sigmoid" > "./model_temp.dat"
    store_model "${model_name}" "./model_temp.dat" "${input_file}" "${output_file}"
    create_genome "0_0" "${MODEL}/${model_name}.model"
    rm "./model_temp.dat"
    evolve_from_model "0_0" "${model_name}" "${population_size}" "${generation_nb}"
}

function evaluate()
{
    fit 100 "$i_$j" 16 8 1 0.15
    echo "${MODEL}/genomes/gen_$i_$j"
}

# Origin genome must be named '0_0'
function evolve_from_model()
{
    local best_genome_id=$1
    local model_name=$2
    local population_size=$3
    local generation_nb=$4

    local max_fitness=0.0
    # Generate initial population

    local i
    for ((i=0; i < "${generation_nb}"; i++));
    do
        repopulate $i "${model_name}" "${population_size}" "${best_genome_id}"
        local j
        for ((j=0; j < population_size; j++))
        do
            typeset -F fitness
            fitness = evaluate
            fitness = $((1.0 / fitness))
            if ((fitness > max_fitness));
            then
                best_genome_id="$i_$j"
            fi
        done
    done
    echo "${best_genome_id}"
}
