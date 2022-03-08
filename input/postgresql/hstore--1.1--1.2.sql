/* contrib/hstore/hstore--1.1--1.2.sql */  \echo Use "ALTER EXTENSION hstore UPDATE TO '1.2'" to load this file. \quit    DO LANGUAGE plpgsql $$ DECLARE my_schema pg_catalog.text := pg_catalog.quote_ident(pg_catalog.current_schema());
 old_path pg_catalog.text := pg_catalog.current_setting('search_path');
 BEGIN PERFORM pg_catalog.set_config('search_path', 'pg_catalog, pg_temp', true);
  PERFORM 1 FROM pg_proc p JOIN  pg_depend d ON p.proname = 'hstore_to_json_loose' AND d.classid = 'pg_proc'::regclass AND d.objid = p.oid AND d.refclassid = 'pg_extension'::regclass JOIN pg_extension x ON d.refobjid = x.oid AND  x.extname = 'hstore';
  IF NOT FOUND THEN PERFORM pg_catalog.set_config('search_path', old_path, true);
  CREATE FUNCTION hstore_to_json(hstore) RETURNS json AS 'MODULE_PATHNAME', 'hstore_to_json' LANGUAGE C IMMUTABLE STRICT;
  CREATE CAST (hstore AS json) WITH FUNCTION hstore_to_json(hstore);
  CREATE FUNCTION hstore_to_json_loose(hstore) RETURNS json AS 'MODULE_PATHNAME', 'hstore_to_json_loose' LANGUAGE C IMMUTABLE STRICT;
  END IF;
  PERFORM pg_catalog.set_config('search_path', old_path, true);
 END;
  $$;
 