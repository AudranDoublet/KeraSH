zmodload zsh/mathfunc

generate_data()
{
    local file=$1
    local model=$2

    local sample_size=$(wc -l ${file} | cut -d ' ' -f 1)
    local train_samples=$(( int(rint(sample_size * 0.8)) ))
    local sample_id=0

    while IFS="," read x y
    do
        if (( ${sample_id} < ${train_samples} ))
        then
            echo $x >> "${MODEL}/${model}/x_train.dat"
            echo $y >> "${MODEL}/${model}/y_train.dat"
        else
            echo $x >> "${MODEL}/${model}/x_val.dat"
            echo $y >> "${MODEL}/${model}/y_val.dat"
        fi
        sample_id=$(( sample_id + 1 ))
    done < $file
}
