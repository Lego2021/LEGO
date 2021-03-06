 SET client_encoding TO UTF8;
  CREATE TABLE unicode_test ( testvalue  text NOT NULL );
  CREATE FUNCTION unicode_return() RETURNS text AS $$ return "\xA0" $$ LANGUAGE pltcl;
  CREATE FUNCTION unicode_trigger() RETURNS trigger AS $$ set NEW(testvalue) "\xA0" return [array get NEW] $$ LANGUAGE pltcl;
  CREATE TRIGGER unicode_test_bi BEFORE INSERT ON unicode_test FOR EACH ROW EXECUTE PROCEDURE unicode_trigger();
  CREATE FUNCTION unicode_plan1() RETURNS text AS $$ set plan [ spi_prepare {SELECT $1 AS testvalue} [ list "text" ] ] spi_execp $plan [ list "\xA0" ] return $testvalue $$ LANGUAGE pltcl;
   SELECT unicode_return();
 INSERT INTO unicode_test (testvalue) VALUES ('test');
 SELECT * FROM unicode_test;
 SELECT unicode_plan1();
 