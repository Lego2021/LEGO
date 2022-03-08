LOAD 'passwordcheck';
  CREATE USER regress_user1;
  ALTER USER regress_user1 PASSWORD 'a_nice_long_password';
  ALTER USER regress_user1 PASSWORD 'tooshrt';
  ALTER USER regress_user1 PASSWORD 'xyzregress_user1';
  ALTER USER regress_user1 PASSWORD 'alessnicelongpassword';
  ALTER USER regress_user1 PASSWORD 'md51a44d829a20a23eac686d9f0d258af13';
  ALTER USER regress_user1 PASSWORD 'md5e589150ae7d28f93333afae92b36ef48';
  DROP USER regress_user1;
 