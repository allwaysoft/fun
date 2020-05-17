
set serveroutput on size 1000000 format word_wrapped;
set wrap ON;

PROMPT
PROMPT /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
PROMPT
PROMPT ***********************INSERT PROCESS FOR TABLES IN PROGRESS************************
PROMPT
PROMPT /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
PROMPT
PROMPT CHECK DA1.ERRORS TABLE FOR TABLE BY TABLE INSERT STATUS, WHILE PROCESS IN PROGRESS.


Declare

v_sqlstmt        varchar2(10000);
v_err_cnt        number; 
v_cnt            number;
v_cnt_err        number :=0;
v_cnt_tab        VARCHAR2(32767);
v_dc_tab_name    VARCHAR2(32767);
v_msg1           VARCHAR2(32767) := 'Records NOT inserted into JCJOBSECGRPJOB table based on JCJOB_TABLE'; 
v_tabs_rem       VARCHAR2(32767);
V_TAB_NAME       VARCHAR2(32767);
v_err_strng      VARCHAR2(32767);
errors_in_data   EXCEPTION;

begin

v_tabs_rem := 'PYEMPSECGRPUSER, BPARTNERS, BPADDRESSES, BABANK, BABRANCH, BABANKACCT, BPBANKS, '
            ||'PYCOMPAYGRP, PYTRADES, PYWCBCODE, PYWCBRATE, JCMPHS, JCMCAT, BPVENDORS, CHEQUE, BPCUSTOMERS, JCJOB_TABLE, '
            ||'JCJOBSECGRPJOB, JCJOBHPHS, JCJOBCAT, JCUTRAN, JBCONT, JBITEMNAMES, JBCONTDET, '
            ||'PYEMPLOYEE_TABLE, PYMultiGeoEmpListing, PYEMPSECGRPEMP, '
            ||'PYEMPSALSPL, PYCHKLOC, PYTAXEXM, PYJOBPAYRATE, PYJOBALLOC, PYEMPPAYHIST_COMMENTED, '
            ||'PMPROJECT_TABLE, SCMAST, SCSCHED, HREMRELATIVES, ' 
            ||'VOUCHER, VOUCHQ, PYEMPTIMSHT, VOUDIST, VOURLSDET, GLEDGER, JCDETAIL.';

--INVOICE, INVDIST, PAYMENT, INVPAY

Delete from da1.errors;
commit;

------------------------------------------------------------------------------------------

        --//--//--//--//--//--//--//--//   

        v_tab_name :='PYEMPSECGRPUSER';
        begin
	for i in

	(
--         select esg_code, 'DA' secgrp_user
  --       FROM da.pyempsecgrpuser, 
    --          da.pyempsecgrp 
	-- where esgu_user(+) = 'DA'
	-- and  esg_code = esgu_group_code(+)
	 --and esgu_group_code is null


--select esg_code, secgrp_user
 --FROM da.pyempsecgrpuser, 
   --   da.pyempsecgrp,
     -- (select 'DA' secgrp_user from dual
       --UNION ALL
       --select 'ATAYLOR' secgrp_user from dual
       --UNION ALL
       --select 'MSMITH' secgrp_user from dual       
     -- )
 --where 1 = 1 
 --    --and esgu_user(+) = 'DA'
 --and esg_code = esgu_group_code(+)
 --and esgu_group_code is null

       select esg_code, secgrp_user
         FROM (select '00_FIELD' esg_code from dual
       UNION ALL
       select '00_HOMEOFF' esg_code from dual),
      (select 'DA' secgrp_user from dual
       UNION ALL
       select 'ATAYLOR' secgrp_user from dual
       UNION ALL
       select 'MSMITH' secgrp_user from dual       
      )

       ) loop
	insert into DA.pyempsecgrpuser
        (esgu_group_code,esgu_user)
	values
	(i.esg_code, i.secgrp_user);
	end loop;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
	commit;
        v_msg1 := '--PYEMPSECGRPUSER table is populated based on PYEMPSECGRP table.'||CHR(13)||CHR(10);
	end;
	v_tabs_rem := replace(v_tabs_rem,'PYEMPSECGRPUSER, ');

------------------------------------------------------------------------------------------

------
        --//--//--//--//--//--//--//--//   

--        v_tab_name :='JCJOBSECGRPUSER';
--        begin
--	for i in
--	(
--select jsg_comp_code, jsg_code, secgrp_user
-- FROM (select jsg_comp_code, jsg_code 
--         from jcjobsecgrp 
--        where jsg_code = '00_MASTER'
--      ),
--      (select 'DA' secgrp_user from dual
--       UNION ALL
--       select 'ATAYLOR' secgrp_user from dual
--       UNION ALL
--       select 'MSMITH' secgrp_user from dual       
 --     )
--
--	) loop
--	insert into DA.JCJOBSECGRPUSER
  --      (jsgu_comp_code, jsgu_grop_code, jsgu_user)
--	values
--	(i.jsg_comp_code, i.jsg_code, i.secgrp_user);
--	end loop;
 --			v_cnt_err := v_cnt_err+1;
--			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
--			values(v_cnt_err,v_tab_name,'COMPLETE');
--	commit;
  --      v_msg1 := ' --JCJOBSECGRPUSER table is populated based on PYEMPSECGRP table.'||CHR(13)||CHR(10);
--	end;
--	v_tabs_rem := replace(v_tabs_rem,'JCJOBSECGRPUSER, ');
------

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_bpartners;
v_dc_tab_name := 'DC_BPARTNERS';
v_tab_name := 'BPARTNERS';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('BPARTNERS');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_BPARTNERS' ;

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from bpartners 
    where bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT');
    v_cnt_tab := v_cnt||' into BPARTNERS';
--    DBMS_OUTPUT.PUT_LINE('Insert into BPARTNERS Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab ||'records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'BPARTNERS, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_bpaddresses;
v_dc_tab_name := 'DC_BPADDRESSES';
v_tab_name :='BPADDRESSES';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('BPADDRESSES');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_BPADDRESSES'; 

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from bpaddresses;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BPADDRESSES';
--    DBMS_OUTPUT.PUT_LINE('Insert into BPADDRESSES Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'BPADDRESSES, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_BABANK;
v_dc_tab_name := 'DC_BABANK';
v_tab_name :='BABANK';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('BABANK');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_BABANK';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from BABANK
    where bnk_bank_code not in ('BOA');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BABANK';
--    DBMS_OUTPUT.PUT_LINE('Insert into BABANK Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'BABANK, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da1.babranch_export;
v_dc_tab_name := 'DA1.BABRANCH_EXPORT';

if v_cnt = 0
then
raise no_data_found;
else
Insert into da.babranch
select 
  BRN_BANK_CODE,
  BRN_BRANCH_CODE,
  BRN_BRANCH_NAME,
  BRN_SHORT_NAME,
  BRN_USER,
  BRN_LAST_UPD_DATE,
  BRN_SADDR_ORASEQ,
  BRN__IU__CREATE_DATE,
  BRN__IU__CREATE_USER,
  BRN__IU__UPDATE_DATE,
  BRN__IU__UPDATE_USER 
from da1.babranch_export;

select count(1) into v_cnt
from da.babranch
where brn_bank_code not in ('BOA');
v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BABRANCH';

end if;

v_tabs_rem := replace(v_tabs_rem,'BABRANCH, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_BABANKACCT;
v_dc_tab_name := 'DC_BABANKACCT';
v_tab_name :='BABANKACCT';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('BABANKACCT');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_BABANKACCT';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from BABANKACCT
    where bab_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BABANKACCT';
--    DBMS_OUTPUT.PUT_LINE('Insert into BABANKACCT Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'BABANKACCT, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_bpbanks;
v_dc_tab_name := 'DC_BPBANKS';
v_tab_name :='BPBANKS';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('BPBANKS');

select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_BPBANKS';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from BPBANKS;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BPBANKS';
--    DBMS_OUTPUT.PUT_LINE('Insert into BPBANKS Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'BPBANKS, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da1.pycompaygrp_export;
v_dc_tab_name := 'DA1.PYCOMPAYGRP_EXPORT';
if v_cnt = 0
then
raise no_data_found;
else
Insert into da.pycompaygrp
SELECT PYG_COMP_CODE,
  PYG_CODE,
  PYG_DESCRIPTION,
  PYG_SHORT_DESC,
  PYG_BANK_CODE,
  PYG_BRANCH_CODE,
  PYG_BANK_ACC_NUMBER,
  PYG_CR_ACC_CODE,
  PYG_USER,
  PYG_LAST_UPD_DATE,
  PYG_DEPT_CODE,
  PYG_SIGN_FILE1,
  PYG_SIGN_FILE2,
  PYG_COMPANY_LOGO_FILE,
  PYG_PRINT_ADDRESS_FLAG,
  PYG_SECURE_FLAG,
  PYG_AMT_FOR_MANUAL_SIGN,
  PYG_AMT_FOR_TWO_SIGN,
  PYG_MESSAGE,
  PYG__IU__CREATE_DATE,
  PYG__IU__CREATE_USER,
  PYG__IU__UPDATE_DATE,
  PYG__IU__UPDATE_USER 
FROM da1.pycompaygrp_export;
select count(1) into v_cnt
from da.pycompaygrp
where pyg_comp_code not in ('ZZ');
v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYCOMPAYGRP';
end if;

v_tabs_rem := replace(v_tabs_rem,'PYCOMPAYGRP, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PYTRADES;
v_dc_tab_name := 'DC_PYTRADES';
v_tab_name :='PYTRADES';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYTRADES');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYTRADES';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYTRADES
    where trd_code not in ('ZZ10','ZZ20','ZZ99','ZZ30');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYTRADES';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYTRADES Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYTRADES, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PYWCBCODE;
v_dc_tab_name := 'DC_PYWCBCODE';
v_tab_name :='PYWCBCODE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYWCBCODE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYWCBCODE';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYWCBCODE
    WHERE WCC_COMP_CODE not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYWCBCODE';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYWCBCODE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYWCBCODE, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PYWCBRATE;
v_dc_tab_name := 'DC_PYWCBRATE';
v_tab_name :='PYWCBRATE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYWCBRATE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYWCBRATE';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYWCBRATE
    where wcr_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYWCBRATE';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYWCBRATE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYWCBRATE, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.DC_PYCHKLOC;
v_dc_tab_name := 'PYCHKLOC';
v_tab_name := 'PYCHKLOC';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYCHKLOC');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYCHKLOC';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYCHKLOC;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYCHKLOC';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYCHKLOC Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYCHKLOC, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JCMPHS;
v_dc_tab_name := 'DC_JCMPHS';
v_tab_name := 'JCMPHS';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JCMPHS');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JCMPHS';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JCMPHS
    where phs_comp_code not in ('CMIC001','ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT','ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JCMPHS';
--    DBMS_OUTPUT.PUT_LINE('Insert into JCMPHS Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JCMPHS, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JCMCAT;
v_dc_tab_name := 'DC_JCMCAT';
v_tab_name := 'JCMCAT';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JCMCAT');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JCMCAT';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JCMCAT
    where phsc_comp_code not in  ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT','ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JCMCAT';
--    DBMS_OUTPUT.PUT_LINE('Insert into JCMCAT Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JCMCAT, ');

------------------------------------------------------------------------------------------
select count(1) into v_cnt from da.dc_BPVENDORS;
v_dc_tab_name := 'DC_BPVENDORS';
v_tab_name :='BPVENDORS';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('BPVENDORS');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_BPVENDORS';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from BPVENDORS
    where bpven_bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BPVENDORS';
--    DBMS_OUTPUT.PUT_LINE('Insert into BPVENDORS Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'BPVENDORS, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_CHEQUE;
v_dc_tab_name := 'DC_CHEQUE';
v_tab_name :='CHEQUE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('CHEQUE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_CHEQUE';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from CHEQUE;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into CHEQUE';
--    DBMS_OUTPUT.PUT_LINE('Insert into CHEQUE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'CHEQUE, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_BPCUSTOMERS;
v_dc_tab_name := 'DC_BPCUSTOMERS';
v_tab_name :='BPCUSTOMERS';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('BPCUSTOMERS');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_BPCUSTOMERS'; 

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from BPCUSTOMERS
    where bpcust_bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BPCUSTOMERS';
--    DBMS_OUTPUT.PUT_LINE('Insert into BPCUSTOMERS Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'BPCUSTOMERS, ');

------------------------------------------------------------------------------------------
select count(1) into v_cnt from da.dc_JCJOB_TABLE;
v_dc_tab_name := 'DC_JCJOB_TABLE';
v_tab_name := 'JCJOB_TABLE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JCJOB_TABLE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JCJOB_TABLE';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JCJOB_TABLE
    where job_comp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT','ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JCJOB_TABLE';
--    DBMS_OUTPUT.PUT_LINE('Insert into JCJOB_TABLE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JCJOB_TABLE, ');

------------------------------------------------------------------------------------------

        -- Below code is from job_security.sql file given by CMiC

	delete from jcjobsecgrpjob where jcgj_job_code not like 'ZZ%';
	
        v_tab_name := 'JCJOBSECGRPJOB';
	begin
	for i in
	(select '00_MASTER' v, job_code, job_comp_code
	from jcjob_table
	where 1=1
	--job_comp_code = '01'    -- Commented as Caddell is using more than one company.
	and job_code not in
	(select jcgj_job_code from da.jcjobsecgrpjob)
	) loop
	insert into da.jcjobsecgrpjob
	(jcgj_group_code, jcgj_job_code, jsgj_comp_code)
	values
	(i.v, i.job_code, i.job_comp_code);
	end loop;
	v_msg1 := v_msg1||' --JCJOBSECGRPJOB table is populated based on JCJOB_TABLE.'||CHR(13)||CHR(10);
	end;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JCJOBSECGRPJOB, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JCJOBHPHS;
v_dc_tab_name := 'DC_JCJOBHPHS';
v_tab_name := 'JCJOBHPHS';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JCJOBHPHS');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JCJOBHPHS';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JCJOBHPHS
    where jhp_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JCJOBHPHS';
--    DBMS_OUTPUT.PUT_LINE('Insert into JCJOBHPHS Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JCJOBHPHS, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JCJOBCAT;
v_dc_tab_name := 'DC_JCJOBCAT';
v_tab_name := 'JCJOBCAT';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JCJOBCAT');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JCJOBCAT';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JCJOBCAT
    where jcat_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JCJOBCAT';
--    DBMS_OUTPUT.PUT_LINE('Insert into JCJOBCAT Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JCJOBCAT, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JCUTRAN;
v_dc_tab_name := 'DC_JCUTRAN';
v_tab_name := 'JCUTRAN';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JCUTRAN');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JCUTRAN';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JCUTRAN;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JCUTRAN';
--    DBMS_OUTPUT.PUT_LINE('Insert into JCUTRAN Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JCUTRAN, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JBCONT;
v_dc_tab_name := 'DC_JBCONT';
v_tab_name := 'JBCONT';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JBCONT');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JBCONT';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JBCONT;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JBCONT';
--    DBMS_OUTPUT.PUT_LINE('Insert into JBCONT Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JBCONT, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JBITEMNAMES;
v_dc_tab_name := 'DC_JBITEMNAMES';
v_tab_name := 'JBITEMNAMES';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JBITEMNAMES');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JBITEMNAMES';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JBITEMNAMES;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JBITEMNAMES';
--    DBMS_OUTPUT.PUT_LINE('Insert into JBITEMNAMES Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JBITEMNAMES, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_JBCONTDET;
v_dc_tab_name := 'DC_JBCONTDET';
v_tab_name := 'JBCONTDET';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('JBCONTDET');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_JBCONTDET';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from JBCONTDET;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into JBCONTDET';
--    DBMS_OUTPUT.PUT_LINE('Insert into JBCONTDET Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'JBCONTDET, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PYEMPLOYEE_TABLE;
v_dc_tab_name := 'DC_PYEMPLOYEE_TABLE';
v_tab_name :='PYEMPLOYEE_TABLE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYEMPLOYEE_TABLE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYEMPLOYEE_TABLE';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYEMPLOYEE_TABLE
    where emp_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYEMPLOYEE_TABLE';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYEMPLOYEE_TABLE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYEMPLOYEE_TABLE, ');

------------------------------------------------------------------------------------------

        -- Update to SET the EMP_TERMINATION_DATE to NULL if it is less than EMP_RE_HIRE_DATE for         
        -- salaried employees. This is not a CMiC script.
        v_tab_name := 'UPDATE_PYEMPLOYEE_TABLE';
	update da.pyemployee_table
        set emp_termination_date = NULL
        where trunc(EMP_TERMINATION_DATE) < trunc(EMP_RE_HIRE_DATE)
        and emp_type = 'S';
	commit;
	v_msg1 := v_msg1||' --PYEMPLOYEE_TABLE table updated based on EMP_TERMINATION_DATE and '                            				||'EMP_RE_HIRE_DATE for salaried employees.'||CHR(13)||CHR(10);

------------------------------------------------------------------------------------------
        

--//--// Populate_pyemployee_geocodes.sql --//--//
v_tab_name :='PYMultiGeoEmpListing';

Declare
        TYPE ra_char_int_type  is table of varchar2(250) index by pls_integer;
        TYPE ra_char_char_type is table of varchar2(250) index by varchar2(2);
        ra_state  ra_char_int_type;
        ra_statec ra_char_char_type;
        -- replace non-character data
        t_string varchar2(9):='A #''-./,'||chr(38);
--
	c_empstate	Varchar2(10);
	c_empgeostate	pls_integer;
--

	      Cursor c_EmpAddress Is
	      Select  rowid empTable_Rowid
	  	     ,emp_zip_code
	    	     ,emp_state_code
	    	     ,emp_no
                      -- convert city to upper case and remove some non-alphanumeric characters
	    	     ,translate(upper(EMP_ADDRESS3),t_string,'A')
                      v_city
	    	     ,emp_county_code
   	       from da.pyemployee_table
	       Where emp_zip_code is not null
		 and emp_vertex_geocode = 'NA'
	         and emp_country_code   = 'US';
		--
		-- zip code only
	       cursor c_geocode_zip(p_empZip_code in Varchar2) is
	       select vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity
	             ,  lpad(to_char(vcity.locgeostate) , 2, '0')
	              ||lpad(to_char(vcity.locgeocounty), 3, '0')
	              ||lpad(to_char(vcity.locgeocity)  , 4, '0') vert_code
	         from da.vertex_loccity vcity
	         where rpad(p_empzip_code,6,' ') between loczipcodestart and loczipcodeend
                   -- if there is a state on employee, match the state code
                   and decode(c_empgeostate,null,-1,c_empgeostate) = decode(c_empgeostate,null,-1,vcity.locgeostate)
	        Group by vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity;
                --
	        ziprec			c_geocode_zip%RowType;
	        ziprec2			c_geocode_zip%RowType;
	        ziprec3			c_geocode_zip%RowType;
	        TotalZipRows		pls_integer;
                --
		-- zip code and city name
	       cursor c_geocode_zip_city(p_empZip_code in Varchar2, p_CityName in varchar2) is
	       select vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity
	             ,  lpad(to_char(vcity.locgeostate) , 2, '0')
	              ||lpad(to_char(vcity.locgeocounty), 3, '0')
	              ||lpad(to_char(vcity.locgeocity)  , 4, '0') vert_code
	         from da.vertex_loccity vcity
	         where rpad(p_empzip_code,6,' ') between loczipcodestart and loczipcodeend
                   and p_CityName in
                       ( translate(upper(vcity.LOCCOMPRESSEDCITY),t_string,'A')
                        ,translate(upper(vcity.LOCABBREVCITY    ),t_string,'A')
                        ,translate(upper(vcity.LOCNAMECITY      ),t_string,'A') 
                       )
                   -- if there is a state on employee, match the state code
                   and decode(c_empgeostate,null,-1,c_empgeostate) = decode(c_empgeostate,null,-1,vcity.locgeostate)
	        Group by vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity;
                --
		-- zip code and city name and county
	       cursor c_geocode_zip_city_county(p_empZip_code in Varchar2, p_CityName in varchar2, p_geostate in pls_integer, p_geocounty in pls_integer) is
	       select vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity
	             ,  lpad(to_char(vcity.locgeostate) , 2, '0')
	              ||lpad(to_char(vcity.locgeocounty), 3, '0')
	              ||lpad(to_char(vcity.locgeocity)  , 4, '0') vert_code
	         from da.vertex_loccity vcity
	         where rpad(p_empzip_code,6,' ') between loczipcodestart and loczipcodeend
                   and p_CityName in
                       ( translate(upper(vcity.LOCCOMPRESSEDCITY),t_string,'A')
                        ,translate(upper(vcity.LOCABBREVCITY    ),t_string,'A')
                        ,translate(upper(vcity.LOCNAMECITY      ),t_string,'A') 
                       )
		   and vcity.locgeostate = p_geostate
                   and vcity.locgeocounty= p_geocounty
                   -- if there is a state on employee, match the state code
                   and decode(c_empgeostate,null,-1,c_empgeostate) = decode(c_empgeostate,null,-1,vcity.locgeostate)
	        Group by vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity;
                --
		-- zip code and county (without city name)
	       cursor c_geocode_zip_county(p_empZip_code in Varchar2, p_geostate in number, p_geocounty in number) is
	       select vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity
	             ,  lpad(to_char(vcity.locgeostate) , 2, '0')
	              ||lpad(to_char(vcity.locgeocounty), 3, '0')
	              ||lpad(to_char(vcity.locgeocity)  , 4, '0') vert_code
	         from da.vertex_loccity vcity
	         where rpad(p_empzip_code,6,' ') between loczipcodestart and loczipcodeend
		   and vcity.locgeostate = p_geostate
                   and vcity.locgeocounty= p_geocounty
                   -- if there is a state on employee, match the state code
                   and decode(c_empgeostate,null,-1,c_empgeostate) = decode(c_empgeostate,null,-1,vcity.locgeostate)
	        Group by vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity;
                --
		-- county (without city name and without zip)
	       cursor c_geocode_county(p_geostate in number, p_geocounty in number) is
	       select vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity
	             ,  lpad(to_char(vcity.locgeostate) , 2, '0')
	              ||lpad(to_char(vcity.locgeocounty), 3, '0')
	              ||lpad(to_char(vcity.locgeocity)  , 4, '0') vert_code
	         from da.vertex_loccity vcity
	         where vcity.locgeostate = p_geostate
                   and vcity.locgeocounty= p_geocounty
                   -- if there is a state on employee, match the state code
                   and decode(c_empgeostate,null,-1,c_empgeostate) = decode(c_empgeostate,null,-1,vcity.locgeostate)
	        Group by vcity.locgeostate, vcity.locgeocounty, vcity.locgeocity;
               --
               --
	       cursor c_county(p_geostate in number, p_CountyName in varchar2, p_County_shortName in varchar2) is
	       select vcounty.locgeostate, vcounty.locgeocounty
	         from da.vertex_loccounty vcounty
	         where decode(c_empgeostate,null,-1,c_empgeostate) = decode(c_empgeostate,null,-1,vcounty.locgeostate)
                   and (
                       p_CountyName 
                       in
                       (translate(upper(LOCNAMECOUNTY)  ,t_string,'A')
                       ,translate(upper(LOCABBREVCOUNTY),t_string,'A')
                       )
                       or
                       p_County_shortName 
                       in
                       (translate(upper(LOCNAMECOUNTY)  ,t_string,'A')
                       ,translate(upper(LOCABBREVCOUNTY),t_string,'A')
                       )
                       )
	        Group by vcounty.locgeostate, vcounty.locgeocounty;
                countyrec               c_county%rowtype;
                countyrec2              c_county%rowtype;
		---	
	Cursor c_county_info(p_state in Varchar2, p_county in varchar2) Is
	Select  translate(upper(CNT_COUNTY_NAME),t_string,'A')
                CNT_COUNTY_NAME
               ,translate(upper(CNT_SHORT_NAME),t_string,'A')
                CNT_SHORT_NAME
          from da.pycounty
         where CNT_COUNTRY_CODE = 'US'
           and CNT_STATE_CODE   = p_state      
           and CNT_COUNTY_CODE  = p_county;
        c_countyrec     c_county_info%ROWTYPE;
        c_countyrec2    c_county_info%ROWTYPE;
Begin

 	Delete from da.PYMultiGeoEmpListing;
        commit;

-- state code
for i in (select locgeostate, locabbrevstate from da.vertex_locstate order by 1) loop
  ra_state (i.locgeostate)   :=i.locabbrevstate;
  ra_statec(i.locabbrevstate):=i.locgeostate; -- ggg locabbrevstate;
end loop;
-- main loop
For EmpRec in c_EmpAddress
Loop

   c_empstate   :=null;
   c_empgeostate:=null;
   ziprec       :=ziprec3;
   ziprec2      :=ziprec3;
   countyrec.locgeostate :=null;
   countyrec.locgeocounty:=null;

   if EmpRec.emp_state_code is null
      then dbms_output.put_line('Emp='||EmpRec.emp_no||' missing state code.');
           goto L_endloop;
      else if ra_statec.exists(EmpRec.emp_state_code)
              then c_empgeostate:=ra_statec(EmpRec.emp_state_code);
              else dbms_output.put_line('Emp='||EmpRec.emp_no||' Unknown state code:'||EmpRec.emp_state_code);
                   goto L_endloop;
           end if;
   end if;

   -- county information
   If  EmpRec.emp_state_code  is not null
   and EmpRec.emp_county_code is not null
   and c_empgeostate          is not null
   then
     Open  c_county_info(EmpRec.emp_state_code, EmpRec.emp_county_code);
     Fetch c_county_info into c_countyrec;
     if    c_county_info%found 
     then Fetch c_county_info into c_countyrec2;
          if c_county_info%found
             then dbms_output.put_line('Emp='||EmpRec.emp_no||' Same county code more than once in da.pycounty:'||EmpRec.emp_state_code||'-'||EmpRec.emp_county_code);
             else open  c_county (c_empgeostate, c_countyrec2.CNT_COUNTY_NAME, c_countyrec2.CNT_SHORT_NAME);
                  fetch c_county into countyrec;
                  if c_county%found
                     then fetch c_county into countyrec2;
                          if  c_county%found
                              then dbms_output.put_line('Emp='||EmpRec.emp_no||' County name found more than once in veretx_loccounty:'||to_char(c_empgeostate)||' '||c_countyrec2.CNT_COUNTY_NAME||' '||c_countyrec2.CNT_SHORT_NAME);
                                   countyrec.locgeostate :=null;
                                   countyrec.locgeocounty:=null;
                           end if;        
                     else dbms_output.put_line('Emp='||EmpRec.emp_no||' County name not found in veretx_loccounty:'||to_char(c_empgeostate)||' '||c_countyrec2.CNT_COUNTY_NAME||' '||c_countyrec2.CNT_SHORT_NAME);
                  end if;
                  close c_county;
          end if;
     else dbms_output.put_line('Emp='||EmpRec.emp_no||' County code not found in da.pycounty:'||EmpRec.emp_state_code||'-'||EmpRec.emp_county_code);
     end if;
     Close c_county_info;
   End if;

   -- find how many geocode-rows match the employee zip-code
   Open  c_geocode_zip(EmpRec.emp_zip_code);
   Fetch c_geocode_zip into ziprec;
   if c_geocode_zip%found
   then 
        Fetch c_geocode_zip into ziprec2;
        if   c_geocode_zip%found
        then -- more than one row matches the zip code
             TotalZipRows:=2;
        else -- only one row with the given zip code
             TotalZipRows:=1;
        end if;
   else -- no zip code match at all
        TotalZipRows:=0; 
   end if;
   close c_geocode_zip;

   -- more than one geocode-row matches the employee zip-code when matching by zip-code only
   -- try again by limiting the search to the employee-city within the employee zip-code
   if 2 = TotalZipRows then
     Open  c_geocode_zip_city(EmpRec.emp_zip_code, EmpRec.v_city);
     Fetch c_geocode_zip_city into ziprec;
     if c_geocode_zip_city%found
     then 
        Fetch c_geocode_zip_city into ziprec2;
        if c_geocode_zip_city%found
        then -- multiple rows with the given zip code
             TotalZipRows:=2;
        else -- only one row with the given zip code
             TotalZipRows:=1;
        end if;
     else -- no zip code match at all
          TotalZipRows:=0; 
     end if;
     close c_geocode_zip_city;
   end if;

   -- more than one geocode-row matches the employee zip-code when matching by both zip-code and city-name
   -- try again by limiting the search to the employee-county within the employee zip-code-city-name
   if 2 = TotalZipRows then
     Open  c_geocode_zip_city_county(EmpRec.emp_zip_code, EmpRec.v_city, countyrec.locgeostate, countyrec.locgeocounty);
     Fetch c_geocode_zip_city_county into ziprec;
     if c_geocode_zip_city_county%found
     then 
        Fetch c_geocode_zip_city_county into ziprec2;
        if c_geocode_zip_city_county%found
        then -- multiple rows with the given zip code
             TotalZipRows:=2;
        else -- only one row with the given zip code
             TotalZipRows:=1;
        end if;
     else -- no zip code match at all
          TotalZipRows:=0; 
     end if;
     close c_geocode_zip_city_county;
   end if;

   -- if there is no match at this point, then try employee-zipcode-county without city
   if 0 = TotalZipRows then
     Open  c_geocode_zip_county(EmpRec.emp_zip_code, countyrec.locgeostate, countyrec.locgeocounty);
     Fetch c_geocode_zip_county into ziprec;
     if c_geocode_zip_county%found
     then 
        Fetch c_geocode_zip_county into ziprec2;
        if c_geocode_zip_county%found
        then -- multiple rows with the given zip code
             TotalZipRows:=2;
        else -- only one row with the given zip code
             TotalZipRows:=1;
        end if;
     else -- no zip code match at all
          TotalZipRows:=0; 
     end if;
     close c_geocode_zip_county;
   end if;

   -- if there is no match at this point, then try employee-county without city and without zip code
   if 0 = TotalZipRows then
     Open  c_geocode_county(countyrec.locgeostate, countyrec.locgeocounty);
     Fetch c_geocode_county into ziprec;
     if c_geocode_county%found
     then 
        Fetch c_geocode_county into ziprec2;
        if c_geocode_county%found
        then -- multiple rows with the given zip code
             TotalZipRows:=2;
        else -- only one row with the given zip code
             TotalZipRows:=1;
        end if;
     else -- no zip code match at all
          TotalZipRows:=0; 
     end if;
     close c_geocode_county;
   end if;

   -- final test - if there is only one match, then update; otherwise (either more than one match or no match at all) then record as error
   -- in any case there is no real need to record the error, because the master table is not updated and the master table may be listed for rows that have no geocode
   if 1 = TotalZipRows then
         -- only one geocode-row matches the employee zip-code
         c_empstate:=ra_state(ziprec.locgeostate);

         If c_empstate=EmpRec.emp_state_code
            then 
               Begin       
                Update da.pyemployee_table
            	     set emp_vertex_geocode = ziprec.vert_code
         	        ,emp_state_code     = c_empstate
         	   where rowid = empRec.empTable_Rowid;
         
                 Update da.pyemphist
         	      set emh_vertex_geocode   = ziprec.vert_code
         	         ,emh_emp_state_code   = c_empstate
         	    where emh_emp_no = empRec.emp_no;      
         	 --Exception
         	   --When Others then dbms_output.put_line('Emp='||EmpRec.emp_no||' update error '||sqlerrm);
                 End;
            else dbms_output.put_line('Emp='||EmpRec.emp_no||' State code error.');
         End If;
   -- 
   else
   --
	Insert into da.PYMultiGeoEmpListing
	(geo_emp_no
	,geo_state_code
	,geo_profile_geocode
	)
	values
	(EmpRec.emp_no
	,Substr(c_empstate||'-'||EmpRec.emp_state_code,1,10)
	,Substr('ER:'||EmpRec.emp_zip_code,1,9)
	);
   end if;
   commit;
   << L_endloop >>
      null;
End loop;   
v_msg1 := v_msg1||' --PYMultiGeoEmpListing table is populated for inconsistent Employees.'||CHR(13)||CHR(10);
End;

v_tabs_rem := replace(v_tabs_rem,'PYMultiGeoEmpListing, ');


------------------------------------------------------------------------------------------

       
        --//--// PY_SECURITY.SQL --//--//
--        v_tab_name :='PYEMPSECGRPEMP';
--        begin
--	for i in
--	(select
--	  decode(emp_type, 'H','HOURLY','SALARY') v
--	 , emp_no
--	 from pyemployee_table
--	 where emp_no not in
--	 (select esge_emp_no from DA.PYEMPSECGRPEMP)
--	) loop
--	insert into DA.PYEMPSECGRPEMP
--	(esge_group_code, esge_emp_no)
--	values
--	(i.v, i.emp_no)
--	;
--	end loop;
--        v_msg1 := v_msg1||' --PYEMPSECGRPEMP table is populated based on PYEMPLOYEE_TABLE table.'||CHR(13)||CHR(10);
--	commit;
--	end;

--v_tabs_rem := replace(v_tabs_rem,'PYEMPSECGRPEMP, ');


------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PYEMPSECGRPEMP;
v_dc_tab_name := 'DC_PYEMPSECGRPEMP';
v_tab_name :='PYEMPSECGRPEMP';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYEMPSECGRPEMP');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYEMPSECGRPEMP';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYEMPSECGRPEMP
    where esge_group_code not like 'ZZ%';
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYEMPSECGRPEMP';

  else
   raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYEMPSECGRPEMP, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PYEMPSALSPL;
v_dc_tab_name := 'DC_PYEMPSALSPL';
v_tab_name :='PYEMPSALSPL';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYEMPSALSPL');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYEMPSALSPL';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYEMPSALSPL
    where ess_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYEMPSALSPL';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYEMPSALSPL Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYEMPSALSPL, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.DC_PYTAXEXM;
v_dc_tab_name := 'DC_PYTAXEXM';
v_tab_name := 'PYTAXEXM';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYTAXEXM');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYTAXEXM';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYTAXEXM;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYTAXEXM';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYTAXEXM Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYTAXEXM, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.DC_PYJOBPAYRATE;
v_dc_tab_name := 'DC_PYJOBPAYRATE';
v_tab_name := 'PYJOBPAYRATE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYJOBPAYRATE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYJOBPAYRATE';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYJOBPAYRATE;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYJOBPAYRATE';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYJOBPAYRATE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYJOBPAYRATE, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PYJOBALLOC;
v_dc_tab_name := 'DC_PYJOBALLOC';
v_tab_name := 'PYJOBALLOC';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYJOBALLOC');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYJOBALLOC';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYJOBALLOC
    where pyja_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYJOBALLOC';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYJOBALLOC Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYJOBALLOC, ');

------------------------------------------------------------------------------------------

-----  
--DO NOT RUN THIS, it slows down the delete process
--select count(1) into v_cnt from da.DC_PYEMPPAYHIST;
--v_dc_tab_name := 'DC_PYEMPPAYHIST';
--v_tab_name := 'PYEMPPAYHIST';

--if v_cnt = 0
--then
--raise no_data_found;
--else
--da.dbk_dc.verify('PYEMPPAYHIST');
--select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYEMPPAYHIST';

-- if v_err_cnt = 0
--  then
    
--    select count(1) into v_cnt 
--    from PYEMPPAYHIST;
--    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYEMPPAYHIST';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYEMPPAYHIST Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
--  else
--    raise errors_in_data;
-- end if;

--end if;
-- 			v_cnt_err := v_cnt_err+1;
--			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
--			values(v_cnt_err,v_tab_name,'COMPLETE');
--v_tabs_rem := replace(v_tabs_rem,'PYEMPPAYHIST, ');
-----

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.DC_PMPROJECT_TABLE;
v_dc_tab_name := 'DC_PMPROJECT_TABLE';
v_tab_name := 'PMPROJECT_TABLE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PMPROJECT_TABLE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PMPROJECT_TABLE'; 

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PMPROJECT_TABLE
    where pmp_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PMPROJECT_TABLE';
--    DBMS_OUTPUT.PUT_LINE('Insert into PMPROJECT_TABLE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PMPROJECT_TABLE, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.DC_SCMAST;
v_dc_tab_name := 'DC_SCMAST';
v_tab_name := 'SCMAST';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('SCMAST');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_SCMAST';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from SCMAST
    where scmst_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into SCMAST';
--    DBMS_OUTPUT.PUT_LINE('Insert into SCMAST Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'SCMAST, ');

------------------------------------------------------------------------------------------	        

        -- dcscproj.sql given by CMiC
        v_tab_name := 'UPDATE_SCMAST';
	update da.scmast 
        set scmst_proj_oraseq = 
       (select pmp_proj_oraseq from da.pmproject_table
        where pmp_comp_code = scmst_comp_code 
        and pmp_job_code = scmst_job_code and rownum < 2)
 	where scmst_proj_oraseq is null
   	and (scmst_comp_code, scmst_job_code) in 
       (select pmp_comp_code, pmp_job_code 
         from da.pmproject_table);
	commit;
	v_msg1 := v_msg1||' --SCMAST table updated based on PMPROJECT_TABLE.'||CHR(13)||CHR(10);

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.DC_SCSCHED;
v_dc_tab_name := 'DC_SCSCHED';
v_tab_name := 'SCSCHED';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('SCSCHED');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_SCSCHED';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from SCSCHED
    where scsch_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into SCSCHED';
--    DBMS_OUTPUT.PUT_LINE('Insert into SCSCHED Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'SCSCHED, ');

------------------------------------------------------------------------------------------
/*
select count(1) into v_cnt from da.dc_INVOICE;
v_dc_tab_name := 'DC_INVOICE';
v_tab_name :='INVOICE';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('INVOICE');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_INVOICE';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from INVOICE;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into INVOICE';
--    DBMS_OUTPUT.PUT_LINE('Insert into INVOICE Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'INVOICE, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_INVDIST;
v_dc_tab_name := 'DC_INVDIST';
v_tab_name :='INVDIST';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('INVDIST');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_INVDIST';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from INVDIST;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into INVDIST';
--    DBMS_OUTPUT.PUT_LINE('Insert into INVDIST Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'INVDIST, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_PAYMENT;
v_dc_tab_name := 'DC_PAYMENT';
v_tab_name :='PAYMENT';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PAYMENT');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PAYMENT';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PAYMENT;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PAYMENT';
--    DBMS_OUTPUT.PUT_LINE('Insert into PAYMENT Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PAYMENT, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_INVPAY;
v_dc_tab_name := 'DC_INVPAY';
v_tab_name :='INVPAY';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('INVPAY');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_INVPAY';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from INVPAY;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into INVPAY';
--    DBMS_OUTPUT.PUT_LINE('Insert into INVPAY Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'INVPAY, ');

*/

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_HREMRELATIVES;
v_dc_tab_name := 'DC_HREMRELATIVES';
v_tab_name :='HREMRELATIVES';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('HREMRELATIVES');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_HREMRELATIVES';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from HREMRELATIVES;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into HREMRELATIVES';
--    DBMS_OUTPUT.PUT_LINE('Insert into HREMRELATIVES Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'HREMRELATIVES, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_VOUCHER;
v_dc_tab_name := 'DC_VOUCHER';
v_tab_name :='VOUCHER';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('VOUCHER');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_VOUCHER';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from VOUCHER;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into VOUCHER';
--    DBMS_OUTPUT.PUT_LINE('Insert into VOUCHER Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'VOUCHER, ');

------------------------------------------------------------------------------------------

-- Procedure to populate SCDETAIL table.
DBP_DC_SCDETAIL();

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_VOUCHQ;
v_dc_tab_name := 'DC_VOUCHQ';
v_tab_name :='VOUCHQ';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('VOUCHQ');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_VOUCHQ';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from VOUCHQ;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into VOUCHQ';
--    DBMS_OUTPUT.PUT_LINE('Insert into VOUCHQ Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'VOUCHQ, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.DC_PYEMPTIMSHT;
v_dc_tab_name := 'DC_PYEMPTIMSHT';
v_tab_name := 'PYEMPTIMSHT';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYEMPTIMSHT');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYEMPTIMSHT';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYEMPTIMSHT
    where tsh_comp_code not in ('ZZ');
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYEMPTIMSHT';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYEMPTIMSHT Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYEMPTIMSHT, ');

------------------------------------------------------------------------------------------

select count(1) into v_cnt from da.dc_VOUDIST;
v_dc_tab_name := 'DC_VOUDIST';
v_tab_name :='VOUDIST';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('VOUDIST');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_VOUDIST';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from VOUDIST;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into VOUDIST';
--    DBMS_OUTPUT.PUT_LINE('Insert into VOUDIST Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'VOUDIST, ');

------------------------------------------------------------------------------------------

COMMIT;

dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Insert on all tables SUCCESSFUL, COMMIT done on all tables.');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Processed tables: '||nvl(v_cnt_tab,'NO table'));
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE(v_msg1);
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Procedure DBP_DC_SCDETAIL executed successfully to populate SCDETAIL table.');
dbms_output.put_line(chr(9));
        v_cnt_err := v_cnt_err+1;
	INSERT into da1.errors(ers_order, ers_description) 
	values(v_cnt_err,'---SUCCESSFUL---No Errors while running the script CADCUSTOM_VERIFY_MAIN.SQL');
	DBMS_OUTPUT.PUT_LINE('Tables left for manual processing: '||v_tabs_rem);
        v_cnt_err := v_cnt_err+1;
	INSERT into da1.errors(ers_order, ers_description) 
	values(v_cnt_err,'Tables left for manual processing: '||v_tabs_rem);
	DBMS_OUTPUT.PUT_LINE('Look in table DA1.ERRORS for more comments, if necessary.');
	commit;


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

exception 

when no_data_found
then 
commit;
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Processed tables: '||nvl(v_cnt_tab,'NO table'));
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Insert process terminated in between, COMMIT done on all the inserted tables.');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE(v_msg1);
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('NOT PROCESSED TABLES: '||v_tabs_rem);
dbms_output.put_line(chr(9));
        v_cnt_err := v_cnt_err+1;
	INSERT into da1.errors(ers_order, ers_description) 
	values(v_cnt_err,'No records in table: '||v_dc_tab_name);
	commit;
DBMS_OUTPUT.PUT_LINE('Errors are also inserted into table: DA1.ERRORS');
dbms_output.put_line(chr(9));
RAISE_APPLICATION_ERROR(-20100, 'No records in table: '||v_dc_tab_name);


when errors_in_data
then
commit;
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Processed tables: '||nvl(v_cnt_tab,'NO table'));
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE(v_msg1);
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Insert process terminated in between, COMMIT done on all the inserted tables.');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('NOT PROCESSED TABLES: '||v_tabs_rem);
dbms_output.put_line(chr(9));
        v_cnt_err := v_cnt_err+1;
	INSERT into da1.errors(ers_order, ers_description) 
	values(v_cnt_err,'There are errors in da.dc_error table for table: '||v_dc_tab_name);
	commit;
DBMS_OUTPUT.PUT_LINE('Errors are also inserted into table: DA1.ERRORS');
dbms_output.put_line(chr(9));
RAISE_APPLICATION_ERROR(-20101, 'There are errors in da.dc_error table for table: '||v_dc_tab_name);


when others
then 
commit;
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Processed tables: '||nvl(v_cnt_tab,'NO table'));
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE(v_msg1);
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Insert process terminated in between, COMMIT done on all the inserted tables.');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('NOT PROCESSED TABLES: '||v_tabs_rem);
dbms_output.put_line(chr(9));
        v_cnt_err := v_cnt_err+1;
	v_err_strng:=SQLERRM;
	INSERT into da1.errors(ers_order, ers_description) 
	values(v_cnt_err,'Error while verifying table: '||v_tab_name||'.');
        v_cnt_err := v_cnt_err+1;
	INSERT into da1.errors(ers_order, ers_description) 
	values(v_cnt_err,'Error: '||v_err_strng||'.');
	commit;
DBMS_OUTPUT.PUT_LINE('Errors are also inserted into table: DA1.ERRORS');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('Error while verifying table: '||v_tab_name||'. ');
RAISE_APPLICATION_ERROR(-20102,SQLERRM);

end;
/
