
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
select   
  PPR_COMP_CODE,
  PPR_PRN_CODE,
  PPR_YEAR,
  PPR_TOTAL_PERIODS,
  PPR_CHQ_NAME,
  PPR_STUB_DEF,
  PPR_STUB_RATE_FLAG,
  PPR_CHECK_RATE_FLAG,
  PPR_USER,
  PPR_LAST_UPD_DATE--,
  --PPR__IU__CREATE_DATE,
  --PPR__IU__CREATE_USER,
  --PPR__IU__UPDATE_DATE,
  --PPR__IU__UPDATE_USER 
from pypayprd@&from_which_database
where ppr_comp_code not in ('ZZ')
) loop
INSERT INTO da.PYPAYPRD@&to_which_database
(  
  PPR_COMP_CODE,
  PPR_PRN_CODE,
  PPR_YEAR,
  PPR_TOTAL_PERIODS,
  PPR_CHQ_NAME,
  PPR_STUB_DEF,
  PPR_STUB_RATE_FLAG,
  PPR_CHECK_RATE_FLAG,
  PPR_USER,
  PPR_LAST_UPD_DATE--,
  --PPR__IU__CREATE_DATE,
  --PPR__IU__CREATE_USER,
  --PPR__IU__UPDATE_DATE,
  --PPR__IU__UPDATE_USER 
)
values
(
i.  PPR_COMP_CODE,
i.  PPR_PRN_CODE,
i.  PPR_YEAR,
i.  PPR_TOTAL_PERIODS,
i.  PPR_CHQ_NAME,
i.  PPR_STUB_DEF,
i.  PPR_STUB_RATE_FLAG,
i.  PPR_CHECK_RATE_FLAG,
i.  PPR_USER,
i.  PPR_LAST_UPD_DATE--,
--i.  --PPR__IU__CREATE_DATE,
--i.  --PPR__IU__CREATE_USER,
--i.  --PPR__IU__UPDATE_DATE,
--i.  --PPR__IU__UPDATE_USER 

);
end loop;
--commit;
Select count(1) into v_cnt from da.pypayprd@&to_which_database
where ppr_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into pypayprd table.');
select count(1) into v_cnt_&to_which_database from da.pypayprd@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.pypayprd@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for pypayprd table, check and commit.');
else
dbms_output.put_line ('Number of records in PROD does not match with &to_which_database for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &from_which_database and &to_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.pypayprd@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 