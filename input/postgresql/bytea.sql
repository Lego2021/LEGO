set enable_seqscan=off;
 SET bytea_output TO escape;
  CREATE TABLE test_bytea ( i bytea );
  INSERT INTO test_bytea VALUES ('a'),('ab'),('abc'),('abb'),('axy'),('xyz');
  CREATE INDEX idx_bytea ON test_bytea USING gin (i);
  SELECT * FROM test_bytea WHERE i<'abc'::bytea ORDER BY i;
 SELECT * FROM test_bytea WHERE i<='abc'::bytea ORDER BY i;
 SELECT * FROM test_bytea WHERE i='abc'::bytea ORDER BY i;
 SELECT * FROM test_bytea WHERE i>='abc'::bytea ORDER BY i;
 SELECT * FROM test_bytea WHERE i>'abc'::bytea ORDER BY i;
 