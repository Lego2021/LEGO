 alter table t1 rename t2;
  alter table t2 modify a tinyint not null, change b c char(20);
  alter table t2 add d datetime;
  alter table t2 add index (d), add index (a);
  alter table t2 drop column c;
 