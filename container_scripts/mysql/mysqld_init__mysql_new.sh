#!/bin/bash

init_mysqld() {
    cd /usr/local/mysql
    killall -9 mysqld
    rm -rf ./data/*
    ASAN_OPTIONS="detect_leaks=0" bin/mysqld --initialize-insecure -uroot && bin/mysql_ssl_rsa_setup
    nohup /usr/local/mysql/bin/mysqld -uroot &
    sleep 10
    echo "create database fuck; create database test1;" | /usr/local/mysql/bin/mysql -u root
    killall mysqld
}

init_mysqld
