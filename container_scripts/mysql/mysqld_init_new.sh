#!/bin/bash

init_mysqld() {
    cd /usr/local/mysql
    killall -9 mysqld
    rm -rf ./data/*
    scripts/mysql_install_db --user=root --auth-root-authentication-method=normal
    nohup /usr/local/mysql/bin/mysqld -uroot &
    sleep 5
    echo "create database fuck; create database test1; create database test2; create database test3;" | /usr/local/mysql/bin/mysql -u root
    killall mysqld
}

init_mysqld
