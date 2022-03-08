 SELECT crypt('', '_J9..j2zz');
  SELECT crypt('foox', '_J9..j2zz');
  SELECT crypt('longlongpassword', '_J9..j2zz');
  SELECT crypt('foox', '_J9..BWH');
  SELECT crypt('password', '_........');
  SELECT crypt('password', '_..!!!!!!');
  SELECT crypt('password', '_/!!!!!!!');
  CREATE TABLE ctest (data text, res text, salt text);
 INSERT INTO ctest VALUES ('password', '', '');
  UPDATE ctest SET salt = gen_salt('xdes', 1001);
 UPDATE ctest SET res = crypt(data, salt);
 SELECT res = crypt(data, res) AS "worked" FROM ctest;
  DROP TABLE ctest;
 