SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SPOOL temp.sql


SELECT 'ALTER TABLE ' || a.table_name || '
DISABLE CONSTRAINT ' || a.constraint_name || ';'
FROM all_constraints a
WHERE a.constraint_type = 'C'
AND a.owner = Upper('&2');
AND a.table_name = DECODE(Upper('&1'),'ALL',a.table_name,UPPER('&1'));


SPOOL OFF

