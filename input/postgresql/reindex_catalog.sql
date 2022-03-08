  REINDEX TABLE pg_class;
 -- mapped, non-shared, critical REINDEX TABLE pg_index;
 -- non-mapped, non-shared, critical REINDEX TABLE pg_operator;
 -- non-mapped, non-shared, critical REINDEX TABLE pg_database;
 -- mapped, shared, critical REINDEX TABLE pg_shdescription;
 -- mapped, shared non-critical  REINDEX INDEX pg_class_oid_index;
 -- mapped, non-shared, critical REINDEX INDEX pg_class_relname_nsp_index;
 -- mapped, non-shared, non-critical REINDEX INDEX pg_index_indexrelid_index;
 -- non-mapped, non-shared, critical REINDEX INDEX pg_index_indrelid_index;
 -- non-mapped, non-shared, non-critical REINDEX INDEX pg_database_oid_index;
 -- mapped, shared, critical REINDEX INDEX pg_shdescription_o_c_index;
 -- mapped, shared, non-critical  BEGIN;
 SET min_parallel_table_scan_size = 0;
 REINDEX INDEX pg_class_oid_index;
 -- mapped, non-shared, critical REINDEX INDEX pg_class_relname_nsp_index;
 -- mapped, non-shared, non-critical REINDEX INDEX pg_index_indexrelid_index;
 -- non-mapped, non-shared, critical REINDEX INDEX pg_index_indrelid_index;
 -- non-mapped, non-shared, non-critical REINDEX INDEX pg_database_oid_index;
 -- mapped, shared, critical REINDEX INDEX pg_shdescription_o_c_index;
 -- mapped, shared, non-critical ROLLBACK;
 