#!/bin/bash

time_handler() {
    while true
    do echo 'select concat("Kill ", ID, ";") from information_schema.processlist where time = (select min(time) from information_schema.processlist where time > 1 && (Command="Query" || Command="Killed"));' | /usr/local/mysql/bin/mysql -u root | grep 'Kill [^"]*;' | /usr/local/mysql/bin/mysql -u root
       sleep 1
    done

}

run_mysqld() {
    local shm_id=$1

    if [[ -z $shm_id ]]
    then
	echo "need parameter \$1 to set shm id"
	return
    fi

    # time_handler &

    crash_id=0
    
    while true
    do
	killall mysqld
	export __AFL_SHM_ID=$shm_id; /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data -uroot --pid-file=fuckpid.pid --max_execution_time=1000 --disable-log-bin --mysqlx=0 --binlog-cache-size=0 --binlog-stmt-cache-size=0 --host-cache-size=0  --innodb-disable-sort-file-cache  --innodb-ft-cache-size=0 --innodb-ft-result-cache-limit=0 --innodb-ft-total-cache-size=0 --key-cache-age-threshold=0 --key-cache-block-size=0 --key-cache-division-limit=0 --max-binlog-cache-size=0 --max-binlog-stmt-cache-size=0 --skip-host-cache --stored-program-cache=0 --table-open-cache=0 --table-definition-cache=0 --table-open-cache-instances=0 --thread-cache-size=0
	(( ++crash_id ))
	cat /tmp/client_log.txt | tail -50000 > /tmp/crash_$crash_id
	cp /usr/local/mysql/data/fuckerr.err /root/err_log_$crash_id
	/root/mysqld_init.sh
    done
}

run_mysqld $1
