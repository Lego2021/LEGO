  CREATE USER regress_user1;
 CREATE USER regress_user2;
  SET ROLE regress_user1;
  CREATE EXTENSION plperl;
  -- fail CREATE EXTENSION plperlu;
  -- fail  RESET ROLE;
  DO $$ begin execute format('grant create on database %I to regress_user1', current_database());
 end;
 $$;
  SET ROLE regress_user1;
  CREATE EXTENSION plperl;
 CREATE EXTENSION plperlu;
  -- fail  CREATE FUNCTION foo1() returns int language plperl as '1;
';
 SELECT foo1();
  \c -  SET ROLE regress_user1;
  revoke all on language plperl from public;
  SET ROLE regress_user2;
  CREATE FUNCTION foo2() returns int language plperl as '2;
';
  -- fail  SET ROLE regress_user1;
  grant usage on language plperl to regress_user2;
  SET ROLE regress_user2;
  CREATE FUNCTION foo2() returns int language plperl as '2;
';
 SELECT foo2();
  SET ROLE regress_user1;
  DROP LANGUAGE plperl CASCADE;
 DROP EXTENSION plperl CASCADE;
  RESET ROLE;
 DROP OWNED BY regress_user1;
 DROP USER regress_user1;
 DROP USER regress_user2;
  CREATE EXTENSION plperl;
 CREATE EXTENSION plperlu;
 