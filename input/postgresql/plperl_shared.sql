  SET plperl.on_plperl_init = '$_SHARED{on_init} = 42';
   create function setme(key text, val text) returns void language plperl as $$  my $key = shift;
 my $val = shift;
 $_SHARED{$key}= $val;
  $$;
  create function getme(key text) returns text language plperl as $$  my $key = shift;
 return $_SHARED{$key};
  $$;
  select setme('ourkey','ourval');
  select getme('ourkey');
  select getme('on_init');
  create or replace function perl_shared() returns int as $$ use strict;
 my $val = $_SHARED{'stuff'};
 $_SHARED{'stuff'} = '1';
 return $val;
 $$ language plperl;
  select perl_shared();
 select perl_shared();
 