 create function simplesql(int) returns int language sql as 'select $1';
  create function simplecaller() returns int language plpgsql as $$ declare sum int := 0;
 begin for n in 1..10 loop sum := sum + simplesql(n);
 if n = 5 then create or replace function simplesql(int) returns int language sql as 'select $1 + 100';
 end if;
 end loop;
 return sum;
 end$$;
  select simplecaller();
   create schema simple1;
  create function simple1.simpletarget(int) returns int language plpgsql as $$begin return $1;
 end$$;
  create function simpletarget(int) returns int language plpgsql as $$begin return $1 + 100;
 end$$;
  create or replace function simplecaller() returns int language plpgsql as $$ declare sum int := 0;
 begin for n in 1..10 loop sum := sum + simpletarget(n);
 if n = 5 then set local search_path = 'simple1';
 end if;
 end loop;
 return sum;
 end$$;
  select simplecaller();
  alter function simple1.simpletarget(int) immutable;
 alter function simpletarget(int) immutable;
  select simplecaller();
  \c -  select simplecaller();
 