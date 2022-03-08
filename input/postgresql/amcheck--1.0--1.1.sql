/* contrib/amcheck/amcheck--1.0--1.1.sql */  \echo Use "ALTER EXTENSION amcheck UPDATE TO '1.1'" to load this file. \quit   CREATE FUNCTION bt_index_check(index regclass, heapallindexed boolean) RETURNS VOID AS 'MODULE_PATHNAME', 'bt_index_check' LANGUAGE C STRICT PARALLEL RESTRICTED;
  CREATE FUNCTION bt_index_parent_check(index regclass, heapallindexed boolean) RETURNS VOID AS 'MODULE_PATHNAME', 'bt_index_parent_check' LANGUAGE C STRICT PARALLEL RESTRICTED;
  REVOKE ALL ON FUNCTION bt_index_check(regclass, boolean) FROM PUBLIC;
 REVOKE ALL ON FUNCTION bt_index_parent_check(regclass, boolean) FROM PUBLIC;
 