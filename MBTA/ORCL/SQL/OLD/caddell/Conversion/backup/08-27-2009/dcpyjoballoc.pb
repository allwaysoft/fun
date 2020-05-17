--Wed Aug 26 16:05:34 2009
PROMPT =======================================
PROMPT   Create DBK_DC_PYJOBALLOC package body
PROMPT =======================================

CREATE OR REPLACE PACKAGE BODY DA.DBK_DC_PYJOBALLOC AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.dbk_dc.display_status('DC_PYJOBALLOC',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS
--PYJOBALLOC_JCCAT_FK

cursor cPYJOBALLOC_JCCAT_FK is
  select dc_rownum,
	 PYJA_COMP_CODE,
	 PYJA_CAT_CODE
	from DA.DC_PYJOBALLOC  T1
	where not exists
           (select '1'
              from DA.JCCAT T2
                where nvl(T1.PYJA_COMP_CODE,T2.CAT_COMP_CODE) = T2.CAT_COMP_CODE
		  and nvl(T1.PYJA_CAT_CODE,T2.CAT_CODE) = T2.CAT_CODE );

BEGIN
null;
--PYJOBALLOC_JCCAT_FK
 for row_dc in cPYJOBALLOC_JCCAT_FK
 loop
  if ( row_dc.PYJA_COMP_CODE is not null 
	 and  row_dc.PYJA_CAT_CODE is not null  ) then
	 da.dbk_dc.error('DC_PYJOBALLOC',
                                 row_dc.dc_rownum,
                                 'PYJOBALLOC_JCCAT_FK',
                                 'JCCAT',
                'Record with '|| ' CAT_COMP_CODE '||row_dc.PYJA_COMP_CODE||
		','||' CAT_CODE '||row_dc.PYJA_CAT_CODE||
		' does not exist in DA.JCCAT table.');
 end if;
end loop;

END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--SYS_C0067188 - "PYJA_COMP_CODE" IS NOT NULL
 cursor cur_SYS_C0067188 is
        select dc_rownum
          from DA.DC_PYJOBALLOC
            where not "PYJA_COMP_CODE" IS NOT NULL ;

--PYJA_TYPE_CODE_CHK_BNDETXWCPL - pyja_type_code IN ('BN', 'DE', 'TX','WC','PL')
 cursor cur_PYJA_TYPE_CODE_CHK_BNDETXW is
        select dc_rownum
          from DA.DC_PYJOBALLOC
            where not pyja_type_code IN ('BN', 'DE', 'TX','WC','PL') ;

--SYS_C0067189 - "PYJA_JOB_CODE" IS NOT NULL
 cursor cur_SYS_C0067189 is
        select dc_rownum
          from DA.DC_PYJOBALLOC
            where not "PYJA_JOB_CODE" IS NOT NULL ;

--SYS_C0067190 - "PYJA_TYPE_CODE" IS NOT NULL
 cursor cur_SYS_C0067190 is
        select dc_rownum
          from DA.DC_PYJOBALLOC
            where not "PYJA_TYPE_CODE" IS NOT NULL ;

--SYS_C0067191 - "PYJA_CODE" IS NOT NULL
 cursor cur_SYS_C0067191 is
        select dc_rownum
          from DA.DC_PYJOBALLOC
            where not "PYJA_CODE" IS NOT NULL ;

--SYS_C0067192 - "PYJA_CAT_CODE" IS NOT NULL
 cursor cur_SYS_C0067192 is
        select dc_rownum
          from DA.DC_PYJOBALLOC
            where not "PYJA_CAT_CODE" IS NOT NULL ;

BEGIN
null;

 for row_dc in cur_SYS_C0067188
 loop
    da.dbk_dc.error('DC_PYJOBALLOC',
                    row_dc.dc_rownum,
                    'SYS_C0067188',
                    'SYS_C0067188',
                    'Condition "PYJA_COMP_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_PYJA_TYPE_CODE_CHK_BNDETXW
 loop
    da.dbk_dc.error('DC_PYJOBALLOC',
                    row_dc.dc_rownum,
                    'PYJA_TYPE_CODE_CHK_BNDETXWCPL',
                    'PYJA_TYPE_CODE_CHK_BNDETXWCPL',
                    'Condition pyja_type_code IN (''BN'', ''DE'', ''TX'',''WC'',''PL'') failed.');
 end loop;

 for row_dc in cur_SYS_C0067189
 loop
    da.dbk_dc.error('DC_PYJOBALLOC',
                    row_dc.dc_rownum,
                    'SYS_C0067189',
                    'SYS_C0067189',
                    'Condition "PYJA_JOB_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0067190
 loop
    da.dbk_dc.error('DC_PYJOBALLOC',
                    row_dc.dc_rownum,
                    'SYS_C0067190',
                    'SYS_C0067190',
                    'Condition "PYJA_TYPE_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0067191
 loop
    da.dbk_dc.error('DC_PYJOBALLOC',
                    row_dc.dc_rownum,
                    'SYS_C0067191',
                    'SYS_C0067191',
                    'Condition "PYJA_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0067192
 loop
    da.dbk_dc.error('DC_PYJOBALLOC',
                    row_dc.dc_rownum,
                    'SYS_C0067192',
                    'SYS_C0067192',
                    'Condition "PYJA_CAT_CODE" IS NOT NULL failed.');
 end loop;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.PYJOBALLOC table
--======================================================================
PROCEDURE IDX_CHECK AS

--PYJOBALLOC_PK
cursor cur_PYJOBALLOC_PK is
  select dc_rownum,
	 PYJA_COMP_CODE,
	 PYJA_JOB_CODE,
	 PYJA_TYPE_CODE,
	 PYJA_CODE
    from DA.DC_PYJOBALLOC S1
      where exists (select '1'
                      from DA.PYJOBALLOC S2
                        where S1.PYJA_COMP_CODE = S2.PYJA_COMP_CODE
			  and S1.PYJA_JOB_CODE = S2.PYJA_JOB_CODE
			  and S1.PYJA_TYPE_CODE = S2.PYJA_TYPE_CODE
			  and S1.PYJA_CODE = S2.PYJA_CODE );
BEGIN
 null; 

--PYJOBALLOC_PK
 for row_dc in cur_PYJOBALLOC_PK
 loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,
                'PYJOBALLOC_PK',
                'PYJOBALLOC_PK',
                'Record with '||'PYJA_COMP_CODE '||row_dc.PYJA_COMP_CODE ||
		', '||'PYJA_JOB_CODE '||row_dc.PYJA_JOB_CODE ||
		', '||'PYJA_TYPE_CODE '||row_dc.PYJA_TYPE_CODE ||
		', '||'PYJA_CODE '||row_dc.PYJA_CODE ||
		' already exists in DA.PYJOBALLOC table.');

 end loop;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_PYJOBALLOC table
--======================================================================
PROCEDURE IDX_DUPL AS

--PYJOBALLOC_PK
cursor cur_PYJOBALLOC_PK is
  select dc_rownum,
	 PYJA_COMP_CODE,
	 PYJA_JOB_CODE,
	 PYJA_TYPE_CODE,
	 PYJA_CODE
    from DA.DC_PYJOBALLOC S1
      where
        exists (select '1'
                  from DA.DC_PYJOBALLOC S2
                    where S1.PYJA_COMP_CODE = S2.PYJA_COMP_CODE
		      and S1.PYJA_JOB_CODE = S2.PYJA_JOB_CODE
		      and S1.PYJA_TYPE_CODE = S2.PYJA_TYPE_CODE
		      and S1.PYJA_CODE = S2.PYJA_CODE
		      and S1.rowid != S2.rowid );
BEGIN
 null; 

--PYJOBALLOC_PK
 for row_dc in cur_PYJOBALLOC_PK
 loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,
                'PYJOBALLOC_PK',
                'PYJOBALLOC_PK',
                'Record with '||'PYJA_COMP_CODE '||row_dc.PYJA_COMP_CODE ||
		', '||'PYJA_JOB_CODE '||row_dc.PYJA_JOB_CODE ||
		', '||'PYJA_TYPE_CODE '||row_dc.PYJA_TYPE_CODE ||
		', '||'PYJA_CODE '||row_dc.PYJA_CODE ||
		' already exists in DA.DC_PYJOBALLOC table.');
end loop;
END IDX_DUPL;

--======================================================================
--PYJA_COMP_CODE
--======================================================================
PROCEDURE PYJA_COMP_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_COMP_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_COMP_CODE',
        'PYJA_COMP_CODE',
        'PYJA_COMP_CODE can not be null.');
  end loop;
END PYJA_COMP_CODE;

--======================================================================
--PYJA_COMP_CODE_2
--======================================================================
PROCEDURE PYJA_COMP_CODE_2 AS
  cursor cur_PYJA_COMP_CODE is
    select dc_rownum,
           PYJA_COMP_CODE
      from DA.DC_PYJOBALLOC  ;

 t_result        da.apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 for row_dc in cur_PYJA_COMP_CODE
 loop
   t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
              row_dc.PYJA_COMP_CODE,t_comp_name);
   if ('0' != t_result) then
         da.dbk_dc.error('DC_PYJOBALLOC',
                row_dc.dc_rownum,
                'PYJA_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   end if;
 end loop;
END PYJA_COMP_CODE_2;

--======================================================================
--PYJA_JOB_CODE
--======================================================================
PROCEDURE PYJA_JOB_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_JOB_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_JOB_CODE',
        'PYJA_JOB_CODE',
        'PYJA_JOB_CODE can not be null.');
  end loop;
END PYJA_JOB_CODE;

--======================================================================
--PYJA_JOB_CODE_2
--======================================================================
PROCEDURE PYJA_JOB_CODE_2 AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_JOB_CODE NOT IN (select 'ALL' from dual union all select 'ALLBID' from dual union all select job_code from da.jcjob_table where job_comp_code = PYJA_COMP_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_JOB_CODE',
        'PYJA_JOB_CODE',
        'Not a valid PYJA_JOB_CODE value');
  end loop;
END PYJA_JOB_CODE_2;

--======================================================================
--PYJA_TYPE_CODE
--======================================================================
PROCEDURE PYJA_TYPE_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_TYPE_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_TYPE_CODE',
        'PYJA_TYPE_CODE',
        'PYJA_TYPE_CODE can not be null.');
  end loop;
END PYJA_TYPE_CODE;

--======================================================================
--TYPE_CODE
--======================================================================
PROCEDURE TYPE_CODE AS
  cursor cur_dc is
    select dc_rownum,
           PYJA_TYPE_CODE
      from DA.DC_PYJOBALLOC
        where nvl(PYJA_TYPE_CODE,'xxxx') not in ('BN','TX','DE','WC','PL');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_TYPE_CODE',
        'PYJA_TYPE_CODE',
        'PYJA_TYPE_CODE must be set to ''BN'',''TX'',''DE'',''WC'',''PL''.');

  end loop;
END TYPE_CODE;

--======================================================================
--PYJA_CODE
--======================================================================
PROCEDURE PYJA_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_CODE',
        'PYJA_CODE',
        'PYJA_CODE can not be null.');
  end loop;
END PYJA_CODE;

--======================================================================
--PYJA_CODE_2
--======================================================================
PROCEDURE PYJA_CODE_2 AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_CODE NOT IN (select 'ALL' from dual union select ben_code from da.pybenefit where ben_job_allocation = 'Y' and PYJA_TYPE_CODE = 'BN' union select ded_code from da.pydeduction where ded_job_allocation = 'Y' and ded_emplr_contr = 'Y' and PYJA_TYPE_CODE = 'DE' union select tax_code from da.pytax where tax_job_allocation = 'Y' and PYJA_TYPE_CODE = 'TX' union select wcc_wcb_code from da.pywcbcode where wcc_job_allocation = 'Y' and PYJA_TYPE_CODE = 'WC' union select plc_code from da.pyplcode where plc_job_allocation = 'Y' and PYJA_TYPE_CODE = 'PL');
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_CODE',
        'PYJA_CODE',
        'Not a valid PYJA_CODE value');
  end loop;
END PYJA_CODE_2;

--======================================================================
--PYJA_CAT_CODE
--======================================================================
PROCEDURE PYJA_CAT_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_CAT_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_CAT_CODE',
        'PYJA_CAT_CODE',
        'PYJA_CAT_CODE can not be null.');
  end loop;
END PYJA_CAT_CODE;

--======================================================================
--PYJA_CAT_CODE_2
--======================================================================
PROCEDURE PYJA_CAT_CODE_2 AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_CAT_CODE NOT IN (select cat_code from da.jccat where cat_comp_code = PYJA_COMP_CODE and nvl(cat_active_flag, 'Y') = 'Y');
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_CAT_CODE',
        'PYJA_CAT_CODE',
        'Not a valid PYJA_CAT_CODE value');
  end loop;
END PYJA_CAT_CODE_2;

--======================================================================
--PYJA_PHS_CODE
--======================================================================
PROCEDURE PYJA_PHS_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_PYJOBALLOC
        where PYJA_PHS_CODE IS NOT NULL AND PYJA_PHS_CODE NOT IN (select jcat_phs_code from da.jcjobcat where jcat_comp_code = PYJA_COMP_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_PYJOBALLOC',row_dc.dc_rownum,'PYJA_PHS_CODE',
        'PYJA_PHS_CODE',
        'Not a valid PYJA_PHS_CODE value');
  end loop;
END PYJA_PHS_CODE;

--======================================================================
--VERIFY_DATA - run all verify procedures define for PYJOBALLOC table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
        display_status(' Delete rows DC_PYJOBALLOC from DA.DC_ERROR.');
        delete from da.dc_error
          where upper(dcerr_table_name) = 'DC_PYJOBALLOC' ;

        commit;

        display_status(' INDEX checking in DA.PYJOBALLOC');
        idx_check;

        commit;

        display_status(' INDEX  checking in DA.DC_PYJOBALLOC');
        idx_dupl;

        commit;

        display_status(' FOREIGN KEYS checking in DA.DC_PYJOBALLOC');
        Fk_con;

        commit;

        display_status(' CHECK constraints checking in DA.DC_PYJOBALLOC');
        check_con;

        commit;


        display_status(' PYJA_PYJA_COMP_CODE - checking');
        PYJA_COMP_CODE;

        commit;

        display_status(' PYJA_PYJA_COMP_CODE_2 - checking');
        PYJA_COMP_CODE_2;

        commit;

        display_status(' PYJA_PYJA_JOB_CODE - checking');
        PYJA_JOB_CODE;

        commit;

        display_status(' PYJA_PYJA_JOB_CODE_2 - checking');
        PYJA_JOB_CODE_2;

        commit;

        display_status(' PYJA_PYJA_TYPE_CODE - checking');
        PYJA_TYPE_CODE;

        commit;

        display_status(' PYJA_TYPE_CODE - checking');
        TYPE_CODE;

        commit;

        display_status(' PYJA_PYJA_CODE - checking');
        PYJA_CODE;

        commit;

        display_status(' PYJA_PYJA_CODE_2 - checking');
        PYJA_CODE_2;

        commit;

        display_status(' PYJA_PYJA_CAT_CODE - checking');
        PYJA_CAT_CODE;

        commit;

        display_status(' PYJA_PYJA_CAT_CODE_2 - checking');
        PYJA_CAT_CODE_2;

        commit;

        display_status(' PYJA_PYJA_PHS_CODE - checking');
        PYJA_PHS_CODE;

        commit;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.PYJOBALLOC table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_PYJOBALLOC table
   cursor cur_err_PYJOBALLOC is
     select count(1)
       from da.dc_error
        where upper(dcerr_table_name) = 'DC_PYJOBALLOC' ;

   t_n_err_PYJOBALLOC         NUMBER;

 cursor cInsert is 
   select
	PYJA_COMP_CODE		--1
	,PYJA_JOB_CODE		--2
	,PYJA_TYPE_CODE		--3
	,PYJA_CODE		--4
	,PYJA_CAT_CODE		--5
   from DA.DC_PYJOBALLOC;

BEGIN
 open  cur_err_PYJOBALLOC;
 fetch cur_err_PYJOBALLOC into t_n_err_PYJOBALLOC;
 close cur_err_PYJOBALLOC;

 display_status('Number of errors in DC_ERROR table for DC_PYJOBALLOC table :'||
                to_char(t_n_err_PYJOBALLOC));

 if ( t_n_err_PYJOBALLOC = 0 )
 then

   display_status('Insert into DA.PYJOBALLOC');

--Insert select section 
-- use this statement if speed is the problem and there are no triggers
-- causing mutating problem

/*     insert into DA.PYJOBALLOC
        (PYJA_COMP_CODE		--1
	,PYJA_JOB_CODE		--2
	,PYJA_TYPE_CODE		--3
	,PYJA_CODE		--4
	,PYJA_CAT_CODE		--5
) select
	PYJA_COMP_CODE		--1
	,PYJA_JOB_CODE		--2
	,PYJA_TYPE_CODE		--3
	,PYJA_CODE		--4
	,PYJA_CAT_CODE		--5
   from DA.DC_PYJOBALLOC;
*/
--End of insert select section

--insert loop
   for row_dc in cInsert
   loop
     insert into DA.PYJOBALLOC
        (PYJA_COMP_CODE		--1
	,PYJA_JOB_CODE		--2
	,PYJA_TYPE_CODE		--3
	,PYJA_CODE		--4
	,PYJA_CAT_CODE		--5
     )values
	(row_dc.PYJA_COMP_CODE		--1
	,row_dc.PYJA_JOB_CODE		--2
	,row_dc.PYJA_TYPE_CODE		--3
	,row_dc.PYJA_CODE		--4
	,row_dc.PYJA_CAT_CODE		--5
     );
   end loop;
--end of loop insert


  --delete everything from DA.DC_PYJOBALLOC
    display_status('Delete rows from DA.DC_PYJOBALLOC table.');
    delete from DA.DC_PYJOBALLOC;
    display_status('Number of records deleted from DA.DC_PYJOBALLOC table:'||to_char(SQL%rowcount));

     display_status('PYJOBALLOC moving from temp table was successful.');
--     commit;

 end if; /*    if nvl(t_n_err_PYJOBALLOC,0) = 0 */

exception when others
     then
       display_status('Can not move data from DA.DC_PYJOBALLOC into DA.PYJOBALLOC.');
       da.dbk_dc.output(SQLERRM);
       rollback;
       raise;

END Process_temp_data ;

END DBK_DC_PYJOBALLOC;
/
show error
/
