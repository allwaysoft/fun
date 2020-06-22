
set serveroutput on size unlimited;

PROMPT
PROMPT /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
PROMPT                        DELETE SCRIPT FOR TABLES
PROMPT /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
PROMPT


declare

v_sqlstmt      VARCHAR2(32767);
v_tab_name     VARCHAR2(32767);
v_cnt          NUMBER;
v_cnt_err        number :=0;

begin

Delete from da1.errors;
commit;

v_tab_name :=upper('CHEQUE');
delete 
from CHEQUE;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('VOUDIST');
delete 
from VOUDIST;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('VOUCBCH');
delete 
from VOUBCH;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('VOUCHER');
delete 
from VOUCHER;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('voubch');
delete from voubch;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('jcdetail');
delete 
from jcdetail 
where jcdt_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper(' PYTAXEXM');
delete from PYTAXEXM;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('PYEMPTIMSHT');
delete from PYEMPTIMSHT 
where tsh_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('scmast UPDATE');
update da.scmast
set scmst_post_date = null;
commit;
DBMS_OUTPUT.PUT_LINE ('COMMIT after SCMAST UPDATE successful.');



v_tab_name :=upper('scsched');
delete from da.scsched
 where exists (select 'x'
          from da.scmast
         where scsch_comp_code = scmst_comp_code
           and scsch_ven_code = scmst_ven_code
           and scsch_cont_code = scmst_cont_code
           and scsch_job_code = scmst_job_code
              )
       and scsch_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');



v_tab_name :=upper('scdetail');
delete from da.scdetail
 where exists (select 'x'
          from da.scmast
         where scdet_comp_code = scmst_comp_code
           and scdet_ven_code = scmst_ven_code
           and scdet_cont_code = scmst_cont_code
           and scdet_job_code = scmst_job_code
              )
           and scdet_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');



v_tab_name :=upper('scmast');
delete
from da.scmast
where SCMST_COMP_CODE not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('bpvendors');
delete from bpvendors where bpven_bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('PYEMPHIST');
delete from pyemphist where emh_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('pyemppayrate');
delete from pyemppayrate
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('PYEMPSALSPL');
delete from PYEMPSALSPL where ess_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

--v_tab_name :=upper('PYEMPSECGRP');
--delete from DA.PYEMPSECGRP
--where esg_code not in('SALARY','HOURLY');
--commit;
--DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('PYEMPSECGRPEMP');
delete from DA.PYEMPSECGRPEMP
where esge_group_code not like 'ZZ%';
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('PYempded');
delete from PYempded 
where emd_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');    

v_tab_name :=upper('pyemployee_table');
delete from pyemployee_table where emp_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('pychkloc');
delete from pychkloc
where ckloc_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('pywcbrate');
delete from pywcbrate where wcr_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('pywcbcode');
delete from pywcbcode WHERE WCC_COMP_CODE not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('pytrades');
delete from pytrades where trd_code not in ('ZZ10','ZZ20','ZZ99','ZZ30');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


--*******PYCOMPAYGRP_EXPORT@PROD*******

select count(1) into v_cnt 
FROM DA.PYCOMPAYGRP@CONV 
where pyg_comp_code not in ('ZZ');

if v_cnt>0
then
Delete from DA1.PYCOMPAYGRP_EXPORT@prod;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on DA1.PYCOMPAYGRP_EXPORT@PROD successful.');
INSERT into DA1.PYCOMPAYGRP_EXPORT@prod  
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
FROM DA.PYCOMPAYGRP@CONV 
where pyg_comp_code not in ('ZZ');
DBMS_OUTPUT.PUT_LINE ('Export of DA.PYCOMPAYGRP@CONV to DA1.PYCOMPAYGRP_EXPORT@PROD table successful.');
else
DBMS_OUTPUT.PUT_LINE ('NO records in DA.PYCOMPAYGRP@CONV, DA1.PYCOMPAYGRP_EXPORT@PROD is not changed');
end if;


--*******PYCOMPAYGRP_EXPORT@CONV******

select count(1) into v_cnt 
FROM DA.PYCOMPAYGRP@CONV 
where pyg_comp_code not in ('ZZ');

if v_cnt>0
then

v_sqlstmt := 'drop table da1.pycompaygrp_export';
EXECUTE IMMEDIATE v_sqlstmt;

v_sqlstmt := 'Create table DA1.PYCOMPAYGRP_EXPORT AS 
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
FROM DA.PYCOMPAYGRP@CONV
where pyg_comp_code not in (''ZZ'')';
EXECUTE IMMEDIATE v_sqlstmt;
DBMS_OUTPUT.PUT_LINE ('Export of DA.PYCOMPAYGRP@CONV to DA1.PYCOMPAYGRP_EXPORT@CONV table successful.');

v_tab_name :=upper('PYCOMPAYGRP');
delete from PYCOMPAYGRP where pyg_comp_code not in ('ZZ');-- export delete and import back
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on PYCOMPAYGRP successful.');

else
DBMS_OUTPUT.PUT_LINE ('NO records in DA.PYCOMPAYGRP@CONV, DA1.PYCOMPAYGRP_EXPORT@CONV is not changed');
end if;




--*******BABRANCH_EXPORT@PROD*******

select count(1) into v_cnt  
FROM da.babranch@conv
where brn_bank_code not in ('BOA');

if v_cnt>0
then

Delete from DA1.BABRANCH_EXPORT@PROD;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on DA1.BABRANCH_EXPORT@PROD successful.');
INSERT into DA1.BABRANCH_EXPORT@PROD  
SELECT   
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
FROM da.babranch@conv
where brn_bank_code not in ('BOA');
DBMS_OUTPUT.PUT_LINE ('Export of DA.BABRANCH@CONV to DA1.BABRANCH_EXPORT@PROD table successful.');
else
DBMS_OUTPUT.PUT_LINE ('NO records in DA.BABRANCH@CONV, DA1.BABRANCH_EXPORT@PROD is not changed');
end if;



--*******BABRANCH_EXPORT@CONV*******

select count(1) into v_cnt 
FROM da.babranch@conv
where brn_bank_code not in ('BOA');

if v_cnt>0
then

v_sqlstmt := 'drop table DA1.BABRANCH_EXPORT';
EXECUTE IMMEDIATE v_sqlstmt;

v_sqlstmt := 'Create table DA1.BABRANCH_EXPORT AS 
SELECT   BRN_BANK_CODE,
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
FROM da.babranch@conv
where brn_bank_code not in (''BOA'')';
EXECUTE IMMEDIATE v_sqlstmt;
DBMS_OUTPUT.PUT_LINE ('Export of DA.BABRANCH@CONV to DA1.BABRANCH_EXPORT@CONV table successful.');

v_tab_name :=upper('BABRANCH');
delete from babranch  where brn_bank_code not in ('BOA');-- export delete and import back
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on BABRANCH successful.');

else
DBMS_OUTPUT.PUT_LINE ('NO records in DA.BABRANCH@CONV, DA1.BABRANCH_EXPORT@CONV is not changed');
end if;


v_tab_name :=upper('BABANK');
delete from babank where bnk_bank_code not in ('BOA');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('BABANKACCT');
delete from babankacct where bab_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('bpbanks');
delete from bpbanks;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('bpaddresses');
delete from bpaddresses;
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('jcbatch_table');
delete from jcbatch_table where jcbch_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('jcjobcat');
delete from jcjobcat where jcat_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('jcjobhphs');
delete from jcjobhphs where jhp_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('jcmphs');
delete from jcmphs where phs_comp_code not in ('CMIC001','ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT','ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('pmprojpartner');
delete from pmprojpartner where pmpp_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('PMPROJECT_TABLE') ;
delete from PMPROJECT_TABLE where pmp_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('JCSUBCONTR');
delete from JCSUBConTR where jcsbc_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');

v_tab_name :=upper('jcset');
update jcset 
set jcset_job_code = null 
where jcset_comp_code not in ('ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('JCJOB_TABLE');
delete from jcjob_table where job_comp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT','ZZ');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('bpcustomers');
delete from bpcustomers where bpcust_bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');


v_tab_name :=upper('bpartners');
delete from bpartners where bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT');
commit;
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT on '||v_tab_name|| ' successful.');
dbms_output.put_line(chr(9));
DBMS_OUTPUT.PUT_LINE ('DELETE, COMMIT ON ALL TABLES SUCCESSFUL.');

commit;

EXCEPTIon
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE('Error while deleting table: '||v_tab_name||'. ');
RAISE_APPLICATIon_ERROR(-20102, SQLERRM);
end;
/
