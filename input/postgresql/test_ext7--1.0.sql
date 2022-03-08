/* src/test/modules/test_extensions/test_ext7--1.0.sql */  \echo Use "CREATE EXTENSION test_ext7" to load this file. \quit  alter extension test_ext7 add table old_table1;
 alter extension test_ext7 add sequence old_table1_col1_seq;
  create table ext7_table1 (col1 serial primary key);
  create table ext7_table2 (col2 serial primary key);
 