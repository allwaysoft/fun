CREATE OR REPLACE PACKAGE    CC_DBK_DC_INVDIST AS

 PROCEDURE Verify_data;

 PROCEDURE Process_Temp_Data;

 PROCEDURE Idx_check;

 PROCEDURE Idx_dupl;

 PROCEDURE Fk_con;

 PROCEDURE Check_con;


 PROCEDURE IDIST_COMP_CODE;

 PROCEDURE SOURCE_CODE;

 PROCEDURE IDIST_INV_NUM;

 PROCEDURE IDIST_INV_NUM_2;

 PROCEDURE IDIST_INV_NUM_3;

 PROCEDURE IDIST_LINE_NUM;

 PROCEDURE IDIST_BCH_NUM;

 PROCEDURE IDIST_BCH_NUM_2;

 PROCEDURE IDIST_BCH_NUM_3;

 PROCEDURE IDIST_BCH_NUM_4;

 PROCEDURE TYPE_CODE;

 PROCEDURE IDIST_DATE;

 PROCEDURE IDIST_DATE_2;

 PROCEDURE IDIST_DATE_3;

 PROCEDURE IDIST_POST_DATE;

 PROCEDURE IDIST_POST_DATE_2;

 PROCEDURE IDIST_POST_DATE_3;

 PROCEDURE DEPT_CODE_2;

 PROCEDURE ACC_CODE;

 PROCEDURE IDIST_JOB_CODE;

 PROCEDURE IDIST_JOB_CTRL_CODE;

 PROCEDURE IDIST_PHS_CODE;

 PROCEDURE IDIST_PHS_CTRL_CODE;

 PROCEDURE IDIST_CAT_CODE;

 PROCEDURE IDIST_CAT_CTRL_CODE;

 PROCEDURE IDIST_ACC_COMP_CODE;

 PROCEDURE BATCH_SUM;

END CC_DBK_DC_INVDIST;
/


CREATE OR REPLACE PACKAGE BODY    CC_DBK_DC_INVDIST AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.dbk_dc.display_status('DC_INVDIST',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS

BEGIN
null;

END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--SYS_C008538 - "IDIST_LINE_NUM" IS NOT NULL
 cursor cur_SYS_C008538 is
        select dc_rownum
          from DA.DC_INVDIST
            where not "IDIST_LINE_NUM" IS NOT NULL ;

--SYS_C008536 - "IDIST_SOURCE_CODE" IS NOT NULL
 cursor cur_SYS_C008536 is
        select dc_rownum
          from DA.DC_INVDIST
            where not "IDIST_SOURCE_CODE" IS NOT NULL ;

--SYS_C008537 - "IDIST_INV_NUM" IS NOT NULL
 cursor cur_SYS_C008537 is
        select dc_rownum
          from DA.DC_INVDIST
            where not "IDIST_INV_NUM" IS NOT NULL ;

--SYS_C008535 - "IDIST_COMP_CODE" IS NOT NULL
 cursor cur_SYS_C008535 is
        select dc_rownum
          from DA.DC_INVDIST
            where not "IDIST_COMP_CODE" IS NOT NULL ;

BEGIN
null;

 for row_dc in cur_SYS_C008538
 loop
    da.dbk_dc.error('DC_INVDIST',
                    row_dc.dc_rownum,
                    'SYS_C008538',
                    'SYS_C008538',
                    'Condition "IDIST_LINE_NUM" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C008536
 loop
    da.dbk_dc.error('DC_INVDIST',
                    row_dc.dc_rownum,
                    'SYS_C008536',
                    'SYS_C008536',
                    'Condition "IDIST_SOURCE_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C008537
 loop
    da.dbk_dc.error('DC_INVDIST',
                    row_dc.dc_rownum,
                    'SYS_C008537',
                    'SYS_C008537',
                    'Condition "IDIST_INV_NUM" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C008535
 loop
    da.dbk_dc.error('DC_INVDIST',
                    row_dc.dc_rownum,
                    'SYS_C008535',
                    'SYS_C008535',
                    'Condition "IDIST_COMP_CODE" IS NOT NULL failed.');
 end loop;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.INVDIST table
--======================================================================
PROCEDURE IDX_CHECK AS

BEGIN
 null;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_INVDIST table
--======================================================================
PROCEDURE IDX_DUPL AS

BEGIN
 null;
END IDX_DUPL;

--======================================================================
--IDIST_COMP_CODE
--======================================================================
PROCEDURE IDIST_COMP_CODE AS
  cursor cur_IDIST_COMP_CODE is
    select dc_rownum,
           IDIST_COMP_CODE
      from DA.DC_INVDIST  ;

 t_result        da.apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 for row_dc in cur_IDIST_COMP_CODE
 loop
   t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
              row_dc.IDIST_COMP_CODE,t_comp_name);
   if ('0' != t_result) then
         da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   end if;
 end loop;
END IDIST_COMP_CODE;

--======================================================================
--SOURCE_CODE
--======================================================================
PROCEDURE SOURCE_CODE AS
  cursor cur_dc is
    select dc_rownum,
           IDIST_SOURCE_CODE
      from DA.DC_INVDIST
        where nvl(IDIST_SOURCE_CODE,'xxxx') not in ('I','C');
BEGIN
  for row_dc in cur_dc
  loop

        da.dbk_dc.error('DC_INVDIST',row_dc.dc_rownum,'IDIST_SOURCE_CODE',
        'IDIST_SOURCE_CODE',
        'IDIST_SOURCE_CODE must be set to ''I'',''C''.');

  end loop;
END SOURCE_CODE;

--======================================================================
--IDIST_INV_NUM
--======================================================================
PROCEDURE IDIST_INV_NUM AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_INVDIST
        where IDIST_INV_NUM is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_INVDIST',row_dc.dc_rownum,'IDIST_INV_NUM',
        'IDIST_INV_NUM',
        'IDIST_INV_NUM can not be null.');
  end loop;
END IDIST_INV_NUM;

--======================================================================
--IDIST_INV_NUM_2
--======================================================================
PROCEDURE IDIST_INV_NUM_2 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE = 'I'
	    and not exists (select '1'
                        from DA.INVOICE  T2
                          where T1.IDIST_COMP_CODE = T2.INV_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.INV_NUM );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_INV_NUM is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_INV_NUM',
                'INVOICE',
                'Record with'||
		' INV_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' INV_NUM '||row_dc.IDIST_INV_NUM||
		' does not exist in DA.INVOICE table.');
    end if;
 end loop;

END IDIST_INV_NUM_2;

--======================================================================
--IDIST_INV_NUM_3
--======================================================================
PROCEDURE IDIST_INV_NUM_3 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE='C'
	    and not exists (select '1'
                        from DA.PAYMENT  T2
                          where T1.IDIST_COMP_CODE = T2.PAY_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.PAY_SEQ_NUM );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_INV_NUM is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_INV_NUM',
                'PAYMENT',
                'Record with'||
		' PAY_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' PAY_SEQ_NUM '||row_dc.IDIST_INV_NUM||
		' does not exist in DA.PAYMENT table.');
    end if;
 end loop;

END IDIST_INV_NUM_3;

--======================================================================
--IDIST_LINE_NUM
--======================================================================
PROCEDURE IDIST_LINE_NUM AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_INVDIST
        where IDIST_LINE_NUM is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_INVDIST',row_dc.dc_rownum,'IDIST_LINE_NUM',
        'IDIST_LINE_NUM',
        'IDIST_LINE_NUM can not be null.');
  end loop;
END IDIST_LINE_NUM;

--======================================================================
--IDIST_BCH_NUM
--======================================================================
PROCEDURE IDIST_BCH_NUM AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_INVDIST
        where IDIST_BCH_NUM is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_INVDIST',row_dc.dc_rownum,'IDIST_BCH_NUM',
        'IDIST_BCH_NUM',
        'IDIST_BCH_NUM can not be null.');
  end loop;
END IDIST_BCH_NUM;

--======================================================================
--IDIST_BCH_NUM_2
--======================================================================
PROCEDURE IDIST_BCH_NUM_2 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_BCH_NUM
	from DA.DC_INVDIST T1
	  where not exists (select '1'
                        from DA.ARBATCH_TABLE  T2
                          where T1.IDIST_BCH_NUM = T2.ARBCH_NUM );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_BCH_NUM is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_BCH_NUM',
                'ARBATCH_TABLE',
                'Record with'||
		' ARBCH_NUM '||to_char(row_dc.IDIST_BCH_NUM)||
		' does not exist in DA.ARBATCH_TABLE table.');
    end if;
 end loop;

END IDIST_BCH_NUM_2;

--======================================================================
--IDIST_BCH_NUM_3
--======================================================================
PROCEDURE IDIST_BCH_NUM_3 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM,
	   IDIST_BCH_NUM
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE='I'
	    and not exists (select '1'
                        from DA.INVOICE  T2
                          where T1.IDIST_COMP_CODE = T2.INV_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.INV_NUM
			    and T1.IDIST_BCH_NUM = T2.INV_BCH_NUM );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_BCH_NUM is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_BCH_NUM',
                'INVOICE',
                'Record with'||
		' INV_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' INV_NUM '||row_dc.IDIST_INV_NUM||
		','||' INV_BCH_NUM '||to_char(row_dc.IDIST_BCH_NUM)||
		' does not exist in DA.INVOICE table.');
    end if;
 end loop;

END IDIST_BCH_NUM_3;

--======================================================================
--IDIST_BCH_NUM_4
--======================================================================
PROCEDURE IDIST_BCH_NUM_4 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM,
	   IDIST_BCH_NUM
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE='C'
	    and not exists (select '1'
                        from DA.PAYMENT  T2
                          where T1.IDIST_COMP_CODE = T2.PAY_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.PAY_SEQ_NUM
			    and T1.IDIST_BCH_NUM = T2.PAY_BCH_NUM );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_BCH_NUM is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_BCH_NUM',
                'PAYMENT',
                'Record with'||
		' PAY_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' PAY_SEQ_NUM '||row_dc.IDIST_INV_NUM||
		','||' PAY_BCH_NUM '||to_char(row_dc.IDIST_BCH_NUM)||
		' does not exist in DA.PAYMENT table.');
    end if;
 end loop;

END IDIST_BCH_NUM_4;

--======================================================================
--TYPE_CODE
--======================================================================
PROCEDURE TYPE_CODE AS
  cursor cur_dc is
    select dc_rownum,
           IDIST_TYPE_CODE
      from DA.DC_INVDIST
        where nvl(IDIST_TYPE_CODE,'xxxx') not in ('G','J');
BEGIN
  for row_dc in cur_dc
  loop

        da.dbk_dc.error('DC_INVDIST',row_dc.dc_rownum,'IDIST_TYPE_CODE',
        'IDIST_TYPE_CODE',
        'IDIST_TYPE_CODE must be set to ''G'',''J''.');

  end loop;
END TYPE_CODE;

--======================================================================
--IDIST_DATE
--======================================================================
PROCEDURE IDIST_DATE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_INVDIST
        where IDIST_DATE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_INVDIST',row_dc.dc_rownum,'IDIST_DATE',
        'IDIST_DATE',
        'IDIST_DATE can not be null.');
  end loop;
END IDIST_DATE;

--======================================================================
--IDIST_DATE_2
--======================================================================
PROCEDURE IDIST_DATE_2 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM,
	   IDIST_DATE
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE = 'I'
	    and not exists (select '1'
                        from DA.INVOICE  T2
                          where T1.IDIST_COMP_CODE = T2.INV_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.INV_NUM
			    and T1.IDIST_DATE = T2.INV_DATE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_DATE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_DATE',
                'INVOICE',
                'Record with'||
		' INV_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' INV_NUM '||row_dc.IDIST_INV_NUM||
		','||' INV_DATE '||to_char(row_dc.IDIST_DATE)||
		' does not exist in DA.INVOICE table.');
    end if;
 end loop;

END IDIST_DATE_2;

--======================================================================
--IDIST_DATE_3
--======================================================================
PROCEDURE IDIST_DATE_3 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM,
	   IDIST_DATE
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE = 'C'
	    and not exists (select '1'
                        from DA.PAYMENT  T2
                          where T1.IDIST_COMP_CODE = T2.PAY_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.PAY_SEQ_NUM
			    and T1.IDIST_DATE = T2.PAY_ACTUAL_DATE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_DATE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_DATE',
                'PAYMENT',
                'Record with'||
		' PAY_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' PAY_SEQ_NUM '||row_dc.IDIST_INV_NUM||
		','||' PAY_ACTUAL_DATE '||to_char(row_dc.IDIST_DATE)||
		' does not exist in DA.PAYMENT table.');
    end if;
 end loop;

END IDIST_DATE_3;

--======================================================================
--IDIST_POST_DATE
--======================================================================
PROCEDURE IDIST_POST_DATE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_INVDIST
        where IDIST_POST_DATE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_INVDIST',row_dc.dc_rownum,'IDIST_POST_DATE',
        'IDIST_POST_DATE',
        'IDIST_POST_DATE can not be null.');
  end loop;
END IDIST_POST_DATE;

--======================================================================
--IDIST_POST_DATE_2
--======================================================================
PROCEDURE IDIST_POST_DATE_2 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM,
	   IDIST_POST_DATE
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE = 'I'
	    and not exists (select '1'
                        from DA.INVOICE  T2
                          where T1.IDIST_COMP_CODE = T2.INV_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.INV_NUM
			    and T1.IDIST_POST_DATE = T2.INV_POST_DATE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_POST_DATE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_POST_DATE',
                'INVOICE',
                'Record with'||
		' INV_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' INV_NUM '||row_dc.IDIST_INV_NUM||
		','||' INV_POST_DATE '||to_char(row_dc.IDIST_POST_DATE)||
		' does not exist in DA.INVOICE table.');
    end if;
 end loop;

END IDIST_POST_DATE_2;

--======================================================================
--IDIST_POST_DATE_3
--======================================================================
PROCEDURE IDIST_POST_DATE_3 AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_INV_NUM,
	   IDIST_POST_DATE
	from DA.DC_INVDIST T1
	  where IDIST_SOURCE_CODE = 'C'
	    and not exists (select '1'
                        from DA.PAYMENT  T2
                          where T1.IDIST_COMP_CODE = T2.PAY_COMP_CODE
			    and T1.IDIST_INV_NUM = T2.PAY_SEQ_NUM
			    and T1.IDIST_POST_DATE = T2.PAY_POST_DATE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_POST_DATE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_POST_DATE',
                'PAYMENT',
                'Record with'||
		' PAY_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' PAY_SEQ_NUM '||row_dc.IDIST_INV_NUM||
		','||' PAY_POST_DATE '||to_char(row_dc.IDIST_POST_DATE)||
		' does not exist in DA.PAYMENT table.');
    end if;
 end loop;

END IDIST_POST_DATE_3;

--======================================================================
--DEPT_CODE_2
--======================================================================
PROCEDURE DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         IDIST_COMP_CODE,
         IDIST_DEPT_CODE
    from DA.DC_INVDIST ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
                row_dc.IDIST_COMP_CODE,
                row_dc.IDIST_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END DEPT_CODE_2;

--======================================================================
--ACC_CODE
--======================================================================
PROCEDURE ACC_CODE AS
 t_result        da.apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         IDIST_COMP_CODE,
         IDIST_DEPT_CODE,
         IDIST_ACC_CODE
   from  DA.DC_INVDIST ;

BEGIN

 for row_dc in cur_acc_code
 loop
    t_result := da.apk_gl_account.chk_by_company_dept(
                        da.apk_util.context(DA.APKC.IS_NOT_NULL,DA.APKC.IS_ON_FILE,DA.APKC.ACCOUNT_ALLOWS_TRANSACTIONS),
                row_dc.IDIST_COMP_CODE,
                row_dc.IDIST_DEPT_CODE,
                row_dc.IDIST_ACC_CODE,
                t_acc_name);
    if ('0' != t_result)
    then
      da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_ACC_CODE',
                'ACC_CODE',
                t_result);
    end if;
 end loop;
END ACC_CODE;

--======================================================================
--IDIST_JOB_CODE
--======================================================================
PROCEDURE IDIST_JOB_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_JOB_CODE
	from DA.DC_INVDIST T1
	  where not exists (select '1'
                        from DA.JCJOBCAT  T2
                          where T1.IDIST_COMP_CODE = T2.JCAT_COMP_CODE
			    and T1.IDIST_JOB_CODE = T2.JCAT_JOB_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_JOB_CODE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_JOB_CODE',
                'JCJOBCAT',
                'Record with'||
		' JCAT_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' JCAT_JOB_CODE '||row_dc.IDIST_JOB_CODE||
		' does not exist in DA.JCJOBCAT table.');
    end if;
 end loop;

END IDIST_JOB_CODE;

--======================================================================
--IDIST_JOB_CTRL_CODE
--======================================================================
PROCEDURE IDIST_JOB_CTRL_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_JOB_CTRL_CODE
	from DA.DC_INVDIST T1
	  where not exists (select '1'
                        from DA.JCJOB_TABLE  T2
                          where T1.IDIST_COMP_CODE = T2.JOB_COMP_CODE
			    and T1.IDIST_JOB_CTRL_CODE = T2.JOB_CTRL_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_JOB_CTRL_CODE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_JOB_CTRL_CODE',
                'JCJOB_TABLE',
                'Record with'||
		' JOB_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' JOB_CTRL_CODE '||row_dc.IDIST_JOB_CTRL_CODE||
		' does not exist in DA.JCJOB_TABLE table.');
    end if;
 end loop;

END IDIST_JOB_CTRL_CODE;

--======================================================================
--IDIST_PHS_CODE
--======================================================================
PROCEDURE IDIST_PHS_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_JOB_CODE,
	   IDIST_PHS_CODE
	from DA.DC_INVDIST T1
	  where not exists (select '1'
                        from DA.JCJOBCAT  T2
                          where T1.IDIST_COMP_CODE = T2.JCAT_COMP_CODE
			    and T1.IDIST_JOB_CODE = T2.JCAT_JOB_CODE
			    and T1.IDIST_PHS_CODE = T2.JCAT_PHS_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_PHS_CODE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_PHS_CODE',
                'JCJOBCAT',
                'Record with'||
		' JCAT_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' JCAT_JOB_CODE '||row_dc.IDIST_JOB_CODE||
		','||' JCAT_PHS_CODE '||row_dc.IDIST_PHS_CODE||
		' does not exist in DA.JCJOBCAT table.');
    end if;
 end loop;

END IDIST_PHS_CODE;

--======================================================================
--IDIST_PHS_CTRL_CODE
--======================================================================
PROCEDURE IDIST_PHS_CTRL_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_JOB_CODE,
	   IDIST_PHS_CTRL_CODE
	from DA.DC_INVDIST T1
	  where not exists (select '1'
                        from DA.JCJOBCAT  T2
                          where T1.IDIST_COMP_CODE = T2.JCAT_COMP_CODE
			    and T1.IDIST_JOB_CODE = T2.JCAT_JOB_CODE
			    and T1.IDIST_PHS_CTRL_CODE = T2.JCAT_PHS_CTRL_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_PHS_CTRL_CODE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_PHS_CTRL_CODE',
                'JCJOBCAT',
                'Record with'||
		' JCAT_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' JCAT_JOB_CODE '||row_dc.IDIST_JOB_CODE||
		','||' JCAT_PHS_CTRL_CODE '||row_dc.IDIST_PHS_CTRL_CODE||
		' does not exist in DA.JCJOBCAT table.');
    end if;
 end loop;

END IDIST_PHS_CTRL_CODE;

--======================================================================
--IDIST_CAT_CODE
--======================================================================
PROCEDURE IDIST_CAT_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_JOB_CODE,
	   IDIST_PHS_CODE,
	   IDIST_CAT_CODE
	from DA.DC_INVDIST T1
	  where not exists (select '1'
                        from DA.JCJOBCAT  T2
                          where T1.IDIST_COMP_CODE = T2.JCAT_COMP_CODE
			    and T1.IDIST_JOB_CODE = T2.JCAT_JOB_CODE
			    and T1.IDIST_PHS_CODE = T2.JCAT_PHS_CODE
			    and T1.IDIST_CAT_CODE = T2.JCAT_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_CAT_CODE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_CAT_CODE',
                'JCJOBCAT',
                'Record with'||
		' JCAT_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' JCAT_JOB_CODE '||row_dc.IDIST_JOB_CODE||
		','||' JCAT_PHS_CODE '||row_dc.IDIST_PHS_CODE||
		','||' JCAT_CODE '||row_dc.IDIST_CAT_CODE||
		' does not exist in DA.JCJOBCAT table.');
    end if;
 end loop;

END IDIST_CAT_CODE;

--======================================================================
--IDIST_CAT_CTRL_CODE
--======================================================================
PROCEDURE IDIST_CAT_CTRL_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   IDIST_COMP_CODE,
	   IDIST_JOB_CODE,
	   IDIST_PHS_CODE,
	   IDIST_CAT_CTRL_CODE
	from DA.DC_INVDIST T1
	  where not exists (select '1'
                        from DA.JCJOBCAT  T2
                          where T1.IDIST_COMP_CODE = T2.JCAT_COMP_CODE
			    and T1.IDIST_JOB_CODE = T2.JCAT_JOB_CODE
			    and T1.IDIST_PHS_CODE = T2.JCAT_PHS_CODE
			    and T1.IDIST_CAT_CTRL_CODE = T2.JCAT_CTRL_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.IDIST_CAT_CTRL_CODE is not null ) then
	 	da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_CAT_CTRL_CODE',
                'JCJOBCAT',
                'Record with'||
		' JCAT_COMP_CODE '||row_dc.IDIST_COMP_CODE||
		','||' JCAT_JOB_CODE '||row_dc.IDIST_JOB_CODE||
		','||' JCAT_PHS_CODE '||row_dc.IDIST_PHS_CODE||
		','||' JCAT_CTRL_CODE '||row_dc.IDIST_CAT_CTRL_CODE||
		' does not exist in DA.JCJOBCAT table.');
    end if;
 end loop;

END IDIST_CAT_CTRL_CODE;

--======================================================================
--IDIST_ACC_COMP_CODE
--======================================================================
PROCEDURE IDIST_ACC_COMP_CODE AS
  cursor cur_IDIST_ACC_COMP_CODE is
    select dc_rownum,
           IDIST_ACC_COMP_CODE
      from DA.DC_INVDIST  ;

 t_result        da.apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 for row_dc in cur_IDIST_ACC_COMP_CODE
 loop
   t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_NOT_NULL,DA.APKC.IS_ON_FILE),
              row_dc.IDIST_ACC_COMP_CODE,t_comp_name);
   if ('0' != t_result) then
         da.dbk_dc.error('DC_INVDIST',
                row_dc.dc_rownum,
                'IDIST_ACC_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   end if;
 end loop;
END IDIST_ACC_COMP_CODE;

--=====================================================================
-- BATCH_SUM
--  Check if the batch has zero distribution in invdist table
--=====================================================================
PROCEDURE batch_sum AS
 cursor cur_batch_sum is
   select idist_bch_num,
          sum(nvl(idist_debit_amt,0) - nvl(idist_credit_amt,0)) "BALANCE"
     from da.dc_invdist
     group by idist_bch_num
     having sum(nvl(idist_debit_amt,0) - nvl(idist_credit_amt,0)) != 0 ;


 cursor cur_idist_l_bch (pc_bch_num IN da.invdist.idist_bch_num%TYPE) is
   select dc_rownum
     from da.dc_invdist
       where idist_bch_num = pc_bch_num;


BEGIN
 for row_batch_sum in cur_batch_sum
 loop
    for row_dc in cur_idist_l_bch(row_batch_sum.idist_bch_num)
    loop
        da.dbk_dc.error('DC_VOUDIST',
                row_dc.dc_rownum,
                'IDIST_AMT',
                'BALANCE',
                'Distribution of batch '||to_char(row_batch_sum.idist_bch_num)
                || ' is out of balance by '||
                to_char(row_batch_sum.balance)||'.');
    end loop;
 end loop;
END Batch_sum;

--======================================================================
--VERIFY_DATA - run all verify procedures define for INVDIST table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
        display_status(' Delete rows DC_INVDIST from DA.DC_ERROR.');
        delete from da.dc_error
          where upper(dcerr_table_name) = 'DC_INVDIST' ;

        commit;

        display_status(' INDEX checking in DA.INVDIST');
        idx_check;

        commit;

        display_status(' INDEX  checking in DA.DC_INVDIST');
        idx_dupl;

        commit;

        display_status(' FOREIGN KEYS checking in DA.DC_INVDIST');
        Fk_con;

        commit;

        display_status(' CHECK constraints checking in DA.DC_INVDIST');
        check_con;

        commit;


        display_status(' IDIST_IDIST_COMP_CODE - checking');
        IDIST_COMP_CODE;

        commit;

        display_status(' IDIST_SOURCE_CODE - checking');
        SOURCE_CODE;

        commit;

        display_status(' IDIST_IDIST_INV_NUM - checking');
        IDIST_INV_NUM;

        commit;

        display_status(' IDIST_INV_NUM_2 - checking');
        IDIST_INV_NUM_2;

        commit;

        display_status(' IDIST_INV_NUM_3 - checking');
        IDIST_INV_NUM_3;

        commit;

        display_status(' IDIST_IDIST_LINE_NUM - checking');
        IDIST_LINE_NUM;

        commit;

        display_status(' IDIST_IDIST_BCH_NUM - checking');
        IDIST_BCH_NUM;

        commit;

        display_status(' IDIST_BCH_NUM_2 - checking');
        IDIST_BCH_NUM_2;

        commit;

        display_status(' IDIST_BCH_NUM_3 - checking');
        IDIST_BCH_NUM_3;

        commit;

        display_status(' IDIST_BCH_NUM_4 - checking');
        IDIST_BCH_NUM_4;

        commit;

        display_status(' IDIST_TYPE_CODE - checking');
        TYPE_CODE;

        commit;

        display_status(' IDIST_IDIST_DATE - checking');
        IDIST_DATE;

        commit;

        display_status(' IDIST_DATE_2 - checking');
        IDIST_DATE_2;

        commit;

        display_status(' IDIST_DATE_3 - checking');
        IDIST_DATE_3;

        commit;

        display_status(' IDIST_IDIST_POST_DATE - checking');
        IDIST_POST_DATE;

        commit;

        display_status(' IDIST_POST_DATE_2 - checking');
        IDIST_POST_DATE_2;

        commit;

        display_status(' IDIST_POST_DATE_3 - checking');
        IDIST_POST_DATE_3;

        commit;

        display_status(' IDIST_DEPT_CODE_2 - checking');
        DEPT_CODE_2;

        commit;

        display_status(' IDIST_ACC_CODE - checking');
        ACC_CODE;

        commit;

        display_status(' IDIST_JOB_CODE - checking');
        IDIST_JOB_CODE;

        commit;

        display_status(' IDIST_JOB_CTRL_CODE - checking');
        IDIST_JOB_CTRL_CODE;

        commit;

        display_status(' IDIST_PHS_CODE - checking');
        IDIST_PHS_CODE;

        commit;

        display_status(' IDIST_PHS_CTRL_CODE - checking');
        IDIST_PHS_CTRL_CODE;

        commit;

        display_status(' IDIST_CAT_CODE - checking');
        IDIST_CAT_CODE;

        commit;

        display_status(' IDIST_CAT_CTRL_CODE - checking');
        IDIST_CAT_CTRL_CODE;

        commit;

        display_status(' IDIST_IDIST_ACC_COMP_CODE - checking');
        IDIST_ACC_COMP_CODE;

        commit;

        display_status(' BATCH_SUM - checking');
        BATCH_SUM;

        commit;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.INVDIST table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_INVDIST table
   cursor cur_err_INVDIST is
     select count(1)
       from da.dc_error
        where upper(dcerr_table_name) = 'DC_INVDIST' ;

   t_n_err_INVDIST         NUMBER;

 cursor cInsert is
   select
	IDIST_COMP_CODE		--1
	,IDIST_SOURCE_CODE		--2
	,IDIST_INV_NUM		--3
	,IDIST_LINE_NUM		--4
	,IDIST_BCH_NUM		--5
	,IDIST_TYPE_CODE		--6
	,IDIST_DATE		--7
	,IDIST_POST_DATE		--8
	,IDIST_ACC_TYPE_CODE		--9
	,IDIST_DEPT_CODE		--10
	,IDIST_ACC_CODE		--11
	,IDIST_AMT		--12
	,IDIST_JOB_CODE		--13
	,IDIST_JOB_CTRL_CODE		--14
	,IDIST_PHS_CODE		--15
	,IDIST_PHS_CTRL_CODE		--16
	,IDIST_CAT_CODE		--17
	,IDIST_CAT_CTRL_CODE		--18
	,IDIST_EQP_CODE		--19
	,IDIST_WBSV_CODE1		--20
	,IDIST_WBSV_CODE2		--21
	,IDIST_WBSV_CODE3		--22
	,IDIST_WBSV_CODE4		--23
	,IDIST_WBSV_CODE5		--24
	,IDIST_WBSV_CODE6		--25
	,IDIST_WBSV_CODE7		--26
	,IDIST_WBSV_CODE8		--27
	,IDIST_WBSV_CODE9		--28
	,IDIST_WBSV_CODE10		--29
	,IDIST_WBSV_CODE11		--30
	,IDIST_WBSV_CODE12		--31
	,IDIST_PM_CODE		--32
	,IDIST_UNIT		--33
	,IDIST_REF_DESC		--34
	,IDIST_ACC_COMP_CODE		--35
	,IDIST_DEBIT_AMT		--36
	,IDIST_CREDIT_AMT		--37
	,IDIST_TAV_CODE1		--38
	,IDIST_TAV_CODE2		--39
	,IDIST_TAV_CODE3		--40
	,IDIST_TAV_CODE4		--41
	,IDIST_CURR_CODE		--42
	,IDIST_CUR_FACTOR_NUM		--43
	,IDIST_COMPON_CODE		--44
	,IDIST_TRANCODE_CODE		--45
	,IDIST_REF_PURPOSE_CODE		--46
   from DA.DC_INVDIST;

BEGIN
 open  cur_err_INVDIST;
 fetch cur_err_INVDIST into t_n_err_INVDIST;
 close cur_err_INVDIST;

 display_status('Number of errors in DC_ERROR table for DC_INVDIST table :'||
                to_char(t_n_err_INVDIST));

 if ( t_n_err_INVDIST = 0 )
 then

   display_status('Insert into DA.INVDIST');

--Insert select section
-- use this statement if speed is the problem and there are no triggers
-- causing mutating problem

/*     insert into DA.INVDIST
        (IDIST_COMP_CODE		--1
	,IDIST_SOURCE_CODE		--2
	,IDIST_INV_NUM		--3
	,IDIST_LINE_NUM		--4
	,IDIST_BCH_NUM		--5
	,IDIST_TYPE_CODE		--6
	,IDIST_DATE		--7
	,IDIST_POST_DATE		--8
	,IDIST_ACC_TYPE_CODE		--9
	,IDIST_DEPT_CODE		--10
	,IDIST_ACC_CODE		--11
	,IDIST_AMT		--12
	,IDIST_JOB_CODE		--13
	,IDIST_JOB_CTRL_CODE		--14
	,IDIST_PHS_CODE		--15
	,IDIST_PHS_CTRL_CODE		--16
	,IDIST_CAT_CODE		--17
	,IDIST_CAT_CTRL_CODE		--18
	,IDIST_EQP_CODE		--19
	,IDIST_WBSV_CODE1		--20
	,IDIST_WBSV_CODE2		--21
	,IDIST_WBSV_CODE3		--22
	,IDIST_WBSV_CODE4		--23
	,IDIST_WBSV_CODE5		--24
	,IDIST_WBSV_CODE6		--25
	,IDIST_WBSV_CODE7		--26
	,IDIST_WBSV_CODE8		--27
	,IDIST_WBSV_CODE9		--28
	,IDIST_WBSV_CODE10		--29
	,IDIST_WBSV_CODE11		--30
	,IDIST_WBSV_CODE12		--31
	,IDIST_PM_CODE		--32
	,IDIST_UNIT		--33
	,IDIST_REF_DESC		--34
	,IDIST_ACC_COMP_CODE		--35
	,IDIST_DEBIT_AMT		--36
	,IDIST_CREDIT_AMT		--37
	,IDIST_TAV_CODE1		--38
	,IDIST_TAV_CODE2		--39
	,IDIST_TAV_CODE3		--40
	,IDIST_TAV_CODE4		--41
	,IDIST_CURR_CODE		--42
	,IDIST_CUR_FACTOR_NUM		--43
	,IDIST_COMPON_CODE		--44
	,IDIST_TRANCODE_CODE		--45
	,IDIST_REF_PURPOSE_CODE		--46
) select
	IDIST_COMP_CODE		--1
	,IDIST_SOURCE_CODE		--2
	,IDIST_INV_NUM		--3
	,IDIST_LINE_NUM		--4
	,IDIST_BCH_NUM		--5
	,IDIST_TYPE_CODE		--6
	,IDIST_DATE		--7
	,IDIST_POST_DATE		--8
	,IDIST_ACC_TYPE_CODE		--9
	,IDIST_DEPT_CODE		--10
	,IDIST_ACC_CODE		--11
	,IDIST_AMT		--12
	,IDIST_JOB_CODE		--13
	,IDIST_JOB_CTRL_CODE		--14
	,IDIST_PHS_CODE		--15
	,IDIST_PHS_CTRL_CODE		--16
	,IDIST_CAT_CODE		--17
	,IDIST_CAT_CTRL_CODE		--18
	,IDIST_EQP_CODE		--19
	,IDIST_WBSV_CODE1		--20
	,IDIST_WBSV_CODE2		--21
	,IDIST_WBSV_CODE3		--22
	,IDIST_WBSV_CODE4		--23
	,IDIST_WBSV_CODE5		--24
	,IDIST_WBSV_CODE6		--25
	,IDIST_WBSV_CODE7		--26
	,IDIST_WBSV_CODE8		--27
	,IDIST_WBSV_CODE9		--28
	,IDIST_WBSV_CODE10		--29
	,IDIST_WBSV_CODE11		--30
	,IDIST_WBSV_CODE12		--31
	,IDIST_PM_CODE		--32
	,IDIST_UNIT		--33
	,IDIST_REF_DESC		--34
	,IDIST_ACC_COMP_CODE		--35
	,IDIST_DEBIT_AMT		--36
	,IDIST_CREDIT_AMT		--37
	,IDIST_TAV_CODE1		--38
	,IDIST_TAV_CODE2		--39
	,IDIST_TAV_CODE3		--40
	,IDIST_TAV_CODE4		--41
	,IDIST_CURR_CODE		--42
	,IDIST_CUR_FACTOR_NUM		--43
	,IDIST_COMPON_CODE		--44
	,IDIST_TRANCODE_CODE		--45
	,IDIST_REF_PURPOSE_CODE		--46
   from DA.DC_INVDIST;
*/
--End of insert select section

--insert loop
   for row_dc in cInsert
   loop
     insert into DA.INVDIST
        (IDIST_COMP_CODE		--1
	,IDIST_SOURCE_CODE		--2
	,IDIST_INV_NUM		--3
	,IDIST_LINE_NUM		--4
	,IDIST_BCH_NUM		--5
	,IDIST_TYPE_CODE		--6
	,IDIST_DATE		--7
	,IDIST_POST_DATE		--8
	,IDIST_ACC_TYPE_CODE		--9
	,IDIST_DEPT_CODE		--10
	,IDIST_ACC_CODE		--11
	,IDIST_AMT		--12
	,IDIST_JOB_CODE		--13
	,IDIST_JOB_CTRL_CODE		--14
	,IDIST_PHS_CODE		--15
	,IDIST_PHS_CTRL_CODE		--16
	,IDIST_CAT_CODE		--17
	,IDIST_CAT_CTRL_CODE		--18
	,IDIST_EQP_CODE		--19
	,IDIST_WBSV_CODE1		--20
	,IDIST_WBSV_CODE2		--21
	,IDIST_WBSV_CODE3		--22
	,IDIST_WBSV_CODE4		--23
	,IDIST_WBSV_CODE5		--24
	,IDIST_WBSV_CODE6		--25
	,IDIST_WBSV_CODE7		--26
	,IDIST_WBSV_CODE8		--27
	,IDIST_WBSV_CODE9		--28
	,IDIST_WBSV_CODE10		--29
	,IDIST_WBSV_CODE11		--30
	,IDIST_WBSV_CODE12		--31
	,IDIST_PM_CODE		--32
	,IDIST_UNIT		--33
	,IDIST_REF_DESC		--34
	,IDIST_ACC_COMP_CODE		--35
	,IDIST_DEBIT_AMT		--36
	,IDIST_CREDIT_AMT		--37
	,IDIST_TAV_CODE1		--38
	,IDIST_TAV_CODE2		--39
	,IDIST_TAV_CODE3		--40
	,IDIST_TAV_CODE4		--41
	,IDIST_CURR_CODE		--42
	,IDIST_CUR_FACTOR_NUM		--43
	,IDIST_COMPON_CODE		--44
	,IDIST_TRANCODE_CODE		--45
	,IDIST_REF_PURPOSE_CODE		--46
     )values
	(row_dc.IDIST_COMP_CODE		--1
	,row_dc.IDIST_SOURCE_CODE		--2
	,row_dc.IDIST_INV_NUM		--3
	,row_dc.IDIST_LINE_NUM		--4
	,row_dc.IDIST_BCH_NUM		--5
	,row_dc.IDIST_TYPE_CODE		--6
	,row_dc.IDIST_DATE		--7
	,row_dc.IDIST_POST_DATE		--8
	,row_dc.IDIST_ACC_TYPE_CODE		--9
	,row_dc.IDIST_DEPT_CODE		--10
	,row_dc.IDIST_ACC_CODE		--11
	,row_dc.IDIST_AMT		--12
	,row_dc.IDIST_JOB_CODE		--13
	,row_dc.IDIST_JOB_CTRL_CODE		--14
	,row_dc.IDIST_PHS_CODE		--15
	,row_dc.IDIST_PHS_CTRL_CODE		--16
	,row_dc.IDIST_CAT_CODE		--17
	,row_dc.IDIST_CAT_CTRL_CODE		--18
	,row_dc.IDIST_EQP_CODE		--19
	,row_dc.IDIST_WBSV_CODE1		--20
	,row_dc.IDIST_WBSV_CODE2		--21
	,row_dc.IDIST_WBSV_CODE3		--22
	,row_dc.IDIST_WBSV_CODE4		--23
	,row_dc.IDIST_WBSV_CODE5		--24
	,row_dc.IDIST_WBSV_CODE6		--25
	,row_dc.IDIST_WBSV_CODE7		--26
	,row_dc.IDIST_WBSV_CODE8		--27
	,row_dc.IDIST_WBSV_CODE9		--28
	,row_dc.IDIST_WBSV_CODE10		--29
	,row_dc.IDIST_WBSV_CODE11		--30
	,row_dc.IDIST_WBSV_CODE12		--31
	,row_dc.IDIST_PM_CODE		--32
	,row_dc.IDIST_UNIT		--33
	,row_dc.IDIST_REF_DESC		--34
	,row_dc.IDIST_ACC_COMP_CODE		--35
	,row_dc.IDIST_DEBIT_AMT		--36
	,row_dc.IDIST_CREDIT_AMT		--37
	,row_dc.IDIST_TAV_CODE1		--38
	,row_dc.IDIST_TAV_CODE2		--39
	,row_dc.IDIST_TAV_CODE3		--40
	,row_dc.IDIST_TAV_CODE4		--41
	,row_dc.IDIST_CURR_CODE		--42
	,row_dc.IDIST_CUR_FACTOR_NUM		--43
	,row_dc.IDIST_COMPON_CODE		--44
	,row_dc.IDIST_TRANCODE_CODE		--45
	,row_dc.IDIST_REF_PURPOSE_CODE		--46
     );
   end loop;
--end of loop insert


  --delete everything from DA.DC_INVDIST
    display_status('Delete rows from DA.DC_INVDIST table.');
    delete from DA.DC_INVDIST;
    display_status('Number of records deleted from DA.DC_INVDIST table:'||to_char(SQL%rowcount));

     display_status('INVDIST moving from temp table was successful.');
--     commit;

 end if; /*    if nvl(t_n_err_INVDIST,0) = 0 */

exception when others
     then
       display_status('Can not move data from DA.DC_INVDIST into DA.INVDIST.');
       da.dbk_dc.output(SQLERRM);
       rollback;
       raise;

END Process_temp_data ;

END CC_DBK_DC_INVDIST;
/
