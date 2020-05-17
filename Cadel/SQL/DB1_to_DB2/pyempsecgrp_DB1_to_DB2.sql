
SET VERIFY OFF 
SET serveroutput on size 1000000

accept from_which_database prompt 'Insert from which database:'
accept to_which_database prompt 'Insert to which database:'

declare

v_cnt      NUMBER;
v_cnt_&to_which_database NUMBER;
v_cnt_&from_which_database NUMBER;
record_count_mismatch exception;

begin

dbms_output.put_line(chr(9));

for i in
(
SELECT ESG_CODE,
  ESG_NAME--,
  --ESG__IU__CREATE_DATE,
  --ESG__IU__CREATE_USER,
  --ESG__IU__UPDATE_DATE,
  --ESG__IU__UPDATE_USER
FROM PYEMPSECGRP@&from_which_database
where ESG_CODE not in (SELECT DISTINCT ESG_CODE FROM PYEMPSECGRP@&to_which_database)
) loop
INSERT INTO DA.PYEMPSECGRP@&to_which_database
( 
  ESG_CODE, 
  ESG_NAME--,
  --ESG__IU__CREATE_DATE,
  --ESG__IU__CREATE_USER,
  --ESG__IU__UPDATE_DATE,
  --ESG__IU__UPDATE_USER

)
values
(
  i.ESG_CODE, 
  i.ESG_NAME--,
  --ESG__IU__CREATE_DATE,
  --ESG__IU__CREATE_USER,
  --ESG__IU__UPDATE_DATE,
  --ESG__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYEMPSECGRP@&to_which_database
where ESG_CODE not in (SELECT DISTINCT ESG_CODE FROM PYEMPSECGRP@&to_which_database);
dbms_output.put_line ('Inserted '||v_cnt||' records into PYEMPSECGRP table.');
select count(1) into v_cnt_&to_which_database from da.PYEMPSECGRP@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYEMPSECGRP@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYEMPSECGRP table, check and commit.');
else
dbms_output.put_line ('Number of records in &from_which_database does not match with &to_which_database for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &from_which_database and &to_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYEMPSECGRP@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 