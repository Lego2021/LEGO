/* contrib/spi/moddatetime--1.0.sql */  \echo Use "CREATE EXTENSION moddatetime" to load this file. \quit  CREATE FUNCTION moddatetime() RETURNS trigger AS 'MODULE_PATHNAME' LANGUAGE C;
 