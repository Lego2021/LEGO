/* contrib/intagg/intagg--1.1.sql */  \echo Use "CREATE EXTENSION intagg" to load this file. \quit  CREATE FUNCTION int_agg_state (internal, int4) RETURNS internal AS 'array_agg_transfn' PARALLEL SAFE LANGUAGE INTERNAL;
  CREATE FUNCTION int_agg_final_array (internal) RETURNS int4[] AS 'array_agg_finalfn' PARALLEL SAFE LANGUAGE INTERNAL;
  CREATE AGGREGATE int_array_aggregate(int4) ( SFUNC = int_agg_state, STYPE = internal, FINALFUNC = int_agg_final_array, PARALLEL = SAFE );
  CREATE FUNCTION int_array_enum(int4[]) RETURNS setof integer AS 'array_unnest' LANGUAGE INTERNAL IMMUTABLE STRICT PARALLEL SAFE;
 