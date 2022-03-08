#!/bin/bash

NOT_FORKSERVER=1 /root/mysqld_init.sh
__AFL_SHM_ID=$(cat /tmp/shm_id) NOT_FORKSERVER=1 /usr/local/mysql/bin/mysqld -uroot --datadir=/usr/local/mysql/data &
sleep 5
