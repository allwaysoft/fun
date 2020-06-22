

--create directory xtern_data_dir as '/home2/oracle/table_exports'
--grant read,write on directory xtern_data_dir to da;

begin

declare

v_sqlstmt   varchar2(10000);
v_tab_data varchar2(10000);

begin

v_sqlstmt:= 'create table xtern_babranch
        ( BRN_BANK_CODE VARCHAR2(9 BYTE), 
	BRN_BRANCH_CODE VARCHAR2(5 BYTE) , 
	BRN_BRANCH_NAME VARCHAR2(30 BYTE), 
	BRN_SHORT_NAME VARCHAR2(16 BYTE), 
	BRN_USER VARCHAR2(30 BYTE) , 
	BRN_LAST_UPD_DATE DATE , 
	BRN_SADDR_ORASEQ NUMBER, 
	BRN__IU__CREATE_DATE DATE , 
	BRN__IU__CREATE_USER VARCHAR2(30 BYTE), 
	BRN__IU__UPDATE_DATE DATE , 
	BRN__IU__UPDATE_USER VARCHAR2(30 BYTE)
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
          location (''babranch.txt'')  
       )';

execute immediate v_sqlstmt;
--commit;
/*
Insert into da.babranch
*/
/*
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
from xtern_babranch;
*/
/*
select count(1) into v_cnt 
from BABRANCH
where brn_bank_code not in ('BOA');

if v_cnt = 0 
then raise errors_in_data;
else
    v_cnt_tab := v_cnt_tab||', '||v_cnt||' into BABRANCH';
end if;

drop table xtern_babranch;

commit;
*/

end;

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
  BRN__IU__UPDATE_USER into v_tab_data 
from xtern_babranch
where rownum <2;

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