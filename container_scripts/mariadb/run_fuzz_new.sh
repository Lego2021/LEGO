#!/bin/bash

set -x

run_fuzz() {
    local input_dir="$1"
    local cpu_id="$2"
    local fuzzer_config="$3"

    if [[ -z "$input_dir" ]]
    then
	echo "need parameter \$1 to set input dir"
    fi

    if [[ -z "$cpu_id" ]]
    then
	echo "need parameter \$2 to set the cpu id"
    fi

    if [[ -z "$input_dir" ]]
    then
	return
    fi

    if [[ -z "$cpu_id" ]]
    then
	return
    fi

    cd /root/fuzzing/fuzz_root
    rm -rf /root/output/*
    LSAN_OPTIONS=detect_leaks=0 IP=127.0.0.1 PORT=3306 /root/afl-fuzz $fuzzer_config -i "$input_dir" -o /root/output -u -b $cpu_id aaa
}

run_fuzz "$1" "$2" "$3"
