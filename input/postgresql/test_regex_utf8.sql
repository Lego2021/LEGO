/* * This test must be run in a database with UTF-8 encoding, * because other encodings don't support all the characters used. */  SELECT getdatabaseencoding() <> 'UTF8' AS skip_test \gset \if :skip_test \quit \endif  set client_encoding = utf8;
  set standard_conforming_strings = on;
    select * from test_regex('a[\u00fe-\u0507][\u00ff-\u0300]b', E'a\u0102\u02ffb', 'EMP*');
  select * from test_regex('a\U00001234x', E'a\u1234x', 'P');
 select * from test_regex('a\U00001234x', E'a\u1234x', 'P');
 select * from test_regex('a\U0001234x', E'a\u1234x', 'P');
 select * from test_regex('a\U0001234x', E'a\u1234x', 'P');
 select * from test_regex('a\U000012345x', E'a\u12345x', 'P');
 select * from test_regex('a\U000012345x', E'a\u12345x', 'P');
 select * from test_regex('a\U1000000x', E'a\ufffd0x', 'P');
 select * from test_regex('a\U1000000x', E'a\ufffd0x', 'P');
    select * from test_regex('a [\u1000-\u1100]* [\u3000-\u3100]* [\u1234-\u25ff]+ [\u2000-\u35ff]* [\u2600-\u2f00]* \u1236\u1236x', E'a\u1234\u1236\u1236x', 'xEMP');
  select * from test_regex('[[:alnum:]]*[[:upper:]]*[\u1000-\u2000]*\u1237', E'\u1500\u1237', 'ELMP');
 select * from test_regex('[[:alnum:]]*[[:upper:]]*[\u1000-\u2000]*\u1237', E'A\u1239', 'ELMP');
 