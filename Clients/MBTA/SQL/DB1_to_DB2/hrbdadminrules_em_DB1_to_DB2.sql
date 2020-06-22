

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
SELECT 
  BDR_ORASEQ,
  BDR_RULE_ID,
  BDR_TABLE_BASE,
  BDR_AREA_ID,
  BDR_ELECT_ALL_EMP_FLAG,
  BDR_ELECT_WHEN_HIRE,
  BDR_ROW_CREATION_USER,
  BDR_ROW_CREATION_DATE,
  BDR_LAST_UPD_USER,
  BDR_LAST_UPD_DATE--,
--  BDR__IU__CREATE_DATE,
--  BDR__IU__CREATE_USER,
--  BDR__IU__UPDATE_DATE,
--  BDR__IU__UPDATE_USER
FROM da.HRBDADMINRULES_EM@&from_which_database
where bdr_rule_id not like 'ZZ%' 
and bdr_rule_id not like 'DEF%'
) loop
INSERT INTO da.HRBDADMINRULES_EM@&to_which_database
(  
  BDR_ORASEQ,
  BDR_RULE_ID,
  BDR_TABLE_BASE,
  BDR_AREA_ID,
  BDR_ELECT_ALL_EMP_FLAG,
  BDR_ELECT_WHEN_HIRE,
  BDR_ROW_CREATION_USER,
  BDR_ROW_CREATION_DATE,
  BDR_LAST_UPD_USER,
  BDR_LAST_UPD_DATE--,
--  BDR__IU__CREATE_DATE,
--  BDR__IU__CREATE_USER,
--  BDR__IU__UPDATE_DATE,
--  BDR__IU__UPDATE_USER
)
values
(
i.   BDR_ORASEQ,
i.   BDR_RULE_ID,
i.   BDR_TABLE_BASE,
i.   BDR_AREA_ID,
i.   BDR_ELECT_ALL_EMP_FLAG,
i.   BDR_ELECT_WHEN_HIRE,
i.   BDR_ROW_CREATION_USER,
i.   BDR_ROW_CREATION_DATE,
i.   BDR_LAST_UPD_USER,
i.   BDR_LAST_UPD_DATE--,
--i. --  BDR__IU__CREATE_DATE,
--i. --  BDR__IU__CREATE_USER,
--i. --  BDR__IU__UPDATE_DATE,
--i. BDR__IU__UPDATE_USER

);
end loop;
--commit;
Select count(1) into v_cnt from da.HRBDADMINRULES_EM@&to_which_database
where bdr_rule_id not like 'ZZ%' 
and bdr_rule_id not like 'DEF%';
dbms_output.put_line ('Inserted '||v_cnt||' records into HRBDADMINRULES_EM table.');
select count(1) into v_cnt_&to_which_database from da.HRBDADMINRULES_EM@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.HRBDADMINRULES_EM@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for HRBDADMINRULES_EM table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.HRBDADMINRULES_EM@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 