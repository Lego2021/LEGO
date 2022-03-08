 LOAD 'plperl';
  SET plperl.on_plperlu_init = '$_SHARED{init} = 42';
 DO $$ warn $_SHARED{init} $$ language plperlu;
  CREATE OR REPLACE FUNCTION perl_unicode_regex(text) RETURNS INTEGER AS $$ return ($_[0] =~ /\x{263A}|happy/i) ? 1 : 0;
 # unicode smiley $$ LANGUAGE plperlu;
 