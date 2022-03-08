/* contrib/lo/lo--1.1.sql */  \echo Use "CREATE EXTENSION lo" to load this file. \quit   CREATE DOMAIN lo AS pg_catalog.oid;
  CREATE FUNCTION lo_oid(lo) RETURNS pg_catalog.oid AS 'SELECT $1::pg_catalog.oid' LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE;
  CREATE FUNCTION lo_manage() RETURNS pg_catalog.trigger AS 'MODULE_PATHNAME' LANGUAGE C;
 