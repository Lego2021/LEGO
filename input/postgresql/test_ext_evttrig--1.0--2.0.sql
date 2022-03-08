/* src/test/modules/test_extensions/test_event_trigger--1.0--2.0.sql */ \echo Use "ALTER EXTENSION test_event_trigger UPDATE TO '2.0'" to load this file. \quit  ALTER EVENT TRIGGER table_rewrite_trg DISABLE;
 ALTER TABLE t DROP COLUMN id;
 