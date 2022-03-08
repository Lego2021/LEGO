/* contrib/tablefunc/tablefunc--1.0.sql */  \echo Use "CREATE EXTENSION tablefunc" to load this file. \quit  CREATE FUNCTION normal_rand(int4, float8, float8) RETURNS setof float8 AS 'MODULE_PATHNAME','normal_rand' LANGUAGE C VOLATILE STRICT;
  CREATE FUNCTION crosstab(text) RETURNS setof record AS 'MODULE_PATHNAME','crosstab' LANGUAGE C STABLE STRICT;
  CREATE TYPE tablefunc_crosstab_2 AS ( row_name TEXT, category_1 TEXT, category_2 TEXT );
  CREATE TYPE tablefunc_crosstab_3 AS ( row_name TEXT, category_1 TEXT, category_2 TEXT, category_3 TEXT );
  CREATE TYPE tablefunc_crosstab_4 AS ( row_name TEXT, category_1 TEXT, category_2 TEXT, category_3 TEXT, category_4 TEXT );
  CREATE FUNCTION crosstab2(text) RETURNS setof tablefunc_crosstab_2 AS 'MODULE_PATHNAME','crosstab' LANGUAGE C STABLE STRICT;
  CREATE FUNCTION crosstab3(text) RETURNS setof tablefunc_crosstab_3 AS 'MODULE_PATHNAME','crosstab' LANGUAGE C STABLE STRICT;
  CREATE FUNCTION crosstab4(text) RETURNS setof tablefunc_crosstab_4 AS 'MODULE_PATHNAME','crosstab' LANGUAGE C STABLE STRICT;
  CREATE FUNCTION crosstab(text,int) RETURNS setof record AS 'MODULE_PATHNAME','crosstab' LANGUAGE C STABLE STRICT;
  CREATE FUNCTION crosstab(text,text) RETURNS setof record AS 'MODULE_PATHNAME','crosstab_hash' LANGUAGE C STABLE STRICT;
  CREATE FUNCTION connectby(text,text,text,text,int,text) RETURNS setof record AS 'MODULE_PATHNAME','connectby_text' LANGUAGE C STABLE STRICT;
  CREATE FUNCTION connectby(text,text,text,text,int) RETURNS setof record AS 'MODULE_PATHNAME','connectby_text' LANGUAGE C STABLE STRICT;
   CREATE FUNCTION connectby(text,text,text,text,text,int,text) RETURNS setof record AS 'MODULE_PATHNAME','connectby_text_serial' LANGUAGE C STABLE STRICT;
  CREATE FUNCTION connectby(text,text,text,text,text,int) RETURNS setof record AS 'MODULE_PATHNAME','connectby_text_serial' LANGUAGE C STABLE STRICT;
 