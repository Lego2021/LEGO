/* src/test/modules/test_regex/test_regex--1.0.sql */  \echo Use "CREATE EXTENSION test_regex" to load this file. \quit  CREATE FUNCTION test_regex(pattern text, string text, flags text) RETURNS SETOF text[] STRICT AS 'MODULE_PATHNAME' LANGUAGE C;
 