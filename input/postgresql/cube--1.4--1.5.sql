/* contrib/cube/cube--1.4--1.5.sql */  \echo Use "ALTER EXTENSION cube UPDATE TO '1.5'" to load this file. \quit  DROP OPERATOR @ (cube, cube);
 DROP OPERATOR ~ (cube, cube);
  CREATE FUNCTION cube_recv(internal) RETURNS cube AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION cube_send(cube) RETURNS bytea AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  ALTER TYPE cube SET ( RECEIVE = cube_recv, SEND = cube_send );
 