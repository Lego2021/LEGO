SET synchronous_commit = on;
  SELECT 'init' FROM pg_create_logical_replication_slot('regression_slot', 'test_decoding');
  CREATE TABLE xact_test(data text);
 INSERT INTO xact_test VALUES ('before-test');
  BEGIN;
 SELECT * FROM xact_test FOR UPDATE;
 SAVEPOINT foo;
 INSERT INTO xact_test VALUES ('after-assignment');
 COMMIT;
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  BEGIN;
 INSERT INTO xact_test VALUES ('main-txn');
 SAVEPOINT foo;
 SELECT 1 FROM xact_test FOR UPDATE LIMIT 1;
 COMMIT;
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  DROP TABLE xact_test;
  SELECT pg_drop_replication_slot('regression_slot');
 