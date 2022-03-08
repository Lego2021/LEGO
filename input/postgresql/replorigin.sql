SET synchronous_commit = on;
  CREATE ROLE regress_origin_replication REPLICATION;
 SET ROLE regress_origin_replication;
 SELECT pg_replication_origin_advance('regress_test_decoding: perm', '0/1');
 SELECT pg_replication_origin_create('regress_test_decoding: perm');
 SELECT pg_replication_origin_drop('regress_test_decoding: perm');
 SELECT pg_replication_origin_oid('regress_test_decoding: perm');
 SELECT pg_replication_origin_progress('regress_test_decoding: perm', false);
 SELECT pg_replication_origin_session_is_setup();
 SELECT pg_replication_origin_session_progress(false);
 SELECT pg_replication_origin_session_reset();
 SELECT pg_replication_origin_session_setup('regress_test_decoding: perm');
 SELECT pg_replication_origin_xact_reset();
 SELECT pg_replication_origin_xact_setup('0/1', '2013-01-01 00:00');
 SELECT pg_show_replication_origin_status();
 RESET ROLE;
 DROP ROLE regress_origin_replication;
  CREATE TABLE origin_tbl(id serial primary key, data text);
 CREATE TABLE target_tbl(id serial primary key, data text);
  SELECT pg_replication_origin_create('regress_test_decoding: regression_slot');
 SELECT pg_replication_origin_create('regress_test_decoding: regression_slot');
  SELECT pg_replication_origin_create('regress_test_decoding: temp');
 SELECT pg_replication_origin_drop('regress_test_decoding: temp');
 SELECT pg_replication_origin_drop('regress_test_decoding: temp');
  select pg_replication_origin_advance('regress_test_decoding: temp', '0/1');
 select pg_replication_origin_session_setup('regress_test_decoding: temp');
 select pg_replication_origin_progress('regress_test_decoding: temp', true);
  SELECT 'init' FROM pg_create_logical_replication_slot('regression_slot', 'test_decoding');
  INSERT INTO origin_tbl(data) VALUES ('will be replicated and decoded and decoded again');
 INSERT INTO target_tbl(data) SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  INSERT INTO origin_tbl(data) VALUES ('will be replicated, but not decoded again');
  SELECT pg_replication_origin_session_setup('regress_test_decoding: regression_slot');
  SELECT pg_replication_origin_session_setup('regress_test_decoding: regression_slot');
  SELECT '' FROM pg_logical_emit_message(false, 'test', 'this message will not be decoded');
  BEGIN;
 SELECT pg_replication_origin_xact_setup('0/aabbccdd', '2013-01-01 00:00');
 INSERT INTO target_tbl(data) SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1', 'only-local', '1');
 COMMIT;
  SELECT pg_replication_origin_session_progress(false);
 SELECT pg_replication_origin_session_progress(true);
  SELECT pg_replication_origin_session_reset();
  SELECT local_id, external_id, remote_lsn, local_lsn <> '0/0' FROM pg_replication_origin_status;
  SELECT pg_replication_origin_progress('regress_test_decoding: regression_slot', false);
 SELECT pg_replication_origin_progress('regress_test_decoding: regression_slot', true);
  SELECT pg_replication_origin_session_reset();
  SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1', 'only-local', '1');
  INSERT INTO origin_tbl(data) VALUES ('will be replicated');
 SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1',  'only-local', '1');
  SELECT pg_drop_replication_slot('regression_slot');
 SELECT pg_replication_origin_drop('regress_test_decoding: regression_slot');
 