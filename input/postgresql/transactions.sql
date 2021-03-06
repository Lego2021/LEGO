 BEGIN;
  SELECT * INTO TABLE xacttest FROM aggtest;
  INSERT INTO xacttest (a, b) VALUES (777, 777.777);
  END;
  SELECT a FROM xacttest WHERE a > 100;
   BEGIN;
  CREATE TABLE disappear (a int4);
  DELETE FROM aggtest;
  SELECT * FROM aggtest;
  ABORT;
  SELECT oid FROM pg_class WHERE relname = 'disappear';
  SELECT * FROM aggtest;
    CREATE TABLE writetest (a int);
 CREATE TEMPORARY TABLE temptest (a int);
  BEGIN;
 SET TRANSACTION ISOLATION LEVEL SERIALIZABLE, READ ONLY, DEFERRABLE;
 -- ok SELECT * FROM writetest;
 -- ok SET TRANSACTION READ WRITE;
 --fail COMMIT;
  BEGIN;
 SET TRANSACTION READ ONLY;
 -- ok SET TRANSACTION READ WRITE;
 -- ok SET TRANSACTION READ ONLY;
 -- ok SELECT * FROM writetest;
 -- ok SAVEPOINT x;
 SET TRANSACTION READ ONLY;
 -- ok SELECT * FROM writetest;
 -- ok SET TRANSACTION READ ONLY;
 -- ok SET TRANSACTION READ WRITE;
 --fail COMMIT;
  BEGIN;
 SET TRANSACTION READ WRITE;
 -- ok SAVEPOINT x;
 SET TRANSACTION READ WRITE;
 -- ok SET TRANSACTION READ ONLY;
 -- ok SELECT * FROM writetest;
 -- ok SET TRANSACTION READ ONLY;
 -- ok SET TRANSACTION READ WRITE;
 --fail COMMIT;
  BEGIN;
 SET TRANSACTION READ WRITE;
 -- ok SAVEPOINT x;
 SET TRANSACTION READ ONLY;
 -- ok SELECT * FROM writetest;
 -- ok ROLLBACK TO SAVEPOINT x;
 SHOW transaction_read_only;
  -- off SAVEPOINT y;
 SET TRANSACTION READ ONLY;
 -- ok SELECT * FROM writetest;
 -- ok RELEASE SAVEPOINT y;
 SHOW transaction_read_only;
  -- off COMMIT;
  SET SESSION CHARACTERISTICS AS TRANSACTION READ ONLY;
  DROP TABLE writetest;
 -- fail INSERT INTO writetest VALUES (1);
 -- fail SELECT * FROM writetest;
 -- ok DELETE FROM temptest;
 -- ok UPDATE temptest SET a = 0 FROM writetest WHERE temptest.a = 1 AND writetest.a = temptest.a;
 -- ok PREPARE test AS UPDATE writetest SET a = 0;
 -- ok EXECUTE test;
 -- fail SELECT * FROM writetest, temptest;
 -- ok CREATE TABLE test AS SELECT * FROM writetest;
 -- fail  START TRANSACTION READ WRITE;
 DROP TABLE writetest;
 -- ok COMMIT;
  SET SESSION CHARACTERISTICS AS TRANSACTION READ WRITE;
 CREATE TABLE trans_foobar (a int);
 BEGIN;
 CREATE TABLE trans_foo (a int);
 SAVEPOINT one;
 DROP TABLE trans_foo;
 CREATE TABLE trans_bar (a int);
 ROLLBACK TO SAVEPOINT one;
 RELEASE SAVEPOINT one;
 SAVEPOINT two;
 CREATE TABLE trans_baz (a int);
 RELEASE SAVEPOINT two;
 drop TABLE trans_foobar;
 CREATE TABLE trans_barbaz (a int);
 COMMIT;
 SELECT * FROM trans_foo;
        -- should be empty SELECT * FROM trans_bar;
        -- shouldn't exist SELECT * FROM trans_barbaz;
    -- should be empty SELECT * FROM trans_baz;
        -- should be empty  BEGIN;
 INSERT INTO trans_foo VALUES (1);
 SAVEPOINT one;
 INSERT into trans_bar VALUES (1);
 ROLLBACK TO one;
 RELEASE SAVEPOINT one;
 SAVEPOINT two;
 INSERT into trans_barbaz VALUES (1);
 RELEASE two;
 SAVEPOINT three;
 SAVEPOINT four;
 INSERT INTO trans_foo VALUES (2);
 RELEASE SAVEPOINT four;
 ROLLBACK TO SAVEPOINT three;
 RELEASE SAVEPOINT three;
 INSERT INTO trans_foo VALUES (3);
 COMMIT;
 SELECT * FROM trans_foo;
        -- should have 1 and 3 SELECT * FROM trans_barbaz;
    -- should have 1  BEGIN;
 SAVEPOINT one;
 SELECT trans_foo;
 ROLLBACK TO SAVEPOINT one;
 RELEASE SAVEPOINT one;
 SAVEPOINT two;
 CREATE TABLE savepoints (a int);
 SAVEPOINT three;
 INSERT INTO savepoints VALUES (1);
 SAVEPOINT four;
 INSERT INTO savepoints VALUES (2);
 SAVEPOINT five;
 INSERT INTO savepoints VALUES (3);
 ROLLBACK TO SAVEPOINT five;
 COMMIT;
 COMMIT;
        -- should not be in a transaction block SELECT * FROM savepoints;
  BEGIN;
 SAVEPOINT one;
 DELETE FROM savepoints WHERE a=1;
 RELEASE SAVEPOINT one;
 SAVEPOINT two;
 DELETE FROM savepoints WHERE a=1;
 SAVEPOINT three;
 DELETE FROM savepoints WHERE a=2;
 ROLLBACK;
 COMMIT;
        -- should not be in a transaction block  SELECT * FROM savepoints;
  BEGIN;
 INSERT INTO savepoints VALUES (4);
 SAVEPOINT one;
 INSERT INTO savepoints VALUES (5);
 SELECT trans_foo;
 COMMIT;
 SELECT * FROM savepoints;
  BEGIN;
 INSERT INTO savepoints VALUES (6);
 SAVEPOINT one;
 INSERT INTO savepoints VALUES (7);
 RELEASE SAVEPOINT one;
 INSERT INTO savepoints VALUES (8);
 COMMIT;
 SELECT a.xmin = b.xmin FROM savepoints a, savepoints b WHERE a.a=6 AND b.a=8;
 SELECT a.xmin = b.xmin FROM savepoints a, savepoints b WHERE a.a=6 AND b.a=7;
  BEGIN;
 INSERT INTO savepoints VALUES (9);
 SAVEPOINT one;
 INSERT INTO savepoints VALUES (10);
 ROLLBACK TO SAVEPOINT one;
 INSERT INTO savepoints VALUES (11);
 COMMIT;
 SELECT a FROM savepoints WHERE a in (9, 10, 11);
 SELECT a.xmin = b.xmin FROM savepoints a, savepoints b WHERE a.a=9 AND b.a=11;
  BEGIN;
 INSERT INTO savepoints VALUES (12);
 SAVEPOINT one;
 INSERT INTO savepoints VALUES (13);
 SAVEPOINT two;
 INSERT INTO savepoints VALUES (14);
 ROLLBACK TO SAVEPOINT one;
 INSERT INTO savepoints VALUES (15);
 SAVEPOINT two;
 INSERT INTO savepoints VALUES (16);
 SAVEPOINT three;
 INSERT INTO savepoints VALUES (17);
 COMMIT;
 SELECT a FROM savepoints WHERE a BETWEEN 12 AND 17;
  BEGIN;
 INSERT INTO savepoints VALUES (18);
 SAVEPOINT one;
 INSERT INTO savepoints VALUES (19);
 SAVEPOINT two;
 INSERT INTO savepoints VALUES (20);
 ROLLBACK TO SAVEPOINT one;
 INSERT INTO savepoints VALUES (21);
 ROLLBACK TO SAVEPOINT one;
 INSERT INTO savepoints VALUES (22);
 COMMIT;
 SELECT a FROM savepoints WHERE a BETWEEN 18 AND 22;
  DROP TABLE savepoints;
  SAVEPOINT one;
 ROLLBACK TO SAVEPOINT one;
 RELEASE SAVEPOINT one;
  BEGIN;
 SAVEPOINT one;
 SELECT 0/0;
 SAVEPOINT two;
    -- ignored till the end of ... RELEASE SAVEPOINT one;
      -- ignored till the end of ... ROLLBACK TO SAVEPOINT one;
 SELECT 1;
 COMMIT;
 SELECT 1;
            -- this should work  BEGIN;
 DECLARE c CURSOR FOR SELECT unique2 FROM tenk1 ORDER BY unique2;
 SAVEPOINT one;
 FETCH 10 FROM c;
 ROLLBACK TO SAVEPOINT one;
 FETCH 10 FROM c;
 RELEASE SAVEPOINT one;
 FETCH 10 FROM c;
 CLOSE c;
 DECLARE c CURSOR FOR SELECT unique2/0 FROM tenk1 ORDER BY unique2;
 SAVEPOINT two;
 FETCH 10 FROM c;
 ROLLBACK TO SAVEPOINT two;
 FETCH 10 FROM c;
 ROLLBACK TO SAVEPOINT two;
 RELEASE SAVEPOINT two;
 FETCH 10 FROM c;
 COMMIT;
  select * from xacttest;
  create or replace function max_xacttest() returns smallint language sql as 'select max(a) from xacttest' stable;
  begin;
 update xacttest set a = max_xacttest() + 10 where a > 0;
 select * from xacttest;
 rollback;
  create or replace function max_xacttest() returns smallint language sql as 'select max(a) from xacttest' volatile;
  begin;
 update xacttest set a = max_xacttest() + 10 where a > 0;
 select * from xacttest;
 rollback;
  create or replace function max_xacttest() returns smallint language plpgsql as 'begin return max(a) from xacttest;
 end' stable;
  begin;
 update xacttest set a = max_xacttest() + 10 where a > 0;
 select * from xacttest;
 rollback;
  create or replace function max_xacttest() returns smallint language plpgsql as 'begin return max(a) from xacttest;
 end' volatile;
  begin;
 update xacttest set a = max_xacttest() + 10 where a > 0;
 select * from xacttest;
 rollback;
   BEGIN;
 savepoint x;
 CREATE TABLE koju (a INT UNIQUE);
 INSERT INTO koju VALUES (1);
 INSERT INTO koju VALUES (1);
 rollback to x;
  CREATE TABLE koju (a INT UNIQUE);
 INSERT INTO koju VALUES (1);
 INSERT INTO koju VALUES (1);
 ROLLBACK;
  DROP TABLE trans_foo;
 DROP TABLE trans_baz;
 DROP TABLE trans_barbaz;
   create function inverse(int) returns float8 as $$ begin analyze revalidate_bug;
 return 1::float8/$1;
 exception when division_by_zero then return 0;
 end$$ language plpgsql volatile;
  create table revalidate_bug (c float8 unique);
 insert into revalidate_bug values (1);
 insert into revalidate_bug values (inverse(0));
  drop table revalidate_bug;
 drop function inverse(int);
   begin;
  savepoint x;
 create table abc (a int);
 insert into abc values (5);
 insert into abc values (10);
 declare foo cursor for select * from abc;
 fetch from foo;
 rollback to x;
  fetch from foo;
 commit;
  begin;
  create table abc (a int);
 insert into abc values (5);
 insert into abc values (10);
 insert into abc values (15);
 declare foo cursor for select * from abc;
  fetch from foo;
  savepoint x;
 fetch from foo;
 rollback to x;
  fetch from foo;
  abort;
   CREATE FUNCTION invert(x float8) RETURNS float8 LANGUAGE plpgsql AS $$ begin return 1/x;
 end $$;
  CREATE FUNCTION create_temp_tab() RETURNS text LANGUAGE plpgsql AS $$ BEGIN CREATE TEMP TABLE new_table (f1 float8);
 INSERT INTO new_table SELECT invert(0.0);
 RETURN 'foo';
 END $$;
  BEGIN;
 DECLARE ok CURSOR FOR SELECT * FROM int8_tbl;
 DECLARE ctt CURSOR FOR SELECT create_temp_tab();
 FETCH ok;
 SAVEPOINT s1;
 FETCH ok;
  -- should work FETCH ctt;
 -- error occurs here ROLLBACK TO s1;
 FETCH ok;
  -- should work FETCH ctt;
 -- must be rejected COMMIT;
  DROP FUNCTION create_temp_tab();
 DROP FUNCTION invert(x float8);
    CREATE TABLE abc (a int);
  SET default_transaction_read_only = on;
  START TRANSACTION ISOLATION LEVEL REPEATABLE READ, READ WRITE, DEFERRABLE;
 SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 INSERT INTO abc VALUES (1);
 INSERT INTO abc VALUES (2);
 COMMIT AND CHAIN;
  -- TBLOCK_END SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 INSERT INTO abc VALUES ('error');
 INSERT INTO abc VALUES (3);
  -- check it's really aborted COMMIT AND CHAIN;
  -- TBLOCK_ABORT_END SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 INSERT INTO abc VALUES (4);
 COMMIT;
  START TRANSACTION ISOLATION LEVEL REPEATABLE READ, READ WRITE, DEFERRABLE;
 SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 SAVEPOINT x;
 INSERT INTO abc VALUES ('error');
 COMMIT AND CHAIN;
  -- TBLOCK_ABORT_PENDING SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 INSERT INTO abc VALUES (5);
 COMMIT;
  START TRANSACTION ISOLATION LEVEL REPEATABLE READ, READ WRITE, DEFERRABLE;
 SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 SAVEPOINT x;
 COMMIT AND CHAIN;
  -- TBLOCK_SUBCOMMIT SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 COMMIT;
  START TRANSACTION ISOLATION LEVEL SERIALIZABLE, READ WRITE, NOT DEFERRABLE;
 SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 INSERT INTO abc VALUES (6);
 ROLLBACK AND CHAIN;
  -- TBLOCK_ABORT_PENDING SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 INSERT INTO abc VALUES ('error');
 ROLLBACK AND CHAIN;
  -- TBLOCK_ABORT_END SHOW transaction_isolation;
 SHOW transaction_read_only;
 SHOW transaction_deferrable;
 ROLLBACK;
  COMMIT AND CHAIN;
  -- error ROLLBACK AND CHAIN;
  -- error  SELECT * FROM abc ORDER BY 1;
  RESET default_transaction_read_only;
  DROP TABLE abc;
    create temp table i_table (f1 int);
  SELECT 1\;
 SELECT 2\;
 SELECT 3;
  insert into i_table values(1)\;
 select * from i_table;
 insert into i_table values(2)\;
 select * from i_table\;
 select 1/0;
 select * from i_table;
  rollback;
  -- we are not in a transaction at this point  begin\;
 insert into i_table values(3)\;
 commit;
 rollback;
  -- we are not in a transaction at this point begin\;
 insert into i_table values(4)\;
 rollback;
 rollback;
  -- we are not in a transaction at this point  select 1\;
 begin\;
 insert into i_table values(5);
 commit;
 select 1\;
 begin\;
 insert into i_table values(6);
 rollback;
  insert into i_table values(7)\;
 commit\;
 insert into i_table values(8)\;
 select 1/0;
 insert into i_table values(9)\;
 rollback\;
 select 2;
  select * from i_table;
  rollback;
  -- we are not in a transaction at this point  SELECT 1\;
 VACUUM;
 SELECT 1\;
 COMMIT\;
 VACUUM;
  SELECT 1\;
 SAVEPOINT sp;
 SELECT 1\;
 COMMIT\;
 SAVEPOINT sp;
 ROLLBACK TO SAVEPOINT sp\;
 SELECT 2;
 SELECT 2\;
 RELEASE SAVEPOINT sp\;
 SELECT 3;
  SELECT 1\;
 BEGIN\;
 SAVEPOINT sp\;
 ROLLBACK TO SAVEPOINT sp\;
 COMMIT;
    SET TRANSACTION READ ONLY\;
 COMMIT AND CHAIN;
  -- error SHOW transaction_read_only;
  SET TRANSACTION READ ONLY\;
 ROLLBACK AND CHAIN;
  -- error SHOW transaction_read_only;
  CREATE TABLE abc (a int);
  INSERT INTO abc VALUES (7)\;
 COMMIT\;
 INSERT INTO abc VALUES (8)\;
 COMMIT AND CHAIN;
  -- 7 commit, 8 error INSERT INTO abc VALUES (9)\;
 ROLLBACK\;
 INSERT INTO abc VALUES (10)\;
 ROLLBACK AND CHAIN;
  -- 9 rollback, 10 error  INSERT INTO abc VALUES (11)\;
 COMMIT AND CHAIN\;
 INSERT INTO abc VALUES (12)\;
 COMMIT;
  -- 11 error, 12 not reached INSERT INTO abc VALUES (13)\;
 ROLLBACK AND CHAIN\;
 INSERT INTO abc VALUES (14)\;
 ROLLBACK;
  -- 13 error, 14 not reached  START TRANSACTION ISOLATION LEVEL REPEATABLE READ\;
 INSERT INTO abc VALUES (15)\;
 COMMIT AND CHAIN;
  -- 15 ok SHOW transaction_isolation;
  -- transaction is active at this point COMMIT;
  START TRANSACTION ISOLATION LEVEL REPEATABLE READ\;
 INSERT INTO abc VALUES (16)\;
 ROLLBACK AND CHAIN;
  -- 16 ok SHOW transaction_isolation;
  -- transaction is active at this point ROLLBACK;
  SET default_transaction_isolation = 'read committed';
  START TRANSACTION ISOLATION LEVEL REPEATABLE READ\;
 INSERT INTO abc VALUES (17)\;
 COMMIT\;
 INSERT INTO abc VALUES (18)\;
 COMMIT AND CHAIN;
  -- 17 commit, 18 error SHOW transaction_isolation;
  -- out of transaction block  START TRANSACTION ISOLATION LEVEL REPEATABLE READ\;
 INSERT INTO abc VALUES (19)\;
 ROLLBACK\;
 INSERT INTO abc VALUES (20)\;
 ROLLBACK AND CHAIN;
  -- 19 rollback, 20 error SHOW transaction_isolation;
  -- out of transaction block  RESET default_transaction_isolation;
  SELECT * FROM abc ORDER BY 1;
  DROP TABLE abc;
    begin;
 select 1/0;
 rollback to X;
  