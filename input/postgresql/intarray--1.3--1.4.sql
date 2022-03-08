/* contrib/intarray/intarray--1.3--1.4.sql */  \echo Use "ALTER EXTENSION intarray UPDATE TO '1.4'" to load this file. \quit   ALTER OPERATOR FAMILY gist__int_ops USING gist DROP OPERATOR 8 (_int4, _int4);
  ALTER OPERATOR FAMILY gist__intbig_ops USING gist DROP OPERATOR 8 (_int4, _int4);
   ALTER OPERATOR FAMILY gist__int_ops USING gist DROP OPERATOR 14 (_int4, _int4);
  ALTER OPERATOR FAMILY gist__intbig_ops USING gist DROP OPERATOR 14 (_int4, _int4);
 