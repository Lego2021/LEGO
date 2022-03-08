/* contrib/pg_trgm/pg_trgm--1.3.sql */  \echo Use "CREATE EXTENSION pg_trgm" to load this file. \quit  CREATE FUNCTION set_limit(float4) RETURNS float4 AS 'MODULE_PATHNAME' LANGUAGE C STRICT VOLATILE PARALLEL UNSAFE;
  CREATE FUNCTION show_limit() RETURNS float4 AS 'MODULE_PATHNAME' LANGUAGE C STRICT STABLE PARALLEL SAFE;
  CREATE FUNCTION show_trgm(text) RETURNS _text AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE FUNCTION similarity(text,text) RETURNS float4 AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE FUNCTION similarity_op(text,text) RETURNS bool AS 'MODULE_PATHNAME' LANGUAGE C STRICT STABLE PARALLEL SAFE;
  -- stable because depends on pg_trgm.similarity_threshold  CREATE OPERATOR % ( LEFTARG = text, RIGHTARG = text, PROCEDURE = similarity_op, COMMUTATOR = '%', RESTRICT = contsel, JOIN = contjoinsel );
  CREATE FUNCTION word_similarity(text,text) RETURNS float4 AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE FUNCTION word_similarity_op(text,text) RETURNS bool AS 'MODULE_PATHNAME' LANGUAGE C STRICT STABLE PARALLEL SAFE;
  -- stable because depends on pg_trgm.word_similarity_threshold  CREATE FUNCTION word_similarity_commutator_op(text,text) RETURNS bool AS 'MODULE_PATHNAME' LANGUAGE C STRICT STABLE PARALLEL SAFE;
  -- stable because depends on pg_trgm.word_similarity_threshold  CREATE OPERATOR <% ( LEFTARG = text, RIGHTARG = text, PROCEDURE = word_similarity_op, COMMUTATOR = '%>', RESTRICT = contsel, JOIN = contjoinsel );
  CREATE OPERATOR %> ( LEFTARG = text, RIGHTARG = text, PROCEDURE = word_similarity_commutator_op, COMMUTATOR = '<%', RESTRICT = contsel, JOIN = contjoinsel );
  CREATE FUNCTION similarity_dist(text,text) RETURNS float4 AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE OPERATOR <-> ( LEFTARG = text, RIGHTARG = text, PROCEDURE = similarity_dist, COMMUTATOR = '<->' );
  CREATE FUNCTION word_similarity_dist_op(text,text) RETURNS float4 AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE FUNCTION word_similarity_dist_commutator_op(text,text) RETURNS float4 AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE OPERATOR <<-> ( LEFTARG = text, RIGHTARG = text, PROCEDURE = word_similarity_dist_op, COMMUTATOR = '<->>' );
  CREATE OPERATOR <->> ( LEFTARG = text, RIGHTARG = text, PROCEDURE = word_similarity_dist_commutator_op, COMMUTATOR = '<<->' );
  CREATE FUNCTION gtrgm_in(cstring) RETURNS gtrgm AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE FUNCTION gtrgm_out(gtrgm) RETURNS cstring AS 'MODULE_PATHNAME' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;
  CREATE TYPE gtrgm ( INTERNALLENGTH = -1, INPUT = gtrgm_in, OUTPUT = gtrgm_out );
  CREATE FUNCTION gtrgm_consistent(internal,text,smallint,oid,internal) RETURNS bool AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gtrgm_distance(internal,text,smallint,oid,internal) RETURNS float8 AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gtrgm_compress(internal) RETURNS internal AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gtrgm_decompress(internal) RETURNS internal AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gtrgm_penalty(internal,internal,internal) RETURNS internal AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gtrgm_picksplit(internal, internal) RETURNS internal AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gtrgm_union(internal, internal) RETURNS gtrgm AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gtrgm_same(gtrgm, gtrgm, internal) RETURNS internal AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE OPERATOR CLASS gist_trgm_ops FOR TYPE text USING gist AS OPERATOR        1       % (text, text), FUNCTION        1       gtrgm_consistent (internal, text, smallint, oid, internal), FUNCTION        2       gtrgm_union (internal, internal), FUNCTION        3       gtrgm_compress (internal), FUNCTION        4       gtrgm_decompress (internal), FUNCTION        5       gtrgm_penalty (internal, internal, internal), FUNCTION        6       gtrgm_picksplit (internal, internal), FUNCTION        7       gtrgm_same (gtrgm, gtrgm, internal), STORAGE         gtrgm;
   ALTER OPERATOR FAMILY gist_trgm_ops USING gist ADD OPERATOR        2       <-> (text, text) FOR ORDER BY pg_catalog.float_ops, OPERATOR        3       pg_catalog.~~ (text, text), OPERATOR        4       pg_catalog.~~* (text, text), FUNCTION        8 (text, text)  gtrgm_distance (internal, text, smallint, oid, internal);
   ALTER OPERATOR FAMILY gist_trgm_ops USING gist ADD OPERATOR        5       pg_catalog.~ (text, text), OPERATOR        6       pg_catalog.~* (text, text);
   ALTER OPERATOR FAMILY gist_trgm_ops USING gist ADD OPERATOR        7       %> (text, text), OPERATOR        8       <->> (text, text) FOR ORDER BY pg_catalog.float_ops;
  CREATE FUNCTION gin_extract_value_trgm(text, internal) RETURNS internal AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gin_extract_query_trgm(text, internal, int2, internal, internal, internal, internal) RETURNS internal AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE FUNCTION gin_trgm_consistent(internal, int2, text, int4, internal, internal, internal, internal) RETURNS bool AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  CREATE OPERATOR CLASS gin_trgm_ops FOR TYPE text USING gin AS OPERATOR        1       % (text, text), FUNCTION        1       btint4cmp (int4, int4), FUNCTION        2       gin_extract_value_trgm (text, internal), FUNCTION        3       gin_extract_query_trgm (text, internal, int2, internal, internal, internal, internal), FUNCTION        4       gin_trgm_consistent (internal, int2, text, int4, internal, internal, internal, internal), STORAGE         int4;
   ALTER OPERATOR FAMILY gin_trgm_ops USING gin ADD OPERATOR        3       pg_catalog.~~ (text, text), OPERATOR        4       pg_catalog.~~* (text, text);
   ALTER OPERATOR FAMILY gin_trgm_ops USING gin ADD OPERATOR        5       pg_catalog.~ (text, text), OPERATOR        6       pg_catalog.~* (text, text);
   CREATE FUNCTION gin_trgm_triconsistent(internal, int2, text, int4, internal, internal, internal) RETURNS "char" AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
  ALTER OPERATOR FAMILY gin_trgm_ops USING gin ADD OPERATOR        7       %> (text, text), FUNCTION        6      (text,text) gin_trgm_triconsistent (internal, int2, text, int4, internal, internal, internal);
 