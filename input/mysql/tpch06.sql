 define 1 = 1994-01-01 define 2 = 0.06 define 3 = 24  select sum(l_extendedprice * l_discount) as revenue from lineitem where l_shipdate >= date '&1' and l_shipdate < date '&1' + interval '1' year and l_discount between &2 - 0.01 and &2 + 0.01 and l_quantity < &3;
  