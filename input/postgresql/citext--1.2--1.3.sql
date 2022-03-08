/* contrib/citext/citext--1.2--1.3.sql */  \echo Use "ALTER EXTENSION citext UPDATE TO '1.3'" to load this file. \quit  DO LANGUAGE plpgsql $$ DECLARE my_schema pg_catalog.text := pg_catalog.quote_ident(pg_catalog.current_schema());
 old_path pg_catalog.text := pg_catalog.current_setting('search_path');
 BEGIN PERFORM pg_catalog.set_config('search_path', 'pg_catalog, pg_temp', true);
  UPDATE pg_aggregate SET aggcombinefn = (my_schema || '.citext_smaller')::regproc WHERE aggfnoid = (my_schema || '.min(' || my_schema || '.citext)')::pg_catalog.regprocedure;
  PERFORM pg_catalog.set_config('search_path', old_path, true);
 END $$;
 