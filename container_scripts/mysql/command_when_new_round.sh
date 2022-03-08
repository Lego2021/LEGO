#!/bin/bash

killall -9 client
rm -rf "/tmp/#"* &
rm -rf "/usr/local/mysql/data/#"* &
# if [[ -z $(pidof mysqld) ]]
# then
NOT_FORKSERVER=1 /root/mysqld_init.sh
__AFL_SHM_ID=$(cat /tmp/shm_id) NOT_FORKSERVER=1 /usr/local/mysql/bin/mysqld -uroot --datadir=/usr/local/mysql/data &
sleep 5
# fi
# echo 'select concat("Kill ", ID, ";") from information_schema.processlist where time = (select min(time) from information_schema.processlist where time > 1 && (Command="Query" || Command="Killed"));' | /root/bin_original/usr/local/mysql/bin/mysql -u root | grep 'Kill [^"]*;' | /root/bin_original/usr/local/mysql/bin/mysql -u root &
