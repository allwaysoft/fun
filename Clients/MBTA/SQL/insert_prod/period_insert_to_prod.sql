
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  PER_CONSCHART_CODE,
  PER_YR,
  PER_PER,
  PER_START_DATE,
  PER_END_DATE,
  PER_ADJ_FLAG,
  PER_SEQ_NUM,
  PER_OPEN_PERIOD_FLAG--,
  --PER__IU__CREATE_DATE,
  --PER__IU__CREATE_USER,
  --PER__IU__UPDATE_DATE,
  --PER__IU__UPDATE_USER,
  --PER_OBJECT_ORASEQ  
FROM DA.PERIOD@CONV 
WHERE PER_CONSCHART_CODE NOT IN ('ZZCHART')
) loop
INSERT INTO DA.PERIOD@PROD
( 
  PER_CONSCHART_CODE,
  PER_YR,
  PER_PER,
  PER_START_DATE,
  PER_END_DATE,
  PER_ADJ_FLAG,
  PER_SEQ_NUM,
  PER_OPEN_PERIOD_FLAG--,
  --PER__IU__CREATE_DATE,
  --PER__IU__CREATE_USER,
  --PER__IU__UPDATE_DATE,
  --PER__IU__UPDATE_USER,
  --PER_OBJECT_ORASEQ  
)
values
(
i.  PER_CONSCHART_CODE,
i.  PER_YR,
i.  PER_PER,
i.  PER_START_DATE,
i.  PER_END_DATE,
i.  PER_ADJ_FLAG,
i.  PER_SEQ_NUM,
i.  PER_OPEN_PERIOD_FLAG--,
--i.  PER__IU__CREATE_DATE,
--i.  PER__IU__CREATE_USER,
--i.  PER__IU__UPDATE_DATE,
--i.  PER__IU__UPDATE_USER,
--i.  PER_OBJECT_ORASEQ
);
end loop;
--commit;
select count(1) into v_cnt_conv from period@conv;
select count(1) into v_cnt_prod from period@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for PERIOD table');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for PERIOD table');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.PERIOD@PROD where PER_CONSCHART_CODE NOT IN ('ZZCHART');
dbms_output.put_line ('Inserted '||v_cnt||' records into PERIOD table, check and commit');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.PERIOD');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 