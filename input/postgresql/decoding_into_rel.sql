 SET synchronous_commit = on;
  SELECT 'init' FROM pg_create_logical_replication_slot('regression_slot', 'test_decoding');
  SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  CREATE TABLE somechange(id serial primary key);
 INSERT INTO somechange DEFAULT VALUES;
  CREATE TABLE changeresult AS SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  SELECT * FROM changeresult;
  INSERT INTO changeresult SELECT data FROM pg_logical_slot_peek_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 INSERT INTO changeresult SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  SELECT * FROM changeresult;
 DROP TABLE changeresult;
 DROP TABLE somechange;
  CREATE FUNCTION slot_changes_wrapper(slot_name name) RETURNS SETOF TEXT AS $$ BEGIN RETURN QUERY SELECT data FROM pg_logical_slot_peek_changes(slot_name, NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
 END$$ LANGUAGE plpgsql;
  SELECT * FROM slot_changes_wrapper('regression_slot');
  SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', '0', 'skip-empty-xacts', '1');
  SELECT 'stop' FROM pg_drop_replication_slot('regression_slot');
 