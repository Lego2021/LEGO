/* contrib/pgstattuple/pgstattuple--1.0--1.1.sql */  \echo Use "ALTER EXTENSION pgstattuple UPDATE TO '1.1'" to load this file. \quit  CREATE FUNCTION pgstatginindex(IN relname regclass, OUT version INT4, OUT pending_pages INT4, OUT pending_tuples BIGINT) AS 'MODULE_PATHNAME', 'pgstatginindex' LANGUAGE C STRICT;
 