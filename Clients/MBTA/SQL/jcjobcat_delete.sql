
set serveroutput on size 1000000

DECLARE

count1 NUMBER := 0;
total NUMBER := 0;

CURSOR del_record_cur IS
SELECT rowid
FROM jcjobcat
WHERE jcat_comp_code not in ('ZZ');

BEGIN

delete from da1.errors;
commit;

FOR rec IN del_record_cur LOOP
DELETE FROM jcjobcat
WHERE rowid = rec.rowid;

total := total + 1;
count1 := count1 + 1;

IF (count1 >= 1000) THEN
count1 := 0;

	INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
	values(total,'JCJOBCAT','DELETE COMPLETE');
COMMIT;
END IF;

END LOOP;
COMMIT;

DBMS_OUTPUT.PUT_LINE('Deleted ' || total || ' records from JCJOBCAT.');

exception 
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE (SQLERRM);
    END;
/