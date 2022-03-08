 create function infinite_recurse() returns int as 'select infinite_recurse()' language sql;
   SELECT version() ~ 'powerpc64[^,]*-linux-gnu' AS skip_test \gset \if :skip_test \quit \endif   \set VERBOSITY sqlstate  select infinite_recurse();
  \echo :LAST_ERROR_MESSAGE 