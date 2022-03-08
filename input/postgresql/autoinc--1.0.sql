/* contrib/spi/autoinc--1.0.sql */  \echo Use "CREATE EXTENSION autoinc" to load this file. \quit  CREATE FUNCTION autoinc() RETURNS trigger AS 'MODULE_PATHNAME' LANGUAGE C;
 