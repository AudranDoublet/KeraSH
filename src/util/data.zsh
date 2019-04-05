zmodload zsh/mathfunc

generate_data()
{
    local file_x=$1
    local file_y=$2
    local model=$3

    local sample_size=$(wc -l ${file_x} | cut -d ' ' -f 1)
    local train_samples=$(( int(rint(sample_size * 0.8)) ))
    local sample_id=0

    while IFS="," read line;
    do
        v=($line)
        if (( ${sample_id} < ${train_samples} ))
        then
            for value in "${line[@]}"; do
                print "${value} " >> "${MODEL}/${model}/x_train.dat"
            done
        else
            for value in "${line[@]}"; do
                print "${value}" >> "${MODEL}/${model}/x_val.dat"
            done
        fi

        sample_id=$(( sample_id + 1 ))

    done < $file_x

    sample_id=0
    while IFS="," read line;
    do
        v=($line)
        if (( ${sample_id} < ${train_samples} ))
        then
            for value in "${v[@]}"; do
                print "${value} " >> "${MODEL}/${model}/y_train.dat"
            done
        else
            for value in "${v[@]}"; do
                print "${value}" >> "${MODEL}/${model}/y_val.dat"
            done
        fi

        sample_id=$(( sample_id + 1 ))

    done < $file_y
}
