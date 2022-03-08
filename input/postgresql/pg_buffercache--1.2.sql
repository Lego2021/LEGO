/* contrib/pg_buffercache/pg_buffercache--1.2.sql */  \echo Use "CREATE EXTENSION pg_buffercache" to load this file. \quit  CREATE FUNCTION pg_buffercache_pages() RETURNS SETOF RECORD AS 'MODULE_PATHNAME', 'pg_buffercache_pages' LANGUAGE C PARALLEL SAFE;
  CREATE VIEW pg_buffercache AS SELECT P.* FROM pg_buffercache_pages() AS P (bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relforknumber int2, relblocknumber int8, isdirty bool, usagecount int2, pinning_backends int4);
  REVOKE ALL ON FUNCTION pg_buffercache_pages() FROM PUBLIC;
 REVOKE ALL ON pg_buffercache FROM PUBLIC;
 