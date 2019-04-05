zmodload zsh/mathfunc

generate_data()
{
    local file_x=$1
    local file_y=$2
    local model=$3

    local x_train_path="${MODEL}/${model}/x_train.dat"
    local x_val_path="${MODEL}/${model}/x_val.dat"
    local y_train_path="${MODEL}/${model}/y_train.dat"
    local y_val_path="${MODEL}/${model}/y_val.dat"

    local sample_size=$(wc -l ${file_x} | cut -d ' ' -f 1)
    local train_samples=$(( int(rint(sample_size * 0.8)) ))
    local sample_id=0

    setopt shwordsplit

    while read line;
    do
        IFS=,
        v=($line)
        if (( ${sample_id} < ${train_samples} ))
        then
            for x in $v;
            do
                printf "$x " >> "${x_train_path}"
            done
            printf "\n" >> "${x_train_path}"
        else
            for x in $v;
            do
                printf "$x " >> "${x_val_path}"
            done
            printf "\n" >> "${x_val_path}"
        fi

        sample_id=$(( sample_id + 1 ))

    done < $file_x

    sample_id=0
    while read line;
    do
        IFS=,
        v=($line)
        if (( ${sample_id} < ${train_samples} ))
        then
            for y in $v;
            do
                printf "$y " >> "${y_train_path}"
            done
            print "\n" >> "${y_train_path}"
        else
            for y in $v;
            do
                printf "$y " >> "${y_val_path}"
            done
            printf "\n" >> ${y_val_path}
        fi

        sample_id=$(( sample_id + 1 ))

    done < $file_y
}
