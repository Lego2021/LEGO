CREATE EXTENSION btree_gin;
  SELECT amname, opcname FROM pg_opclass opc LEFT JOIN pg_am am ON am.oid = opcmethod WHERE opc.oid >= 16384 AND NOT amvalidate(opc.oid);
 