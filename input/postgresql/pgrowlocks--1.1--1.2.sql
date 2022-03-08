/* contrib/pgrowlocks/pgrowlocks--1.1--1.2.sql */  \echo Use "ALTER EXTENSION pgrowlocks UPDATE TO '1.2'" to load this file. \quit  ALTER FUNCTION pgrowlocks(text) PARALLEL SAFE;
 