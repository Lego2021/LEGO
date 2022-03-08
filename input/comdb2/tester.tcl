SELECT tbl_name AS t FROM sqlite_master WHERE type = 'table';
SELECT sqlite_source_id();
SELECT sqlite_source_id();
SELECT * FROM sqlite_master;
      SELECT name, type, sql FROM sqlite_master order by name;
      SELECT name FROM sqlite_master WHERE type='table' order by name;
      SELECT name FROM sqlite_master WHERE type = 'table' UNION      SELECT 'sqlite_master' ORDER BY 1;
    SELECT name FROM sqlite_master WHERE type='index' AND sql LIKE 'create%';
 SELECT * FROM sqlite_master;
