 create function explain_resultcache(query text, hide_hitmiss bool) returns setof text language plpgsql as $$ declare ln text;
 begin for ln in execute format('explain (analyze, costs off, summary off, timing off) %s', query) loop if hide_hitmiss = true then ln := regexp_replace(ln, 'Hits: 0', 'Hits: Zero');
 ln := regexp_replace(ln, 'Hits: \d+', 'Hits: N');
 ln := regexp_replace(ln, 'Misses: 0', 'Misses: Zero');
 ln := regexp_replace(ln, 'Misses: \d+', 'Misses: N');
 end if;
 ln := regexp_replace(ln, 'Evictions: 0', 'Evictions: Zero');
 ln := regexp_replace(ln, 'Evictions: \d+', 'Evictions: N');
 ln := regexp_replace(ln, 'Memory Usage: \d+', 'Memory Usage: N');
 ln := regexp_replace(ln, 'Heap Fetches: \d+', 'Heap Fetches: N');
 ln := regexp_replace(ln, 'loops=\d+', 'loops=N');
 return next ln;
 end loop;
 end;
 $$;
  SET enable_hashjoin TO off;
 SET enable_bitmapscan TO off;
  SELECT explain_resultcache(' SELECT COUNT(*),AVG(t1.unique1) FROM tenk1 t1 INNER JOIN tenk1 t2 ON t1.unique1 = t2.twenty WHERE t2.unique1 < 1000;
', false);
  SELECT COUNT(*),AVG(t1.unique1) FROM tenk1 t1 INNER JOIN tenk1 t2 ON t1.unique1 = t2.twenty WHERE t2.unique1 < 1000;
  SELECT explain_resultcache(' SELECT COUNT(*),AVG(t2.unique1) FROM tenk1 t1, LATERAL (SELECT t2.unique1 FROM tenk1 t2 WHERE t1.twenty = t2.unique1) t2 WHERE t1.unique1 < 1000;
', false);
  SELECT COUNT(*),AVG(t2.unique1) FROM tenk1 t1, LATERAL (SELECT t2.unique1 FROM tenk1 t2 WHERE t1.twenty = t2.unique1) t2 WHERE t1.unique1 < 1000;
  SET work_mem TO '64kB';
 SET enable_mergejoin TO off;
 SELECT explain_resultcache(' SELECT COUNT(*),AVG(t1.unique1) FROM tenk1 t1 INNER JOIN tenk1 t2 ON t1.unique1 = t2.thousand WHERE t2.unique1 < 1200;
', true);
 RESET enable_mergejoin;
 RESET work_mem;
 RESET enable_bitmapscan;
 RESET enable_hashjoin;
  SET min_parallel_table_scan_size TO 0;
 SET parallel_setup_cost TO 0;
 SET parallel_tuple_cost TO 0;
 SET max_parallel_workers_per_gather TO 2;
  EXPLAIN (COSTS OFF) SELECT COUNT(*),AVG(t2.unique1) FROM tenk1 t1, LATERAL (SELECT t2.unique1 FROM tenk1 t2 WHERE t1.twenty = t2.unique1) t2 WHERE t1.unique1 < 1000;
  SELECT COUNT(*),AVG(t2.unique1) FROM tenk1 t1, LATERAL (SELECT t2.unique1 FROM tenk1 t2 WHERE t1.twenty = t2.unique1) t2 WHERE t1.unique1 < 1000;
  RESET max_parallel_workers_per_gather;
 RESET parallel_tuple_cost;
 RESET parallel_setup_cost;
 RESET min_parallel_table_scan_size;
 