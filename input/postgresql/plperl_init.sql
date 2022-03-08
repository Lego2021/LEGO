 LOAD 'plperl';
  SET SESSION plperl.on_plperl_init = ' system("/nonesuch");
 ';
  SHOW plperl.on_plperl_init;
  DO $$ warn 42 $$ language plperl;
 