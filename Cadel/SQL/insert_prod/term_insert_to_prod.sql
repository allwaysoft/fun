
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  TERM_COMP_CODE,
  TERM_CODE,
  TERM_DUE_MODAY,
  TERM_DUE_DAY,
  TERM_DISC_DAY,
  TERM_PC,
  TERM_HLDBK_PC,
  TERM_NAME,
  TERM_CTRL_CODE,
  TERM_DISC_MONTH_DAY,
  TERM__IU__CREATE_DATE,
  TERM__IU__CREATE_USER,
  TERM__IU__UPDATE_DATE,
  TERM__IU__UPDATE_USER
FROM DA.TERM@CONV 
WHERE term_comp_code NOT IN ('ZZ')
) loop
INSERT INTO DA.TERM
( 
  TERM_COMP_CODE,
  TERM_CODE,
  TERM_DUE_MODAY,
  TERM_DUE_DAY,
  TERM_DISC_DAY,
  TERM_PC,
  TERM_HLDBK_PC,
  TERM_NAME,
  TERM_CTRL_CODE,
  TERM_DISC_MONTH_DAY--,
  --TERM__IU__CREATE_DATE,
  --TERM__IU__CREATE_USER,
  --TERM__IU__UPDATE_DATE,
  --TERM__IU__UPDATE_USER
)
values
(
i.  TERM_COMP_CODE,
i.  TERM_CODE,
i.  TERM_DUE_MODAY,
i.  TERM_DUE_DAY,
i.  TERM_DISC_DAY,
i.  TERM_PC,
i.  TERM_HLDBK_PC,
i.  TERM_NAME,
i.  TERM_CTRL_CODE,
i.  TERM_DISC_MONTH_DAY--,
--i.  --TERM__IU__CREATE_DATE,
--i.  --TERM__IU__CREATE_USER,
--i.  --TERM__IU__UPDATE_DATE,
--i.  --TERM__IU__UPDATE_USER
);
end loop;
--commit;
select count(1) into v_cnt_conv from TERM@conv;
select count(1) into v_cnt_prod from TERM@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for TERM table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for TERM table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.TERM@PROD where term_comp_code NOT IN ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into TERM table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.TERM.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 