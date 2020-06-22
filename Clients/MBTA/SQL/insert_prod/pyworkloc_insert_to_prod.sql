
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  WRL_CODE,
  WRL_NAME,
  WRL_SHORT_NAME,
  WRL_COUNTRY_CODE,
  WRL_STATE_CODE,
  WRL_COUNTY_CODE,
  WRL_CITY_CODE,
  WRL_START_ZIP_CODE,
  WRL_END_ZIP_CODE,
  WRL_VERTEX_GEOCODE,
  WRL_USER,
  WRL_LAST_UPD_DATE,
  WRL_ZIP_CODE--,
--  WRL__IU__CREATE_DATE,
--  WRL__IU__CREATE_USER,
--  WRL__IU__UPDATE_DATE,
--  WRL__IU__UPDATE_USER 
from DA.PYWORKLOC@CONV
where wrl_code not like 'I%' 
and wrl_code not like 'P%' 
and wrl_code not like 'O%' 
and wrl_code not like 'Z%'
) loop
INSERT INTO DA.PYWORKLOC@PROD
(  
  WRL_CODE,
  WRL_NAME,
  WRL_SHORT_NAME,
  WRL_COUNTRY_CODE,
  WRL_STATE_CODE,
  WRL_COUNTY_CODE,
  WRL_CITY_CODE,
  WRL_START_ZIP_CODE,
  WRL_END_ZIP_CODE,
  WRL_VERTEX_GEOCODE,
  WRL_USER,
  WRL_LAST_UPD_DATE,
  WRL_ZIP_CODE--,
--  WRL__IU__CREATE_DATE,
--  WRL__IU__CREATE_USER,
--  WRL__IU__UPDATE_DATE,
--  WRL__IU__UPDATE_USER 
)
values
(
i.  WRL_CODE,
i.    WRL_NAME,
i.    WRL_SHORT_NAME,
i.    WRL_COUNTRY_CODE,
i.    WRL_STATE_CODE,
i.    WRL_COUNTY_CODE,
i.    WRL_CITY_CODE,
i.    WRL_START_ZIP_CODE,
i.    WRL_END_ZIP_CODE,
i.    WRL_VERTEX_GEOCODE,
i.    WRL_USER,
i.    WRL_LAST_UPD_DATE,
i.    WRL_ZIP_CODE--,
--i.  --  WRL__IU__CREATE_DATE,
--i.  --  WRL__IU__CREATE_USER,
--i.  --  WRL__IU__UPDATE_DATE,
--i.  WRL__IU__UPDATE_USER

);
end loop;
--commit;
select count(1) into v_cnt_conv from PYWORKLOC@conv;
select count(1) into v_cnt_prod from PYWORKLOC@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for PYWORKLOC table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for PYWORKLOC table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.PYWORKLOC@PROD 
where wrl_code not like 'I%' 
and wrl_code not like 'P%' 
and wrl_code not like 'O%' 
and wrl_code not like 'Z%';
dbms_output.put_line ('Inserted '||v_cnt||' records into PYWORKLOC table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.PYWORKLOC@PROD.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 