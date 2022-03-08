CREATE OR REPLACE FUNCTION perl_zerob() RETURNS TEXT AS $$ return "abcd\0efg";
 $$ LANGUAGE plperl;
 SELECT perl_zerob();
 