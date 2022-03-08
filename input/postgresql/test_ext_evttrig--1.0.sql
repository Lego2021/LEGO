/* src/test/modules/test_extensions/test_event_trigger--1.0.sql */ \echo Use "CREATE EXTENSION test_event_trigger" to load this file. \quit  CREATE TABLE t (id text);
 CREATE OR REPLACE FUNCTION _evt_table_rewrite_fnct() RETURNS EVENT_TRIGGER LANGUAGE plpgsql AS $$ BEGIN END;
 $$;
 CREATE EVENT TRIGGER table_rewrite_trg ON table_rewrite EXECUTE PROCEDURE _evt_table_rewrite_fnct();
 