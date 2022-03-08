#!/bin/bash

run_instance() {
    local input_dir="$1"
    local cpu_id="$2"
    local fuzzer_config="$3"

    if [[ -z $input_dir ]]
    then
	echo "need parameter \$1 to set input dir"
    fi

    if [[ -z $cpu_id ]]
    then
	echo "need parameter \$2 to set the cpu id"
    fi

    if [[ -z $input_dir ]]
    then
	return
    fi

    if [[ -z $cpu_id ]]
    then
	return
    fi

    cd /root
    
    ./mysqld_init.sh
    ./run_mysqld.sh 0 &
    ./run_fuzz.sh "$input_dir" "$cpu_id" "$fuzzer_config"
}

echo "This script is used to run fuzz instance and mysqld instance."
echo "If you start fuzzing failed, just try to restart this docker container to reset the shm id."

run_instance "$1" "$2" "$3"
