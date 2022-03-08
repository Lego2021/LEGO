/* contrib/amcheck/amcheck--1.0.sql */  \echo Use "CREATE EXTENSION amcheck" to load this file. \quit  CREATE FUNCTION bt_index_check(index regclass) RETURNS VOID AS 'MODULE_PATHNAME', 'bt_index_check' LANGUAGE C STRICT PARALLEL RESTRICTED;
  CREATE FUNCTION bt_index_parent_check(index regclass) RETURNS VOID AS 'MODULE_PATHNAME', 'bt_index_parent_check' LANGUAGE C STRICT PARALLEL RESTRICTED;
  REVOKE ALL ON FUNCTION bt_index_check(regclass) FROM PUBLIC;
 REVOKE ALL ON FUNCTION bt_index_parent_check(regclass) FROM PUBLIC;
 