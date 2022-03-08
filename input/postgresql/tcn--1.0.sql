/* contrib/tcn/tcn--1.0.sql */  \echo Use "CREATE EXTENSION tcn" to load this file. \quit  CREATE FUNCTION triggered_change_notification() RETURNS pg_catalog.trigger AS 'MODULE_PATHNAME' LANGUAGE C;
 