

--create directory xtern_data_dir as '/home2/oracle/table_exports'
--grant read,write on directory xtern_data_dir to da;

declare 

v_sqlstmt varchar2 (10000);

begin

v_sqlstmt:= 'create table xtern_pycompaygrp
        ( PYG_COMP_CODE VARCHAR2(2 BYTE), 
	PYG_CODE VARCHAR2(4 BYTE), 
	PYG_DESCRIPTION VARCHAR2(30 BYTE), 
	PYG_SHORT_DESC VARCHAR2(16 BYTE), 
	PYG_BANK_CODE VARCHAR2(9 BYTE), 
	PYG_BRANCH_CODE VARCHAR2(5 BYTE), 
	PYG_BANK_ACC_NUMBER VARCHAR2(16 BYTE), 
	PYG_CR_ACC_CODE VARCHAR2(8 BYTE), 
	PYG_USER VARCHAR2(30 BYTE) , 
	PYG_LAST_UPD_DATE DATE, 
	PYG_DEPT_CODE VARCHAR2(6 BYTE), 
	PYG_SIGN_FILE1 VARCHAR2(250 BYTE), 
	PYG_SIGN_FILE2 VARCHAR2(250 BYTE), 
	PYG_COMPANY_LOGO_FILE VARCHAR2(250 BYTE), 
	PYG_PRINT_ADDRESS_FLAG VARCHAR2(1 BYTE), 
	PYG_SECURE_FLAG VARCHAR2(1 BYTE), 
	PYG_AMT_FOR_MANUAL_SIGN NUMBER(18,2), 
	PYG_AMT_FOR_TWO_SIGN NUMBER(18,2), 
	PYG_MESSAGE VARCHAR2(60 BYTE), 
	PYG__IU__CREATE_DATE DATE, 
	PYG__IU__CREATE_USER VARCHAR2(30 BYTE), 
	PYG__IU__UPDATE_DATE DATE, 
	PYG__IU__UPDATE_USER VARCHAR2(30 BYTE)
        )
        organization external
       ( default directory xtern_data_dir
         access parameters
        ( records delimited by newline
          SKIP 2         
          fields terminated by '',''
          OPTIONALLY ENCLOSED BY ''"''
          MISSING FIELD VALUES ARE NULL
        ) 
          location (''pycompaygrp.txt'')  
       )';

execute immediate v_sqlstmt;

Insert into da.pycompaygrp
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
from xtern_pycompaygrp

select count(1) into v_cnt 
from pycompaygrp
where pyg_comp_code not in ('ZZ');

if v_cnt = 0 
then raise errors_in_data;
else
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BABRANCH';
end if;

v_sqlstmt:= drop table xtern_babranch;
execute immediate v_sqlstmt;

commit;


end;
/

/*

alter table xtern_babranch_rpt
access parameters
         ( records delimited by newline
           SKIP 2         
           fields terminated by ','
           OPTIONALLY ENCLOSED BY '"'
           MISSING FIELD VALUES ARE NULL
         )


*/