
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
  PLN_CODE,
  PLN_DESCRIPTION,
  PLN_SHORT_DESC,
  PLN_USER,
  PLN_LAST_UPD_DATE,
  PLN_DEP_COV_LEVEL,
  PLN_MAX_AGE_IN_SCHOOL_NUM,
  PLN_MAX_AGE_NOT_IN_SCHOOL_NUM--,
--  PLN__IU__CREATE_DATE,
--  PLN__IU__CREATE_USER,
--  PLN__IU__UPDATE_DATE,
--  PLN__IU__UPDATE_USER
FROM da.PYBDPLAN@&from_which_database
where to_date(pln_last_upd_date,'dd-mon-yy') < to_date('30-dec-99','dd-mon-yy') 
and to_date(pln_last_upd_date,'dd-mon-yy') > to_date('24-feb-05','dd-mon-yy')
) loop
INSERT INTO da.PYBDPLAN@&to_which_database
(  
  PLN_CODE,
  PLN_DESCRIPTION,
  PLN_SHORT_DESC,
  PLN_USER,
  PLN_LAST_UPD_DATE,
  PLN_DEP_COV_LEVEL,
  PLN_MAX_AGE_IN_SCHOOL_NUM,
  PLN_MAX_AGE_NOT_IN_SCHOOL_NUM--,
--  PLN__IU__CREATE_DATE,
--  PLN__IU__CREATE_USER,
--  PLN__IU__UPDATE_DATE,
--  PLN__IU__UPDATE_USER
)
values
(
i.   PLN_CODE,
i.   PLN_DESCRIPTION,
i.   PLN_SHORT_DESC,
i.   PLN_USER,
i.   PLN_LAST_UPD_DATE,
i.   PLN_DEP_COV_LEVEL,
i.   PLN_MAX_AGE_IN_SCHOOL_NUM,
i.   PLN_MAX_AGE_NOT_IN_SCHOOL_NUM--,
--i. --  PLN__IU__CREATE_DATE,
--i. --  PLN__IU__CREATE_USER,
--i. --  PLN__IU__UPDATE_DATE,
--i. PLN__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYBDPLAN@&to_which_database
where to_date(pln_last_upd_date,'dd-mon-yy') < to_date('30-dec-99','dd-mon-yy') 
and to_date(pln_last_upd_date,'dd-mon-yy') > to_date('24-feb-05','dd-mon-yy');
dbms_output.put_line ('Inserted '||v_cnt||' records into PYBDPLAN table.');
select count(1) into v_cnt_&to_which_database from da.PYBDPLAN@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYBDPLAN@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYBDPLAN table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYBDPLAN@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 