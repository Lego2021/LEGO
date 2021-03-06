SET synchronous_commit = on;
 SELECT 'init' FROM pg_create_logical_replication_slot('regression_slot', 'test_decoding', false, true);
  CREATE TABLE test_prepared1(id integer primary key);
 CREATE TABLE test_prepared2(id integer primary key);
  BEGIN;
 INSERT INTO test_prepared1 VALUES (1);
 INSERT INTO test_prepared1 VALUES (2);
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 PREPARE TRANSACTION 'test_prepared#1';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 COMMIT PREPARED 'test_prepared#1';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  BEGIN;
 INSERT INTO test_prepared1 VALUES (3);
 PREPARE TRANSACTION 'test_prepared#2';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 ROLLBACK PREPARED 'test_prepared#2';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  BEGIN;
 ALTER TABLE test_prepared1 ADD COLUMN data text;
 INSERT INTO test_prepared1 VALUES (4, 'frakbar');
 PREPARE TRANSACTION 'test_prepared#3';
 SELECT 'test_prepared_1' AS relation, locktype, mode FROM pg_locks WHERE locktype = 'relation' AND relation = 'test_prepared1'::regclass;
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  INSERT INTO test_prepared2 VALUES (5);
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  COMMIT PREPARED 'test_prepared#3';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 INSERT INTO test_prepared1 VALUES (6);
 INSERT INTO test_prepared2 VALUES (7);
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  BEGIN;
 INSERT INTO test_prepared1 VALUES (8, 'othercol');
 CLUSTER test_prepared1 USING test_prepared1_pkey;
 INSERT INTO test_prepared1 VALUES (9, 'othercol2');
 PREPARE TRANSACTION 'test_prepared_lock';
  SELECT 'test_prepared1' AS relation, locktype, mode FROM pg_locks WHERE locktype = 'relation' AND relation = 'test_prepared1'::regclass;
 SET statement_timeout = '180s';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 RESET statement_timeout;
 COMMIT PREPARED 'test_prepared_lock';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  BEGIN;
 CREATE TABLE test_prepared_savepoint (a int);
 INSERT INTO test_prepared_savepoint VALUES (1);
 SAVEPOINT test_savepoint;
 INSERT INTO test_prepared_savepoint VALUES (2);
 ROLLBACK TO SAVEPOINT test_savepoint;
 PREPARE TRANSACTION 'test_prepared_savepoint';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 COMMIT PREPARED 'test_prepared_savepoint';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  BEGIN;
 INSERT INTO test_prepared1 VALUES (20);
 PREPARE TRANSACTION 'test_prepared_nodecode';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 COMMIT PREPARED 'test_prepared_nodecode';
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  DROP TABLE test_prepared1;
 DROP TABLE test_prepared2;
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  SELECT pg_drop_replication_slot('regression_slot');
 