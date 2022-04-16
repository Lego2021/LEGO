# syntax = docker/dockerfile:1.2
FROM ubuntu:20.04 AS ubuntu_with_git

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt -y install git

FROM ubuntu_with_git AS aflpp_src
RUN git clone https://github.com/AFLplusplus/AFLplusplus.git /root/AFLplusplus
WORKDIR /root/AFLplusplus
RUN git checkout tags/4.00c

FROM ubuntu_with_git AS mysql_src
RUN git clone https://github.com/mysql/mysql-server.git      /root/mysql-server
WORKDIR /root/mysql-server
RUN git checkout tags/mysql-8.0.25

FROM ubuntu_with_git AS comdb2_src
RUN git clone https://github.com/bloomberg/comdb2.git        /root/comdb2

FROM ubuntu_with_git AS mariadb_src
RUN git clone https://github.com/MariaDB/server.git          /root/mariadb
WORKDIR /root/mariadb
RUN git checkout tags/mariadb-10.6.5

FROM ubuntu_with_git AS postgres_src
RUN git clone https://github.com/postgres/postgres.git       /root/postgres

FROM ubuntu_with_git AS ubuntu_with_aflpp
RUN apt -y install clang-12 lld-12
RUN apt -y install make
COPY --from=aflpp_src /root/AFLplusplus /root/AFLplusplus
# AFLplusplus
####################################
# AFLplusplus. Release version.    #
####################################
WORKDIR /root/AFLplusplus
RUN git checkout origin/release
RUN CC=clang-12 CXX=clang++-12 LLVM_CONFIG=llvm-config-12 LD=lld-12 CFLAGS="-DINTROSPECTION" CXXFLAGS="-DINTROSPECTION" make

RUN cp /root/AFLplusplus /root/AFLplusplus-LEGO -r

RUN apt -y install cmake

ENTRYPOINT bash

####################################
# build afl-compiler-rt.o FOR LEGO.#
####################################

WORKDIR /root/AFLplusplus-LEGO/instrumentation
RUN (echo "#include <stdint.h>"; \
    echo "extern uint32_t LEGO_custom_map_size;"; \
    echo "static uint32_t __afl_final_loc_fake;"; \
    cat afl-compiler-rt.o.c) \
    > afl-compiler-rt.LEGO.o.c
RUN cp afl-compiler-rt.LEGO.o.c afl-compiler-rt.o.c
RUN sed -i "s/++__afl_final_loc/((__afl_final_loc=LEGO_custom_map_size),++__afl_final_loc_fake)/g" afl-compiler-rt.o.c

WORKDIR /root/AFLplusplus-LEGO
RUN CC=clang-12 CXX=clang++-12 LLVM_CONFIG=llvm-config-12 LD=lld-12 make -f GNUmakefile.llvm afl-compiler-rt.o

COPY container_scripts/make_driver_help_object.sh  /root/make_driver_help_object.sh
RUN chmod 777 /root/make_driver_help_object.sh

WORKDIR /root

####################################
# LEGO comdb2 version.             #
####################################
FROM ubuntu_with_aflpp AS LEGO_comdb2

COPY --from=comdb2_src /root/comdb2 /root/comdb2

RUN apt  update
RUN apt install -y build-essential bison flex libprotobuf-c-dev
RUN apt install -y libreadline-dev libsqlite3-dev libssl-dev libunwind-dev
RUN apt install -y libz1 libz-dev make gawk protobuf-c-compiler
RUN apt install -y uuid-dev liblz4-tool liblz4-dev libprotobuf-c1 libsqlite3-0
RUN apt install -y libuuid1 libz1 tzdata ncurses-dev tcl
RUN apt install -y libevent-dev gdb

WORKDIR /root/bld_original
RUN CC=clang-12 CXX=clang++-12 \
    CFLAGS="-Wno-error=void-pointer-to-enum-cast -Wno-error=typedef-redefinition" \
    CXXFLAGS="-Wno-error=void-pointer-to-enum-cast -Wno-error=typedef-redefinition" \
    cmake /root/comdb2
RUN make -j100
RUN make install -j100
RUN make install -j100 DESTDIR=/root/bin_original

RUN for x in /root/bin_original/opt/bb/*; do cp $x /usr/local -r; done

ENV LD_LIBRARY_PATH=/usr/local/lib/

WORKDIR /root/bld_fast
RUN CC=/root/AFLplusplus/afl-clang-fast \
    CXX=/root/AFLplusplus/afl-clang-fast++ \
    CFLAGS="-Wno-error=void-pointer-to-enum-cast -Wno-error=typedef-redefinition" \
    CXXFLAGS="-Wno-error=void-pointer-to-enum-cast -Wno-error=typedef-redefinition" \
    LD=/root/AFLplusplus/afl-clang-fast \
    cmake /root/comdb2
RUN AFL_USE_ASAN=1 make install -j100 DESTDIR=/root/bin_fast

RUN cp /root/bin_fast/opt/bb/bin/comdb2 /usr/local/bin/

RUN apt -y install psmisc

WORKDIR /root/
COPY driver/comdb2_client.o.LEGO   /root/comdb2_client.o
COPY driver/comdb2_driver.o.LEGO   /root/comdb2_driver.o
COPY driver/driver_utils.o.LEGO     /root/driver_utils.o
COPY container_scripts/make_driver_help_object2.sh  /root/make_driver_help_object.sh
RUN chmod 777 /root/make_driver_help_object.sh

WORKDIR /root
RUN /root/AFLplusplus-LEGO/afl-clang-fast++ driver_utils.o comdb2_client.o comdb2_driver.o $(/root/make_driver_help_object.sh /usr/local/bin/comdb2) -o COMDB2_driver -lcdb2api

COPY custom_mutator/comdb2_seqfuzz.so.LEGO              /root/seqfuzz.so
COPY input/comdb2                                       /root/input

COPY squirrel_lib/mysql/init_lib/                 /root/fuzzing/fuzz_root/init_lib/
COPY squirrel_lib/mysql/init_lib/                 /root/fuzzing/fuzz_root/mysql_initlib/
COPY squirrel_lib/mysql/global_data_lib_mysql     /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/safe_generate_type_mysql  /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/skip_keyword              /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/skip_keyword              /root/
COPY squirrel_lib/comdb2/init_lib                 /root/init_lib
COPY squirrel_lib/comdb2/pragma                   /root/pragma                        

WORKDIR /root/

# AFL_DEBUG=1 AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1 AFL_CUSTOM_MUTATOR_ONLY=1 AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so AFL_FORKSRV_INIT_TMOUT=100000 /root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 100000 -- /root/COMDB2_driver

####################################
# LEGO mysql version.              #
####################################
FROM ubuntu_with_aflpp AS LEGO_mysql

COPY --from=mysql_src /root/mysql-server /root/mysql-server

RUN apt update
RUN apt install -y wget libssl-dev
RUN apt install -y pkg-config
RUN apt install -y bison
RUN apt install -y libudev-dev

WORKDIR /root/
RUN mkdir boost
RUN wget https://liquidtelecom.dl.sourceforge.net/project/boost/boost/1.73.0/boost_1_73_0.tar.gz -O boost/boost_1_73_0.tar.gz
RUN tar -xzvf boost/boost_1_73_0.tar.gz -C boost/

WORKDIR /root/bld_original
RUN CC=clang-12 \
    CXX=clang++-12 \
    cmake ../mysql-server -DWITH_BOOST=../boost
RUN make install DESTDIR=/root/bin_original -j100
RUN make install

WORKDIR /root/AFLplusplus
RUN git checkout origin/release
RUN CC=clang-12 CXX=clang++-12 LLVM_CONFIG=llvm-config-12 LD=lld-12 make

WORKDIR /root/bld_fast
RUN CC=/root/AFLplusplus/afl-clang-fast CXX=/root/AFLplusplus/afl-clang-fast++ \
    cmake ../mysql-server -DWITH_BOOST=../boost -DWITH_ASAN=1
RUN make mysqld -j100
RUN make mysqld install DESTDIR=/root/bin_fast -j100
RUN cp /root/bin_fast/usr/local/mysql/bin/mysqld /usr/local/mysql/bin/mysqld

RUN apt -y install psmisc

WORKDIR /root/
COPY driver/mariadb_client.o.LEGO   /root/mariadb_client.o
COPY driver/mariadb_driver.o.LEGO   /root/mariadb_driver.o
COPY driver/driver_utils.o.LEGO     /root/driver_utils.o
COPY container_scripts/make_driver_help_object2.sh  /root/make_driver_help_object.sh
RUN chmod 777 /root/make_driver_help_object.sh

WORKDIR /root
RUN clang++-12 mariadb_client.o -L/usr/local/mysql/lib/ -lmysqlclient -o /root/client
RUN /root/AFLplusplus-LEGO/afl-clang-fast++ driver_utils.o mariadb_driver.o $(/root/make_driver_help_object.sh /usr/local/mysql/bin/mysqld) -o mysql_driver

COPY container_scripts/mysql/run_fuzz_new.sh            /root/run_fuzz.sh
COPY container_scripts/mysql/run_mysqld__mysql_new.sh   /root/run_mysqld.sh
COPY container_scripts/mysql/run_instance_new.sh        /root/run_instance.sh
COPY container_scripts/mysql/mysqld_init__mysql_new.sh  /root/mysqld_init.sh
COPY container_scripts/mysql/command_when_crash.sh      /root/command_when_crash.sh
COPY container_scripts/mysql/command_when_new_round.sh  /root/command_when_new_round.sh
COPY custom_mutator/mysql_seqfuzz.so.LEGO               /root/seqfuzz.so
COPY input/mysql                                        /root/input

COPY squirrel_lib/mysql/init_lib/                 /root/fuzzing/fuzz_root/init_lib/
COPY squirrel_lib/mysql/init_lib/                 /root/fuzzing/fuzz_root/mysql_initlib/
COPY squirrel_lib/mysql/global_data_lib_mysql     /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/safe_generate_type_mysql  /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/skip_keyword              /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/skip_keyword              /root/

RUN chmod 777 /root/*.sh

# AFL_PRELOAD=/usr/local/mysql/lib/libmysqlclient.so AFL_DEBUG=1 AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1 AFL_FORKSRV_INIT_TMOUT=100000 AFL_CUSTOM_MUTATOR_ONLY=1 AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so /root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 100000 -- /root/mysql_driver -uroot --datadir=/usr/local/mysql/data

####################################
# LEGO mariadb version.            #
####################################
FROM ubuntu_with_aflpp AS LEGO_mariadb

COPY --from=mariadb_src /root/mariadb /root/mariadb
RUN apt -y install gnutls-dev bison flex

WORKDIR /root/bld_original
RUN CC=clang-12 \
    CXX=clang++-12 \
    cmake ../mariadb
RUN make install DESTDIR=/root/bin_original -j100
RUN make install -j100

WORKDIR /root/bld_fast
RUN CC=/root/AFLplusplus/afl-clang-fast CXX=/root/AFLplusplus/afl-clang-fast++ \
    cmake ../mariadb -DWITH_ASAN=1
RUN make -j100
RUN make install DESTDIR=/root/bin_fast -j100

RUN cp /root/bin_fast/usr/local/mysql/bin/mysqld /usr/local/mysql/bin/mysqld

RUN apt -y install psmisc

WORKDIR /root/
COPY driver/mariadb_client.o.LEGO  /root/mariadb_client.o
COPY driver/mariadb_driver.o.LEGO  /root/mariadb_driver.o
COPY driver/driver_utils.o.LEGO    /root/driver_utils.o
COPY container_scripts/make_driver_help_object2.sh  /root/make_driver_help_object.sh
RUN chmod 777 /root/make_driver_help_object.sh

WORKDIR /root
RUN clang++-12 mariadb_client.o -L/usr/local/mysql/lib/ -lmysqlclient -o /root/client
RUN /root/AFLplusplus-LEGO/afl-clang-fast++ driver_utils.o mariadb_driver.o $(/root/make_driver_help_object.sh /usr/local/mysql/bin/mysqld) -o mysql_driver

COPY container_scripts/mariadb/run_fuzz_new.sh            /root/run_fuzz.sh
COPY container_scripts/mariadb/run_mysqld_new.sh          /root/run_mysqld.sh
COPY container_scripts/mariadb/run_instance_new.sh        /root/run_instance.sh
COPY container_scripts/mariadb/mysqld_init_new.sh         /root/mysqld_init.sh
COPY container_scripts/mariadb/command_when_crash.sh      /root/command_when_crash.sh
COPY container_scripts/mariadb/command_when_new_round.sh  /root/command_when_new_round.sh
COPY custom_mutator/mysql_seqfuzz.so.LEGO                 /root/seqfuzz.so

COPY squirrel_lib/mysql/init_lib/                 /root/fuzzing/fuzz_root/init_lib/
COPY squirrel_lib/mysql/init_lib/                 /root/fuzzing/fuzz_root/mysql_initlib/
COPY squirrel_lib/mysql/global_data_lib_mysql     /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/safe_generate_type_mysql  /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/skip_keyword              /root/fuzzing/fuzz_root/
COPY squirrel_lib/mysql/skip_keyword              /root/
COPY input/mysql                                  /root/input
RUN chmod 777 /root/*.sh

# AFL_PRELOAD=/usr/local/mysql/lib/libmariadb.so AFL_DEBUG=1 AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1 AFL_FORKSRV_INIT_TMOUT=20000 AFL_CUSTOM_MUTATOR_ONLY=1 AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so /root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 20000 -- /root/mysql_driver -uroot --datadir=/usr/local/mysql/data

####################################
# LEGO postgresql version.         #
####################################
FROM ubuntu_with_aflpp AS LEGO_postgresql

COPY --from=postgres_src /root/postgres /root/postgres

RUN apt update
RUN apt -y install locales
RUN apt -y install libz-dev
RUN apt -y install bison
RUN apt -y install flex

WORKDIR /root/bld_original
RUN sed "s/! nm -A -u \$< 2>\/dev\/null | grep -v __cxa_atexit | grep exit//g" -i /root/postgres/src/interfaces/libpq/Makefile
RUN sed "s/nm -A -u \$< 2>\/dev\/null | grep -v __cxa_atexit | grep exit/(( 0 != 0 ))/g" -i /root/postgres/src/interfaces/libpq/Makefile
RUN CC=clang-12 \
    CXX=clang++-12 \
    /root/postgres/configure --without-readline
RUN make -j100
RUN make install DESTDIR=/root/bin_original -j100
RUN make install -j100

WORKDIR /root/bld_fast
RUN CC=/root/AFLplusplus/afl-clang-fast \
    CXX=/root/AFLplusplus/afl-clang-fast++ \
    AFL_USE_ASAN=1 \
    LDFLAGS="-lpthread -pthread -lrt -Wl,--no-as-needed -ldl" \
    /root/postgres/configure --without-readline
RUN AFL_USE_ASAN=1 make -j100
RUN AFL_USE_ASAN=1 make install DESTDIR=/root/bin_fast -j100
RUN cp /root/bin_fast/usr/local/pgsql/bin/postgres /usr/local/pgsql/bin/postgres
COPY driver/postgres_client.o.LEGO /root/postgres_client.o
COPY driver/postgres_driver.o.LEGO /root/postgres_driver.o
COPY driver/driver_utils.o.LEGO    /root/driver_utils.o
COPY container_scripts/make_driver_help_object2.sh  /root/make_driver_help_object.sh
RUN chmod 777 /root/make_driver_help_object.sh

WORKDIR /root
RUN clang++-12 postgres_client.o -L/usr/local/pgsql/lib/ -lpq -o /root/client
RUN /root/AFLplusplus-LEGO/afl-clang-fast++ driver_utils.o postgres_driver.o $(/root/make_driver_help_object.sh /usr/local/pgsql/bin/postgres) -o postgres_driver
RUN ln -s /usr/local/pgsql/lib/libpq.so /usr/local/lib/libpq.so
RUN apt -y install sudo
RUN useradd postgres
RUN chmod 777 /root
RUN mkdir /usr/local/pgsql/data
RUN chown postgres /usr/local/pgsql/data

COPY input/postgresql                           /root/input
COPY custom_mutator/postgres_seqfuzz.so.LEGO    /root/seqfuzz.so
COPY squirrel_lib/postgresql/init_lib/          /root/fuzzing/fuzz_root/postgres_initlib/
COPY squirrel_lib/postgresql/safe_generate_type /root/fuzzing/fuzz_root/
COPY squirrel_lib/postgresql/global_data_lib    /root/fuzzing/fuzz_root/
RUN chown postgres /root/input
RUN chown -R postgres /root/fuzzing

# AFL_PRELOAD=/usr/local/pgsql/lib/libpq.so AFL_SHUFFLE_QUEUE=1 AFL_FAST_CAL=1 AFL_DISABLE_TRIM=1 AFL_NO_AFFINITY=1 AFL_CUSTOM_MUTATOR_ONLY=1 AFL_CUSTOM_MUTATOR_LIBRARY=/root/seqfuzz.so AFL_FORKSRV_INIT_TMOUT=20000 sudo -E -u postgres /root/AFLplusplus/afl-fuzz -p exploit -i /root/input/ -o out -t 100 -- /root/postgres_driver -D /usr/local/pgsql/data
