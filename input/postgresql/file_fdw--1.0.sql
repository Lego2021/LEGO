/* contrib/file_fdw/file_fdw--1.0.sql */  \echo Use "CREATE EXTENSION file_fdw" to load this file. \quit  CREATE FUNCTION file_fdw_handler() RETURNS fdw_handler AS 'MODULE_PATHNAME' LANGUAGE C STRICT;
  CREATE FUNCTION file_fdw_validator(text[], oid) RETURNS void AS 'MODULE_PATHNAME' LANGUAGE C STRICT;
  CREATE FOREIGN DATA WRAPPER file_fdw HANDLER file_fdw_handler VALIDATOR file_fdw_validator;
 