

declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(SELECT REG_CODE,
  REG_NAME--,
  --REG__IU__CREATE_DATE,
  --REG__IU__CREATE_USER,
  --REG__IU__UPDATE_DATE,
  --REG__IU__UPDATE_USER
FROM DA.REGION@CONV 
WHERE REG_CODE NOT IN ('IL','NY','CA','FL','AR')
) loop
INSERT INTO DA.REGION
( 
  REG_CODE,
  REG_NAME--,
  --REG__IU__CREATE_DATE,
  --REG__IU__CREATE_USER,
  --REG__IU__UPDATE_DATE,
  --REG__IU__UPDATE_USER
)
values
(
i.  REG_CODE,
i.  REG_NAME--,
--i.  REG__IU__CREATE_DATE,
--i.  REG__IU__CREATE_USER,
--i.  REG__IU__UPDATE_DATE,
--i.  REG__IU__UPDATE_USER

);
end loop;
--commit;
select count(1) into v_cnt_conv from region@conv;
select count(1) into v_cnt_prod from region@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for REGION table');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for REGION table');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.REGION@PROD where REG_CODE NOT IN ('IL','NY','CA','FL','AR');
dbms_output.put_line ('Inserted '||v_cnt||' records into REGION table, check and commit');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.REGION');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 