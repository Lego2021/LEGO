 CREATE SCHEMA foo;
  CREATE SCHEMA IF NOT EXISTS bar;
  CREATE SCHEMA baz;
  CREATE SCHEMA IF NOT EXISTS baz;
  CREATE SCHEMA element_test CREATE TABLE foo (id int) CREATE VIEW bar AS SELECT * FROM foo;
 