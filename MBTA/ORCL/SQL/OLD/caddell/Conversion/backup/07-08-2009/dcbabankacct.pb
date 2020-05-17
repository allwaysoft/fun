--Mon Jul  6 11:15:45 2009
PROMPT =======================================
PROMPT   Create DBK_DC_BABANKACCT package body
PROMPT =======================================

CREATE OR REPLACE PACKAGE BODY DA.DBK_DC_BABANKACCT AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.dbk_dc.display_status('DC_BABANKACCT',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS
--BANKAC_BACURR_FK

cursor cBANKAC_BACURR_FK is
  select dc_rownum,
	 BAB_CURR_CODE
	from DA.DC_BABANKACCT  T1
	where not exists
           (select '1'
              from DA.BACURRENCY T2
                where nvl(T1.BAB_CURR_CODE,T2.BACURR_CODE) = T2.BACURR_CODE );
--BANKAC_BAACCTP_FK

cursor cBANKAC_BAACCTP_FK is
  select dc_rownum,
	 BAB_ACC_TYPE
	from DA.DC_BABANKACCT  T1
	where not exists
           (select '1'
              from DA.BAACCTYPE T2
                where nvl(T1.BAB_ACC_TYPE,T2.BAACTP_CODE) = T2.BAACTP_CODE );

BEGIN
null;
--BANKAC_BACURR_FK
 for row_dc in cBANKAC_BACURR_FK
 loop
  if ( row_dc.BAB_CURR_CODE is not null  ) then
	 da.dbk_dc.error('DC_BABANKACCT',
                                 row_dc.dc_rownum,
                                 'BANKAC_BACURR_FK',
                                 'BACURRENCY',
                'Record with '|| ' BACURR_CODE '||row_dc.BAB_CURR_CODE||
		' does not exist in DA.BACURRENCY table.');
 end if;
end loop;
--BANKAC_BAACCTP_FK
 for row_dc in cBANKAC_BAACCTP_FK
 loop
  if ( row_dc.BAB_ACC_TYPE is not null  ) then
	 da.dbk_dc.error('DC_BABANKACCT',
                                 row_dc.dc_rownum,
                                 'BANKAC_BAACCTP_FK',
                                 'BAACCTYPE',
                'Record with '|| ' BAACTP_CODE '||row_dc.BAB_ACC_TYPE||
		' does not exist in DA.BAACCTYPE table.');
 end if;
end loop;

END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--SYS_C0060878 - "BAB_CURR_CODE" IS NOT NULL
 cursor cur_SYS_C0060878 is
        select dc_rownum
          from DA.DC_BABANKACCT
            where not "BAB_CURR_CODE" IS NOT NULL ;

--SYS_C0060873 - "BAB_COMP_CODE" IS NOT NULL
 cursor cur_SYS_C0060873 is
        select dc_rownum
          from DA.DC_BABANKACCT
            where not "BAB_COMP_CODE" IS NOT NULL ;

--SYS_C0060874 - "BAB_DEPT_CODE" IS NOT NULL
 cursor cur_SYS_C0060874 is
        select dc_rownum
          from DA.DC_BABANKACCT
            where not "BAB_DEPT_CODE" IS NOT NULL ;

--SYS_C0060875 - "BAB_ACC_CODE" IS NOT NULL
 cursor cur_SYS_C0060875 is
        select dc_rownum
          from DA.DC_BABANKACCT
            where not "BAB_ACC_CODE" IS NOT NULL ;

--SYS_C0060876 - "BAB_BANK_CODE" IS NOT NULL
 cursor cur_SYS_C0060876 is
        select dc_rownum
          from DA.DC_BABANKACCT
            where not "BAB_BANK_CODE" IS NOT NULL ;

--SYS_C0060877 - "BAB_ACC_NUMBER" IS NOT NULL
 cursor cur_SYS_C0060877 is
        select dc_rownum
          from DA.DC_BABANKACCT
            where not "BAB_ACC_NUMBER" IS NOT NULL ;

BEGIN
null;

 for row_dc in cur_SYS_C0060878
 loop
    da.dbk_dc.error('DC_BABANKACCT',
                    row_dc.dc_rownum,
                    'SYS_C0060878',
                    'SYS_C0060878',
                    'Condition "BAB_CURR_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0060873
 loop
    da.dbk_dc.error('DC_BABANKACCT',
                    row_dc.dc_rownum,
                    'SYS_C0060873',
                    'SYS_C0060873',
                    'Condition "BAB_COMP_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0060874
 loop
    da.dbk_dc.error('DC_BABANKACCT',
                    row_dc.dc_rownum,
                    'SYS_C0060874',
                    'SYS_C0060874',
                    'Condition "BAB_DEPT_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0060875
 loop
    da.dbk_dc.error('DC_BABANKACCT',
                    row_dc.dc_rownum,
                    'SYS_C0060875',
                    'SYS_C0060875',
                    'Condition "BAB_ACC_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0060876
 loop
    da.dbk_dc.error('DC_BABANKACCT',
                    row_dc.dc_rownum,
                    'SYS_C0060876',
                    'SYS_C0060876',
                    'Condition "BAB_BANK_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0060877
 loop
    da.dbk_dc.error('DC_BABANKACCT',
                    row_dc.dc_rownum,
                    'SYS_C0060877',
                    'SYS_C0060877',
                    'Condition "BAB_ACC_NUMBER" IS NOT NULL failed.');
 end loop;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.BABANKACCT table
--======================================================================
PROCEDURE IDX_CHECK AS

--BABANKACCT_UK2
cursor cur_BABANKACCT_UK2 is
  select dc_rownum,
	 BAB_BANK_CODE,
	 BAB_ACC_PREFIX,
	 BAB_ACC_NUMBER,
	 BAB_COMP_CODE
    from DA.DC_BABANKACCT S1
      where exists (select '1'
                      from DA.BABANKACCT S2
                        where S1.BAB_BANK_CODE = S2.BAB_BANK_CODE
			  and S1.BAB_ACC_PREFIX = S2.BAB_ACC_PREFIX
			  and S1.BAB_ACC_NUMBER = S2.BAB_ACC_NUMBER
			  and S1.BAB_COMP_CODE = S2.BAB_COMP_CODE );
--BABANKACCT_UK3
cursor cur_BABANKACCT_UK3 is
  select dc_rownum,
	 BAB_BRANCH_CODE,
	 BAB_BANK_CODE,
	 BAB_ACC_NUMBER,
	 BAB_COMP_CODE
    from DA.DC_BABANKACCT S1
      where exists (select '1'
                      from DA.BABANKACCT S2
                        where S1.BAB_BRANCH_CODE = S2.BAB_BRANCH_CODE
			  and S1.BAB_BANK_CODE = S2.BAB_BANK_CODE
			  and S1.BAB_ACC_NUMBER = S2.BAB_ACC_NUMBER
			  and S1.BAB_COMP_CODE = S2.BAB_COMP_CODE );
--BANKAC_PK
cursor cur_BANKAC_PK is
  select dc_rownum,
	 BAB_COMP_CODE,
	 BAB_DEPT_CODE,
	 BAB_ACC_CODE
    from DA.DC_BABANKACCT S1
      where exists (select '1'
                      from DA.BABANKACCT S2
                        where S1.BAB_COMP_CODE = S2.BAB_COMP_CODE
			  and S1.BAB_DEPT_CODE = S2.BAB_DEPT_CODE
			  and S1.BAB_ACC_CODE = S2.BAB_ACC_CODE );
BEGIN
 null; 

--BABANKACCT_UK2
 for row_dc in cur_BABANKACCT_UK2
 loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,
                'BABANKACCT_UK2',
                'BABANKACCT_UK2',
                'Record with '||'BAB_BANK_CODE '||row_dc.BAB_BANK_CODE ||
		', '||'BAB_ACC_PREFIX '||row_dc.BAB_ACC_PREFIX ||
		', '||'BAB_ACC_NUMBER '||row_dc.BAB_ACC_NUMBER ||
		', '||'BAB_COMP_CODE '||row_dc.BAB_COMP_CODE ||
		' already exists in DA.BABANKACCT table.');

 end loop;

--BABANKACCT_UK3
 for row_dc in cur_BABANKACCT_UK3
 loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,
                'BABANKACCT_UK3',
                'BABANKACCT_UK3',
                'Record with '||'BAB_BRANCH_CODE '||row_dc.BAB_BRANCH_CODE ||
		', '||'BAB_BANK_CODE '||row_dc.BAB_BANK_CODE ||
		', '||'BAB_ACC_NUMBER '||row_dc.BAB_ACC_NUMBER ||
		', '||'BAB_COMP_CODE '||row_dc.BAB_COMP_CODE ||
		' already exists in DA.BABANKACCT table.');

 end loop;

--BANKAC_PK
 for row_dc in cur_BANKAC_PK
 loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,
                'BANKAC_PK',
                'BANKAC_PK',
                'Record with '||'BAB_COMP_CODE '||row_dc.BAB_COMP_CODE ||
		', '||'BAB_DEPT_CODE '||row_dc.BAB_DEPT_CODE ||
		', '||'BAB_ACC_CODE '||row_dc.BAB_ACC_CODE ||
		' already exists in DA.BABANKACCT table.');

 end loop;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_BABANKACCT table
--======================================================================
PROCEDURE IDX_DUPL AS

--BABANKACCT_UK2
cursor cur_BABANKACCT_UK2 is
  select dc_rownum,
	 BAB_BANK_CODE,
	 BAB_ACC_PREFIX,
	 BAB_ACC_NUMBER,
	 BAB_COMP_CODE
    from DA.DC_BABANKACCT S1
      where
        exists (select '1'
                  from DA.DC_BABANKACCT S2
                    where S1.BAB_BANK_CODE = S2.BAB_BANK_CODE
		      and S1.BAB_ACC_PREFIX = S2.BAB_ACC_PREFIX
		      and S1.BAB_ACC_NUMBER = S2.BAB_ACC_NUMBER
		      and S1.BAB_COMP_CODE = S2.BAB_COMP_CODE
		      and S1.rowid != S2.rowid );
--BABANKACCT_UK3
cursor cur_BABANKACCT_UK3 is
  select dc_rownum,
	 BAB_BRANCH_CODE,
	 BAB_BANK_CODE,
	 BAB_ACC_NUMBER,
	 BAB_COMP_CODE
    from DA.DC_BABANKACCT S1
      where
        exists (select '1'
                  from DA.DC_BABANKACCT S2
                    where S1.BAB_BRANCH_CODE = S2.BAB_BRANCH_CODE
		      and S1.BAB_BANK_CODE = S2.BAB_BANK_CODE
		      and S1.BAB_ACC_NUMBER = S2.BAB_ACC_NUMBER
		      and S1.BAB_COMP_CODE = S2.BAB_COMP_CODE
		      and S1.rowid != S2.rowid );
--BANKAC_PK
cursor cur_BANKAC_PK is
  select dc_rownum,
	 BAB_COMP_CODE,
	 BAB_DEPT_CODE,
	 BAB_ACC_CODE
    from DA.DC_BABANKACCT S1
      where
        exists (select '1'
                  from DA.DC_BABANKACCT S2
                    where S1.BAB_COMP_CODE = S2.BAB_COMP_CODE
		      and S1.BAB_DEPT_CODE = S2.BAB_DEPT_CODE
		      and S1.BAB_ACC_CODE = S2.BAB_ACC_CODE
		      and S1.rowid != S2.rowid );
BEGIN
 null; 

--BABANKACCT_UK2
 for row_dc in cur_BABANKACCT_UK2
 loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,
                'BABANKACCT_UK2',
                'BABANKACCT_UK2',
                'Record with '||'BAB_BANK_CODE '||row_dc.BAB_BANK_CODE ||
		', '||'BAB_ACC_PREFIX '||row_dc.BAB_ACC_PREFIX ||
		', '||'BAB_ACC_NUMBER '||row_dc.BAB_ACC_NUMBER ||
		', '||'BAB_COMP_CODE '||row_dc.BAB_COMP_CODE ||
		' already exists in DA.DC_BABANKACCT table.');
end loop;

--BABANKACCT_UK3
 for row_dc in cur_BABANKACCT_UK3
 loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,
                'BABANKACCT_UK3',
                'BABANKACCT_UK3',
                'Record with '||'BAB_BRANCH_CODE '||row_dc.BAB_BRANCH_CODE ||
		', '||'BAB_BANK_CODE '||row_dc.BAB_BANK_CODE ||
		', '||'BAB_ACC_NUMBER '||row_dc.BAB_ACC_NUMBER ||
		', '||'BAB_COMP_CODE '||row_dc.BAB_COMP_CODE ||
		' already exists in DA.DC_BABANKACCT table.');
end loop;

--BANKAC_PK
 for row_dc in cur_BANKAC_PK
 loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,
                'BANKAC_PK',
                'BANKAC_PK',
                'Record with '||'BAB_COMP_CODE '||row_dc.BAB_COMP_CODE ||
		', '||'BAB_DEPT_CODE '||row_dc.BAB_DEPT_CODE ||
		', '||'BAB_ACC_CODE '||row_dc.BAB_ACC_CODE ||
		' already exists in DA.DC_BABANKACCT table.');
end loop;
END IDX_DUPL;

--======================================================================
--BAB_COMP_CODE
--======================================================================
PROCEDURE BAB_COMP_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_COMP_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_COMP_CODE',
        'BAB_COMP_CODE',
        'BAB_COMP_CODE can not be null.');
  end loop;
END BAB_COMP_CODE;

--======================================================================
--BAB_COMP_CODE_2
--======================================================================
PROCEDURE BAB_COMP_CODE_2 AS
  cursor cur_BAB_COMP_CODE is
    select dc_rownum,
           BAB_COMP_CODE
      from DA.DC_BABANKACCT  ;

 t_result        da.apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 for row_dc in cur_BAB_COMP_CODE
 loop
   t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
              row_dc.BAB_COMP_CODE,t_comp_name);
   if ('0' != t_result) then
         da.dbk_dc.error('DC_BABANKACCT',
                row_dc.dc_rownum,
                'BAB_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   end if;
 end loop;
END BAB_COMP_CODE_2;

--======================================================================
--BAB_DEPT_CODE
--======================================================================
PROCEDURE BAB_DEPT_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_DEPT_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_DEPT_CODE',
        'BAB_DEPT_CODE',
        'BAB_DEPT_CODE can not be null.');
  end loop;
END BAB_DEPT_CODE;

--======================================================================
--DEPT_CODE_2
--======================================================================
PROCEDURE DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         BAB_COMP_CODE,
         BAB_DEPT_CODE
    from DA.DC_BABANKACCT ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE),
                row_dc.BAB_COMP_CODE,
                row_dc.BAB_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_BABANKACCT',
                row_dc.dc_rownum,
                'BAB_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END DEPT_CODE_2;

--======================================================================
--BAB_ACC_CODE
--======================================================================
PROCEDURE BAB_ACC_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_ACC_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_ACC_CODE',
        'BAB_ACC_CODE',
        'BAB_ACC_CODE can not be null.');
  end loop;
END BAB_ACC_CODE;

--======================================================================
--ACC_CODE
--======================================================================
PROCEDURE ACC_CODE AS
 t_result        da.apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         BAB_COMP_CODE,
         BAB_DEPT_CODE,
         BAB_ACC_CODE
   from  DA.DC_BABANKACCT ;

BEGIN

 for row_dc in cur_acc_code
 loop
    t_result := da.apk_gl_account.chk_by_company_dept(
                        da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.ACCOUNT_ALLOWS_TRANSACTIONS),
                row_dc.BAB_COMP_CODE,
                row_dc.BAB_DEPT_CODE,
                row_dc.BAB_ACC_CODE,
                t_acc_name);
    if ('0' != t_result)
    then
      da.dbk_dc.error('DC_BABANKACCT',
                row_dc.dc_rownum,
                'BAB_ACC_CODE',
                'ACC_CODE',
                t_result);
    end if; 
 end loop;
END ACC_CODE;

--======================================================================
--BAB_BANK_CODE
--======================================================================
PROCEDURE BAB_BANK_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_BANK_CODE is not null and BAB_BANK_CODE NOT IN (select bnk_bank_code from da.babank where bnk_bank_code = BAB_BANK_CODE and nvl(bnk_active_flag,'1') = '1');
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_BANK_CODE',
        'BAB_BANK_CODE',
        'Not a valid BAB_BANK_CODE');
  end loop;
END BAB_BANK_CODE;

--======================================================================
--BAB_ACC_NUMBER
--======================================================================
PROCEDURE BAB_ACC_NUMBER AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_ACC_NUMBER is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_ACC_NUMBER',
        'BAB_ACC_NUMBER',
        'BAB_ACC_NUMBER can not be null.');
  end loop;
END BAB_ACC_NUMBER;

--======================================================================
--BAB_CURR_CODE
--======================================================================
PROCEDURE BAB_CURR_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_CURR_CODE is not null and BAB_CURR_CODE NOT IN (select acc_curr_code from da.account, da.company where acc_conschart_code = comp_conschart_code and acc_code = BAB_ACC_CODE and comp_code = BAB_COMP_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_CURR_CODE',
        'BAB_CURR_CODE',
        'Not a valid BAB_CURR_CODE');
  end loop;
END BAB_CURR_CODE;

--======================================================================
--BAB_ACC_TYPE
--======================================================================
PROCEDURE BAB_ACC_TYPE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_ACC_TYPE NOT IN (select BAACTP_CODE from da.BAACCTYPE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_ACC_TYPE',
        'BAB_ACC_TYPE',
        'Not a valid BAB_ACC_TYPE');
  end loop;
END BAB_ACC_TYPE;

--======================================================================
--BAB_AMT_FOR_TWO_SIGN
--======================================================================
PROCEDURE BAB_AMT_FOR_TWO_SIGN AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_AMT_FOR_TWO_SIGN < 0;
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_AMT_FOR_TWO_SIGN',
        'BAB_AMT_FOR_TWO_SIGN',
        'Not a valid BAB_AMT_FOR_TWO_SIGN');
  end loop;
END BAB_AMT_FOR_TWO_SIGN;

--======================================================================
--BAB_AMT_FOR_MAN_SIGN
--======================================================================
PROCEDURE BAB_AMT_FOR_MAN_SIGN AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_AMT_FOR_MAN_SIGN < 0;
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_AMT_FOR_MAN_SIGN',
        'BAB_AMT_FOR_MAN_SIGN',
        'Not a valid BAB_AMT_FOR_MAN_SIGN');
  end loop;
END BAB_AMT_FOR_MAN_SIGN;

--======================================================================
--PRINT_COMP_ADDR
--======================================================================
PROCEDURE PRINT_COMP_ADDR AS
  cursor cur_dc is
    select dc_rownum,
           BAB_PRINT_COMP_ADDR
      from DA.DC_BABANKACCT
        where nvl(BAB_PRINT_COMP_ADDR,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_PRINT_COMP_ADDR',
        'BAB_PRINT_COMP_ADDR',
        'BAB_PRINT_COMP_ADDR must be set to ''Y'',''N''.');

  end loop;
END PRINT_COMP_ADDR;

--======================================================================
--PRINT_BANK_ADDR
--======================================================================
PROCEDURE PRINT_BANK_ADDR AS
  cursor cur_dc is
    select dc_rownum,
           BAB_PRINT_BANK_ADDR
      from DA.DC_BABANKACCT
        where nvl(BAB_PRINT_BANK_ADDR,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_PRINT_BANK_ADDR',
        'BAB_PRINT_BANK_ADDR',
        'BAB_PRINT_BANK_ADDR must be set to ''Y'',''N''.');

  end loop;
END PRINT_BANK_ADDR;

--======================================================================
--PRINT_CHECK_FRAME
--======================================================================
PROCEDURE PRINT_CHECK_FRAME AS
  cursor cur_dc is
    select dc_rownum,
           BAB_PRINT_CHECK_FRAME
      from DA.DC_BABANKACCT
        where nvl(BAB_PRINT_CHECK_FRAME,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_PRINT_CHECK_FRAME',
        'BAB_PRINT_CHECK_FRAME',
        'BAB_PRINT_CHECK_FRAME must be set to ''Y'',''N''.');

  end loop;
END PRINT_CHECK_FRAME;

--======================================================================
--PRINT_ROUTING
--======================================================================
PROCEDURE PRINT_ROUTING AS
  cursor cur_dc is
    select dc_rownum,
           BAB_PRINT_ROUTING
      from DA.DC_BABANKACCT
        where nvl(BAB_PRINT_ROUTING,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_PRINT_ROUTING',
        'BAB_PRINT_ROUTING',
        'BAB_PRINT_ROUTING must be set to ''Y'',''N''.');

  end loop;
END PRINT_ROUTING;

--======================================================================
--PRINT_MICR
--======================================================================
PROCEDURE PRINT_MICR AS
  cursor cur_dc is
    select dc_rownum,
           BAB_PRINT_MICR
      from DA.DC_BABANKACCT
        where nvl(BAB_PRINT_MICR,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_PRINT_MICR',
        'BAB_PRINT_MICR',
        'BAB_PRINT_MICR must be set to ''Y'',''N''.');

  end loop;
END PRINT_MICR;

--======================================================================
--BAB_EFT_FILE_FORMAT
--======================================================================
PROCEDURE BAB_EFT_FILE_FORMAT AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_EFT_FILE_FORMAT NOT IN (select distinct sd_code from da.sddata where sd_app_code = 'AP' and sd_sdu_code = 'APEFORMAT');
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_EFT_FILE_FORMAT',
        'BAB_EFT_FILE_FORMAT',
        'Not a valid BAB_EFT_FILE_FORMAT');
  end loop;
END BAB_EFT_FILE_FORMAT;

--======================================================================
--BAB_EFT_FILE_CODE
--======================================================================
PROCEDURE BAB_EFT_FILE_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_EFT_FILE_CODE NOT IN (select apef_file_code from da.apeftfile where apef_file_format = BAB_EFT_FILE_FORMAT);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_EFT_FILE_CODE',
        'BAB_EFT_FILE_CODE',
        'Not a valid BAB_EFT_FILE_CODE');
  end loop;
END BAB_EFT_FILE_CODE;

--======================================================================
--BAB_CHEQUE_DATE_FORMAT
--======================================================================
PROCEDURE BAB_CHEQUE_DATE_FORMAT AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_CHEQUE_DATE_FORMAT NOT IN (select 'DDMMYYYY' from dual union select 'MMDDYYYY' from dual union select 'YYYYMMDD' from dual);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_CHEQUE_DATE_FORMAT',
        'BAB_CHEQUE_DATE_FORMAT',
        'Not a valid BAB_CHEQUE_DATE_FORMAT');
  end loop;
END BAB_CHEQUE_DATE_FORMAT;

--======================================================================
--BAB_BRANCH_CODE
--======================================================================
PROCEDURE BAB_BRANCH_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_BABANKACCT
        where BAB_BRANCH_CODE NOT IN (select brn_branch_code from da.babranch where brn_bank_code = BAB_BANK_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_BABANKACCT',row_dc.dc_rownum,'BAB_BRANCH_CODE',
        'BAB_BRANCH_CODE',
        'Not a valid BAB_BRANCH_CODE');
  end loop;
END BAB_BRANCH_CODE;

--======================================================================
--VERIFY_DATA - run all verify procedures define for BABANKACCT table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
        display_status(' Delete rows DC_BABANKACCT from DA.DC_ERROR.');
        delete from da.dc_error
          where upper(dcerr_table_name) = 'DC_BABANKACCT' ;

        commit;

        display_status(' INDEX checking in DA.BABANKACCT');
        idx_check;

        commit;

        display_status(' INDEX  checking in DA.DC_BABANKACCT');
        idx_dupl;

        commit;

        display_status(' FOREIGN KEYS checking in DA.DC_BABANKACCT');
        Fk_con;

        commit;

        display_status(' CHECK constraints checking in DA.DC_BABANKACCT');
        check_con;

        commit;


        display_status(' BAB_BAB_COMP_CODE - checking');
        BAB_COMP_CODE;

        commit;

        display_status(' BAB_BAB_COMP_CODE_2 - checking');
        BAB_COMP_CODE_2;

        commit;

        display_status(' BAB_BAB_DEPT_CODE - checking');
        BAB_DEPT_CODE;

        commit;

        display_status(' BAB_DEPT_CODE_2 - checking');
        DEPT_CODE_2;

        commit;

        display_status(' BAB_BAB_ACC_CODE - checking');
        BAB_ACC_CODE;

        commit;

        display_status(' BAB_ACC_CODE - checking');
        ACC_CODE;

        commit;

        display_status(' BAB_BAB_BANK_CODE - checking');
        BAB_BANK_CODE;

        commit;

        display_status(' BAB_BAB_ACC_NUMBER - checking');
        BAB_ACC_NUMBER;

        commit;

        display_status(' BAB_BAB_CURR_CODE - checking');
        BAB_CURR_CODE;

        commit;

        display_status(' BAB_BAB_ACC_TYPE - checking');
        BAB_ACC_TYPE;

        commit;

        display_status(' BAB_BAB_AMT_FOR_TWO_SIGN - checking');
        BAB_AMT_FOR_TWO_SIGN;

        commit;

        display_status(' BAB_BAB_AMT_FOR_MAN_SIGN - checking');
        BAB_AMT_FOR_MAN_SIGN;

        commit;

        display_status(' BAB_PRINT_COMP_ADDR - checking');
        PRINT_COMP_ADDR;

        commit;

        display_status(' BAB_PRINT_BANK_ADDR - checking');
        PRINT_BANK_ADDR;

        commit;

        display_status(' BAB_PRINT_CHECK_FRAME - checking');
        PRINT_CHECK_FRAME;

        commit;

        display_status(' BAB_PRINT_ROUTING - checking');
        PRINT_ROUTING;

        commit;

        display_status(' BAB_PRINT_MICR - checking');
        PRINT_MICR;

        commit;

        display_status(' BAB_BAB_EFT_FILE_FORMAT - checking');
        BAB_EFT_FILE_FORMAT;

        commit;

        display_status(' BAB_BAB_EFT_FILE_CODE - checking');
        BAB_EFT_FILE_CODE;

        commit;

        display_status(' BAB_BAB_CHEQUE_DATE_FORMAT - checking');
        BAB_CHEQUE_DATE_FORMAT;

        commit;

        display_status(' BAB_BAB_BRANCH_CODE - checking');
        BAB_BRANCH_CODE;

        commit;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.BABANKACCT table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_BABANKACCT table
   cursor cur_err_BABANKACCT is
     select count(1)
       from da.dc_error
        where upper(dcerr_table_name) = 'DC_BABANKACCT' ;

   t_n_err_BABANKACCT         NUMBER;

 cursor cInsert is 
   select
	BAB_COMP_CODE		--1
	,BAB_DEPT_CODE		--2
	,BAB_ACC_CODE		--3
	,BAB_BANK_CODE		--4
	,BAB_ACC_PREFIX		--5
	,BAB_ACC_NUMBER		--6
	,BAB_CURR_CODE		--7
	,BAB_FXGAIN_DEPT_CODE		--8
	,BAB_FXGAIN_ACC_CODE		--9
	,BAB_FXLOSS_DEPT_CODE		--10
	,BAB_FXLOSS_ACC_CODE		--11
	,BAB_SUSP_REC_DEPT_CODE		--12
	,BAB_SUSP_REC_ACC_CODE		--13
	,BAB_SUSP_PAY_DEPT_CODE		--14
	,BAB_SUSP_PAY_ACC_CODE		--15
	,BAB_LAST_CHQ_NUM		--16
	,BAB_ACC_TITLE		--17
	,BAB_ACC_TYPE		--18
	,BAB_EFT_DESC		--19
	,BAB_EFT_FORMAT		--20
	,BAB_FC_BAL_AMT		--21
	,BAB_CREATE_USER		--22
	,BAB_CREATE_DATE		--23
	,BAB_LAST_UPD_USER		--24
	,BAB_LAST_UPD_DATE		--25
	,BAB_BRANCH_CODE		--26
	,BAB_MICR_CODE		--27
	,BAB_SIGN_FILE1		--28
	,BAB_SIGN_FILE2		--29
	,BAB_COMP_LOGO_FILE		--30
	,BAB_AMT_FOR_TWO_SIGN		--31
	,BAB_AMT_FOR_MAN_SIGN		--32
	,BAB_PRINT_COMP_ADDR		--33
	,BAB_COMP_ADDR_CODE		--34
	,BAB_PRINT_BANK_ADDR		--35
	,BAB_PRINT_CHECK_FRAME		--36
	,BAB_ROUTING_CODE_A		--37
	,BAB_ROUTING_CODE_B		--38
	,BAB_PRINT_ROUTING		--39
	,BAB_PRINT_MICR		--40
	,BAB_EFT_FILE_FORMAT		--41
	,BAB_EFT_FILE_CODE		--42
	,BAB_CDA_ACC_NUMBER		--43
	,BAB_CSR_ACC_NUMBER		--44
	,BAB_BANK_CUSTOMER_ID		--45
	,BAB_LAST_EFT_NUM		--46
	,BAB_FILE_NUMBER		--47
	,BAB_PAY_THROUGH		--48
	,BAB_CURR_DESIGN		--49
	,BAB_CHEQUE_DATE_FORMAT		--50
   from DA.DC_BABANKACCT;

BEGIN
 open  cur_err_BABANKACCT;
 fetch cur_err_BABANKACCT into t_n_err_BABANKACCT;
 close cur_err_BABANKACCT;

 display_status('Number of errors in DC_ERROR table for DC_BABANKACCT table :'||
                to_char(t_n_err_BABANKACCT));

 if ( t_n_err_BABANKACCT = 0 )
 then

   display_status('Insert into DA.BABANKACCT');

--Insert select section 
-- use this statement if speed is the problem and there are no triggers
-- causing mutating problem

/*     insert into DA.BABANKACCT
        (BAB_COMP_CODE		--1
	,BAB_DEPT_CODE		--2
	,BAB_ACC_CODE		--3
	,BAB_BANK_CODE		--4
	,BAB_ACC_PREFIX		--5
	,BAB_ACC_NUMBER		--6
	,BAB_CURR_CODE		--7
	,BAB_FXGAIN_DEPT_CODE		--8
	,BAB_FXGAIN_ACC_CODE		--9
	,BAB_FXLOSS_DEPT_CODE		--10
	,BAB_FXLOSS_ACC_CODE		--11
	,BAB_SUSP_REC_DEPT_CODE		--12
	,BAB_SUSP_REC_ACC_CODE		--13
	,BAB_SUSP_PAY_DEPT_CODE		--14
	,BAB_SUSP_PAY_ACC_CODE		--15
	,BAB_LAST_CHQ_NUM		--16
	,BAB_ACC_TITLE		--17
	,BAB_ACC_TYPE		--18
	,BAB_EFT_DESC		--19
	,BAB_EFT_FORMAT		--20
	,BAB_FC_BAL_AMT		--21
	,BAB_CREATE_USER		--22
	,BAB_CREATE_DATE		--23
	,BAB_LAST_UPD_USER		--24
	,BAB_LAST_UPD_DATE		--25
	,BAB_BRANCH_CODE		--26
	,BAB_MICR_CODE		--27
	,BAB_SIGN_FILE1		--28
	,BAB_SIGN_FILE2		--29
	,BAB_COMP_LOGO_FILE		--30
	,BAB_AMT_FOR_TWO_SIGN		--31
	,BAB_AMT_FOR_MAN_SIGN		--32
	,BAB_PRINT_COMP_ADDR		--33
	,BAB_COMP_ADDR_CODE		--34
	,BAB_PRINT_BANK_ADDR		--35
	,BAB_PRINT_CHECK_FRAME		--36
	,BAB_ROUTING_CODE_A		--37
	,BAB_ROUTING_CODE_B		--38
	,BAB_PRINT_ROUTING		--39
	,BAB_PRINT_MICR		--40
	,BAB_EFT_FILE_FORMAT		--41
	,BAB_EFT_FILE_CODE		--42
	,BAB_CDA_ACC_NUMBER		--43
	,BAB_CSR_ACC_NUMBER		--44
	,BAB_BANK_CUSTOMER_ID		--45
	,BAB_LAST_EFT_NUM		--46
	,BAB_FILE_NUMBER		--47
	,BAB_PAY_THROUGH		--48
	,BAB_CURR_DESIGN		--49
	,BAB_CHEQUE_DATE_FORMAT		--50
) select
	BAB_COMP_CODE		--1
	,BAB_DEPT_CODE		--2
	,BAB_ACC_CODE		--3
	,BAB_BANK_CODE		--4
	,BAB_ACC_PREFIX		--5
	,BAB_ACC_NUMBER		--6
	,BAB_CURR_CODE		--7
	,BAB_FXGAIN_DEPT_CODE		--8
	,BAB_FXGAIN_ACC_CODE		--9
	,BAB_FXLOSS_DEPT_CODE		--10
	,BAB_FXLOSS_ACC_CODE		--11
	,BAB_SUSP_REC_DEPT_CODE		--12
	,BAB_SUSP_REC_ACC_CODE		--13
	,BAB_SUSP_PAY_DEPT_CODE		--14
	,BAB_SUSP_PAY_ACC_CODE		--15
	,BAB_LAST_CHQ_NUM		--16
	,BAB_ACC_TITLE		--17
	,BAB_ACC_TYPE		--18
	,BAB_EFT_DESC		--19
	,BAB_EFT_FORMAT		--20
	,BAB_FC_BAL_AMT		--21
	,BAB_CREATE_USER		--22
	,BAB_CREATE_DATE		--23
	,BAB_LAST_UPD_USER		--24
	,BAB_LAST_UPD_DATE		--25
	,BAB_BRANCH_CODE		--26
	,BAB_MICR_CODE		--27
	,BAB_SIGN_FILE1		--28
	,BAB_SIGN_FILE2		--29
	,BAB_COMP_LOGO_FILE		--30
	,BAB_AMT_FOR_TWO_SIGN		--31
	,BAB_AMT_FOR_MAN_SIGN		--32
	,BAB_PRINT_COMP_ADDR		--33
	,BAB_COMP_ADDR_CODE		--34
	,BAB_PRINT_BANK_ADDR		--35
	,BAB_PRINT_CHECK_FRAME		--36
	,BAB_ROUTING_CODE_A		--37
	,BAB_ROUTING_CODE_B		--38
	,BAB_PRINT_ROUTING		--39
	,BAB_PRINT_MICR		--40
	,BAB_EFT_FILE_FORMAT		--41
	,BAB_EFT_FILE_CODE		--42
	,BAB_CDA_ACC_NUMBER		--43
	,BAB_CSR_ACC_NUMBER		--44
	,BAB_BANK_CUSTOMER_ID		--45
	,BAB_LAST_EFT_NUM		--46
	,BAB_FILE_NUMBER		--47
	,BAB_PAY_THROUGH		--48
	,BAB_CURR_DESIGN		--49
	,BAB_CHEQUE_DATE_FORMAT		--50
   from DA.DC_BABANKACCT;
*/
--End of insert select section

--insert loop
   for row_dc in cInsert
   loop
     insert into DA.BABANKACCT
        (BAB_COMP_CODE		--1
	,BAB_DEPT_CODE		--2
	,BAB_ACC_CODE		--3
	,BAB_BANK_CODE		--4
	,BAB_ACC_PREFIX		--5
	,BAB_ACC_NUMBER		--6
	,BAB_CURR_CODE		--7
	,BAB_FXGAIN_DEPT_CODE		--8
	,BAB_FXGAIN_ACC_CODE		--9
	,BAB_FXLOSS_DEPT_CODE		--10
	,BAB_FXLOSS_ACC_CODE		--11
	,BAB_SUSP_REC_DEPT_CODE		--12
	,BAB_SUSP_REC_ACC_CODE		--13
	,BAB_SUSP_PAY_DEPT_CODE		--14
	,BAB_SUSP_PAY_ACC_CODE		--15
	,BAB_LAST_CHQ_NUM		--16
	,BAB_ACC_TITLE		--17
	,BAB_ACC_TYPE		--18
	,BAB_EFT_DESC		--19
	,BAB_EFT_FORMAT		--20
	,BAB_FC_BAL_AMT		--21
	,BAB_CREATE_USER		--22
	,BAB_CREATE_DATE		--23
	,BAB_LAST_UPD_USER		--24
	,BAB_LAST_UPD_DATE		--25
	,BAB_BRANCH_CODE		--26
	,BAB_MICR_CODE		--27
	,BAB_SIGN_FILE1		--28
	,BAB_SIGN_FILE2		--29
	,BAB_COMP_LOGO_FILE		--30
	,BAB_AMT_FOR_TWO_SIGN		--31
	,BAB_AMT_FOR_MAN_SIGN		--32
	,BAB_PRINT_COMP_ADDR		--33
	,BAB_COMP_ADDR_CODE		--34
	,BAB_PRINT_BANK_ADDR		--35
	,BAB_PRINT_CHECK_FRAME		--36
	,BAB_ROUTING_CODE_A		--37
	,BAB_ROUTING_CODE_B		--38
	,BAB_PRINT_ROUTING		--39
	,BAB_PRINT_MICR		--40
	,BAB_EFT_FILE_FORMAT		--41
	,BAB_EFT_FILE_CODE		--42
	,BAB_CDA_ACC_NUMBER		--43
	,BAB_CSR_ACC_NUMBER		--44
	,BAB_BANK_CUSTOMER_ID		--45
	,BAB_LAST_EFT_NUM		--46
	,BAB_FILE_NUMBER		--47
	,BAB_PAY_THROUGH		--48
	,BAB_CURR_DESIGN		--49
	,BAB_CHEQUE_DATE_FORMAT		--50
     )values
	(row_dc.BAB_COMP_CODE		--1
	,row_dc.BAB_DEPT_CODE		--2
	,row_dc.BAB_ACC_CODE		--3
	,row_dc.BAB_BANK_CODE		--4
	,row_dc.BAB_ACC_PREFIX		--5
	,row_dc.BAB_ACC_NUMBER		--6
	,row_dc.BAB_CURR_CODE		--7
	,row_dc.BAB_FXGAIN_DEPT_CODE		--8
	,row_dc.BAB_FXGAIN_ACC_CODE		--9
	,row_dc.BAB_FXLOSS_DEPT_CODE		--10
	,row_dc.BAB_FXLOSS_ACC_CODE		--11
	,row_dc.BAB_SUSP_REC_DEPT_CODE		--12
	,row_dc.BAB_SUSP_REC_ACC_CODE		--13
	,row_dc.BAB_SUSP_PAY_DEPT_CODE		--14
	,row_dc.BAB_SUSP_PAY_ACC_CODE		--15
	,row_dc.BAB_LAST_CHQ_NUM		--16
	,row_dc.BAB_ACC_TITLE		--17
	,row_dc.BAB_ACC_TYPE		--18
	,row_dc.BAB_EFT_DESC		--19
	,row_dc.BAB_EFT_FORMAT		--20
	,row_dc.BAB_FC_BAL_AMT		--21
	,row_dc.BAB_CREATE_USER		--22
	,row_dc.BAB_CREATE_DATE		--23
	,row_dc.BAB_LAST_UPD_USER		--24
	,row_dc.BAB_LAST_UPD_DATE		--25
	,row_dc.BAB_BRANCH_CODE		--26
	,row_dc.BAB_MICR_CODE		--27
	,row_dc.BAB_SIGN_FILE1		--28
	,row_dc.BAB_SIGN_FILE2		--29
	,row_dc.BAB_COMP_LOGO_FILE		--30
	,row_dc.BAB_AMT_FOR_TWO_SIGN		--31
	,row_dc.BAB_AMT_FOR_MAN_SIGN		--32
	,row_dc.BAB_PRINT_COMP_ADDR		--33
	,row_dc.BAB_COMP_ADDR_CODE		--34
	,row_dc.BAB_PRINT_BANK_ADDR		--35
	,row_dc.BAB_PRINT_CHECK_FRAME		--36
	,row_dc.BAB_ROUTING_CODE_A		--37
	,row_dc.BAB_ROUTING_CODE_B		--38
	,row_dc.BAB_PRINT_ROUTING		--39
	,row_dc.BAB_PRINT_MICR		--40
	,row_dc.BAB_EFT_FILE_FORMAT		--41
	,row_dc.BAB_EFT_FILE_CODE		--42
	,row_dc.BAB_CDA_ACC_NUMBER		--43
	,row_dc.BAB_CSR_ACC_NUMBER		--44
	,row_dc.BAB_BANK_CUSTOMER_ID		--45
	,row_dc.BAB_LAST_EFT_NUM		--46
	,row_dc.BAB_FILE_NUMBER		--47
	,row_dc.BAB_PAY_THROUGH		--48
	,row_dc.BAB_CURR_DESIGN		--49
	,row_dc.BAB_CHEQUE_DATE_FORMAT		--50
     );
   end loop;
--end of loop insert


  --delete everything from DA.DC_BABANKACCT
    display_status('Delete rows from DA.DC_BABANKACCT table.');
    delete from DA.DC_BABANKACCT;
    display_status('Number of records deleted from DA.DC_BABANKACCT table:'||to_char(SQL%rowcount));

     display_status('BABANKACCT moving from temp table was successful.');
--     commit;

 end if; /*    if nvl(t_n_err_BABANKACCT,0) = 0 */

exception when others
     then
       display_status('Can not move data from DA.DC_BABANKACCT into DA.BABANKACCT.');
       da.dbk_dc.output(SQLERRM);
       rollback;
       raise;

END Process_temp_data ;

END DBK_DC_BABANKACCT;
/
show error
/
