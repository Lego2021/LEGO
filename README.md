# LEGO: Sequence-Oriented DBMS Fuzzing

LEGO is based on [AFL++](https://github.com/AFLplusplus/AFLplusplus/tree/release) (newest release version). 

Github links to currently supported DBMSs:  [postgresql](https://github.com/postgres/postgres),[mysql](https://github.com/mysql/mysql-server), [mariadb](https://github.com/MariaDB/server), [comdb2](https://github.com/bloomberg/comdb2).

The Dockerfile uses the source code from the default branches on these DBMSs' github projects. However, our fuzz drivers maybe do not work correctly on the newest source code in the future. If so, just switch to an old version of DBMSs' source code by modifying the [Dockerfile](https://github.com/Lego2021/LEGO/blob/main/Dockerfile) manually.

LEGO's core algorithm is implemented to AFL++'s custom mutator in the custom\_mutator directory. You can also add your own custom mutator when fuzzing if you want. See [AFL++'s Documentation](https://github.com/AFLplusplus/AFLplusplus/blob/release/docs/custom_mutators.md).

# Build LEGO Docker Image

We recommend you use LEGO in docker, because our fuzz drivers and bash scripts will sometimes kill DB process (e.g. "killall -9 mysqld")  or clean the whole directory for storing data (e.g. /usr/local/mysql/data) during fuzzing.  Running LEGO on the host machine is dangerous.

Using buildkit can simplify your building.

```sh
git clone https://github.com/Lego2021/LEGO.git
cd LEGO

DOCKER_BUILDKIT=1 docker build --target=LEGO_mariadb    -t lego_mariadb  .
DOCKER_BUILDKIT=1 docker build --target=LEGO_mysql      -t lego_mysql    .
DOCKER_BUILDKIT=1 docker build --target=LEGO_postgresql -t lego_postgres .
DOCKER_BUILDKIT=1 docker build --target=LEGO_comdb2     -t lego_comdb2   .
```

# Run Fuzzer

## PostgreSQL

Create a container from image LEGO_posgres, for example:

```sh
docker run -it --name lego_postgres_container lego_postgres
```

Then run the following commands in the container created just now:

```sh
export AFL_PRELOAD=/usr/local/pgsql/lib/libpq.so                                  # necessary
export AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so                                # necessary: it's LEGO!
export AFL_FORKSRV_INIT_TMOUT=20000                                               # necessary: our driver need a little time to init.
export AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1    # optional
export AFL_CUSTOM_MUTATOR_ONLY=1                                                  # optional
sudo -E -u postgres /root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 100 -- /root/postgres_driver -D /usr/local/pgsql/data
```

Be careful about the permissions of files and directories because the fuzzer is running with the user 'postgres' in the docker, not the root user.

## MariaDB

Create a container from image LEGO_mariadb, for example:

```sh
docker run -it --name lego_mariadb_container lego_mariadb
```

Then run the following commands in the container created just now:

```sh
export AFL_PRELOAD=/usr/local/mysql/lib/libmariadb.so                             # necessary
export AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so                                # necessary: it's LEGO!
export AFL_FORKSRV_INIT_TMOUT=20000                                               # necessary: our driver need a little time to init.
export AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1    # optional
export AFL_CUSTOM_MUTATOR_ONLY=1                                                  # optional
/root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 20000 -- /root/mysql_driver -uroot --datadir=/usr/local/mysql/data
```

## MySQL

Create a container from image LEGO_mysql, for example:

```sh
docker run -it --name lego_mysql_container lego_mysql
```

Then run the following commands in the container created just now:

```sh
export AFL_PRELOAD=/usr/local/mysql/lib/libmysqlclient.so                         # necessary
export AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so                                # necessary: it's LEGO!
export AFL_FORKSRV_INIT_TMOUT=100000                                              # necessary: our driver need a little time to init.
export AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1    # optional
export AFL_CUSTOM_MUTATOR_ONLY=1                                                  # optional
/root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 100000 -- /root/mysql_driver -uroot --datadir=/usr/local/mysql/data
```

## Comdb2

Create a container from image LEGO_comdb2, for example:

```sh
docker run -it --name lego_comdb2_container lego_comdb2
```

Then run the following commands in the container created just now:

```sh
export AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so                                # necessary: it's LEGO!
export AFL_FORKSRV_INIT_TMOUT=100000                                              # necessary: our driver need a little time to init.
export AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1    # optional
export AFL_CUSTOM_MUTATOR_ONLY=1                                                  # optional
/root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 100000 -- /root/COMDB2_driver
```

Attention: The Comdb2 fuzzing driver will use a lot of system resources. You need at least 60GB of RAM. 

This is because that as a clustered RDBMS, it needs at least one comdb2 process for each comdb2 database. To speed up database switching during fuzzing, the driver will create hundreds of comdb2 databases and start one process for each database at the same time, which may slow down your system due to too many working processes.



