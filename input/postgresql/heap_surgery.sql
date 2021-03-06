create extension pg_surgery;
  create temp table htab (a int);
 insert into htab values (100), (200), (300), (400), (500);
  select heap_force_freeze('htab'::regclass, ARRAY[]::tid[]);
  select * from htab where xmin = 2;
  select heap_force_freeze('htab'::regclass, ARRAY['(0, 4)']::tid[]);
  select ctid, xmax from htab where xmin = 2;
  select heap_force_kill('htab'::regclass, ARRAY['(0, 4)']::tid[]);
  select * from htab where ctid = '(0, 4)';
  select heap_force_kill('htab'::regclass, ARRAY['(0, 4)']::tid[]);
 select heap_force_freeze('htab'::regclass, ARRAY['(0, 4)']::tid[]);
  select heap_force_freeze('htab'::regclass, ARRAY['(0, 1)', '(0, 3)', '(1, 1)']::tid[]);
  select ctid, xmax from htab where xmin = 2;
  select heap_force_freeze('htab'::regclass, ARRAY['(0, 0)', '(0, 6)']::tid[]);
  create temp table htab2(a int);
 insert into htab2 values (100);
 update htab2 set a = 200;
 vacuum htab2;
  select heap_force_kill('htab2'::regclass, ARRAY['(0, 1)']::tid[]);
  select ctid from htab2;
 update htab2 set a = 300;
 select ctid from htab2;
 vacuum freeze htab2;
  select heap_force_kill('htab2'::regclass, ARRAY['(0, 2)']::tid[]);
  select heap_force_kill('htab2'::regclass, ARRAY[['(0, 2)']]::tid[]);
  select heap_force_kill('htab2'::regclass, ARRAY[NULL]::tid[]);
  select heap_force_kill('htab2'::regclass, ARRAY['(0, 3)']::tid[]);
  begin;
 create materialized view mvw as select a from generate_series(1, 3) a;
  select * from mvw where xmin = 2;
 select heap_force_freeze('mvw'::regclass, ARRAY['(0, 3)']::tid[]);
 select * from mvw where xmin = 2;
  select heap_force_kill('mvw'::regclass, ARRAY['(0, 3)']::tid[]);
 select * from mvw where ctid = '(0, 3)';
 rollback;
  create view vw as select 1;
 select heap_force_kill('vw'::regclass, ARRAY['(0, 1)']::tid[]);
 select heap_force_freeze('vw'::regclass, ARRAY['(0, 1)']::tid[]);
  drop view vw;
 drop extension pg_surgery;
 