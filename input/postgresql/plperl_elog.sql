 create or replace function perl_elog(text) returns void language plperl as $$  my $msg = shift;
 elog(NOTICE,$msg);
  $$;
  select perl_elog('explicit elog');
  create or replace function perl_warn(text) returns void language plperl as $$  my $msg = shift;
 warn($msg);
  $$;
  select perl_warn('implicit elog via warn');
   SET plperl.use_strict = true;
  create or replace function uses_global() returns text language plperl as $$  $global = 1;
 $other_global = 2;
 return 'uses_global worked';
  $$;
  select uses_global();
  SET plperl.use_strict = false;
  create or replace function uses_global() returns text language plperl as $$  $global = 1;
 $other_global=2;
 return 'uses_global worked';
  $$;
  select uses_global();
  do language plperl $$ elog(NOTICE, ${^TAINT});
 $$;
   create or replace function just_die() returns void language plperl AS $$ die "just die";
 $$;
  select just_die();
  create or replace function die_caller() returns int language plpgsql as $$ BEGIN BEGIN PERFORM just_die();
 EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'caught die';
 END;
 RETURN 1;
 END;
 $$;
  select die_caller();
  create or replace function indirect_die_caller() returns int language plperl as $$ my $prepared = spi_prepare('SELECT die_caller() AS fx');
 my $a = spi_exec_prepared($prepared)->{rows}->[0]->{fx};
 my $b = spi_exec_prepared($prepared)->{rows}->[0]->{fx};
 return $a + $b;
 $$;
  select indirect_die_caller();
   SET client_encoding TO UTF8;
  create or replace function error_with_nbsp() returns void language plperl as $$ elog(ERROR, "this message contains a no-break space");
 $$;
  select error_with_nbsp();
 