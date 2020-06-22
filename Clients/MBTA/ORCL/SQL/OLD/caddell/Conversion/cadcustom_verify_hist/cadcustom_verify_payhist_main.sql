
set serveroutput on size 1000000 format word_wrapped;
set wrap ON;

PROMPT
PROMPT /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
PROMPT                        INSERT PROCESS FOR TABLES
PROMPT /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
PROMPT

Declare

v_sqlstmt   varchar2(10000);
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
            ||'PYCOMPAYGRP, PYTRADES, PYWCBCODE, PYWCBRATE, PYEMPLOYEE_TABLE, PYEMPSECGRPEMP, '
            ||'PYEMPSALSPL, PYCHKLOC, PYTAXEXM, BPVENDORS, CHEQUE, BPCUSTOMERS, JCMPHS, '
            ||'JCJOB_TABLE, JCJOBSECGRPJOB, JCJOBHPHS, JCJOBCAT, PYEMPPAYHIST, PMPROJECT_TABLE, '
            ||'SCMAST, SCSCHED, VOUCHER, VOUCHQ, VOUDIST, VOURLDEST, PYEMPTIMSHT, JCDETAIL.';

Delete from da1.errors;
commit;

------------------------------------------------------------------------------------------

        --//--//--//--//--//--//--//--//   

        v_tab_name :='PYEMPSECGRPUSER';
        begin
	for i in
	(


/*
         select esg_code, 'DA' secgrp_user
         FROM da.pyempsecgrpuser, 
              da.pyempsecgrp 
	 where esgu_user(+) = 'DA'
	 and  esg_code = esgu_group_code(+)
	 and esgu_group_code is null
*/
/*
select esg_code, secgrp_user
 FROM da.pyempsecgrpuser, 
      da.pyempsecgrp,
      (select 'DA' secgrp_user from dual
       UNION ALL
       select 'ATAYLOR' secgrp_user from dual
       UNION ALL
       select 'MSMITH' secgrp_user from dual       
      )
 where 1 = 1 
 --and esgu_user(+) = 'DA'
 and esg_code = esgu_group_code(+)
 and esgu_group_code is null
*/
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
        v_msg1 := '--PYEMPSECGRPUSER table is populated based on PYEMPSECGRP table.'||chr(10);
	end;
	v_tabs_rem := replace(v_tabs_rem,'PYEMPSECGRPUSER, ');

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
	v_msg1 := v_msg1||'--PYEMPLOYEE_TABLE table updated based on EMP_TERMINATION_DATE and '                            				||'EMP_RE_HIRE_DATE for salaried employees.'||chr(10);

------------------------------------------------------------------------------------------

/*       
        --//--// PY_SECURITY.SQL --//--//
        v_tab_name :='PYEMPSECGRPEMP';
        begin
	for i in
	(select
	  decode(emp_type, 'H','HOURLY','SALARY') v
	 , emp_no
	 from pyemployee_table
	 where emp_no not in
	 (select esge_emp_no from DA.PYEMPSECGRPEMP)
	) loop
	insert into DA.PYEMPSECGRPEMP
	(esge_group_code, esge_emp_no)
	values
	(i.v, i.emp_no)
	;
	end loop;
        v_msg1 := v_msg1||'--PYEMPSECGRPEMP table is populated based on PYEMPLOYEE_TABLE table.'||chr(10);
	commit;
	end;

v_tabs_rem := replace(v_tabs_rem,'PYEMPSECGRPEMP, ');
*/

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
	(select 'MASTER' v, job_code, job_comp_code
	from jcjob_table
	where 1=1
	--job_comp_code = '01'    -- Commented as Caddell is using more than one company as MASTER.
	and job_code not in
	(select jcgj_job_code from da.jcjobsecgrpjob)
	) loop
	insert into da.jcjobsecgrpjob
	(jcgj_group_code, jcgj_job_code, jsgj_comp_code)
	values
	(i.v, i.job_code, i.job_comp_code);
	end loop;
	v_msg1 := v_msg1||'--JCJOBSECGRPJOB table is populated based on JCJOB_TABLE.'||chr(10);
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

select count(1) into v_cnt from da.DC_PYEMPPAYHIST;
v_dc_tab_name := 'DC_PYEMPPAYHIST';
v_tab_name := 'PYEMPPAYHIST';

if v_cnt = 0
then
raise no_data_found;
else
da.dbk_dc.verify('PYEMPPAYHIST');
select count(1) into v_err_cnt from da.dc_error where upper(dcerr_table_name) = 'DC_PYEMPPAYHIST';

 if v_err_cnt = 0
  then
    
    select count(1) into v_cnt 
    from PYEMPPAYHIST;
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into PYEMPPAYHIST';
--    DBMS_OUTPUT.PUT_LINE('Insert into PYEMPPAYHIST Successful');
--    DBMS_OUTPUT.PUT_LINE(v_cnt_tab||' records inserted.');
  else
    raise errors_in_data;
 end if;

end if;
 			v_cnt_err := v_cnt_err+1;
			INSERT into da1.errors(ers_order, ers_table_name, ers_column_name) 
			values(v_cnt_err,v_tab_name,'COMPLETE');
v_tabs_rem := replace(v_tabs_rem,'PYEMPPAYHIST, ');

------------------------------------------------------------------------------------------
/*
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
	v_msg1 := v_msg1||'--SCMAST table updated based on PMPROJECT_TABLE.'||chr(10);

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

-- Procedure to populate SCDETAIL table.
DBP_DC_SCDETAIL();

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
*/
------------------------------------------------------------------------------------------

/*
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
*/

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
DBMS_OUTPUT.PUT_LINE('NOT processed tables: '||v_tabs_rem);
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
DBMS_OUTPUT.PUT_LINE('Insert process terminated in between, COMMIT done on all the inserted tables.');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE(v_msg1);
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('NOT processed tables: '||v_tabs_rem);
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
DBMS_OUTPUT.PUT_LINE('Insert process terminated in between, COMMIT done on all the inserted tables.');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE(v_msg1);
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE('NOT processed tables: '||v_tabs_rem);
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