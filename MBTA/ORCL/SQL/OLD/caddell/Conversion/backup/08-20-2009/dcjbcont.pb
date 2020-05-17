--Mon Aug 17 14:14:01 2009
PROMPT =======================================
PROMPT   Create DBK_DC_JBCONT package body
PROMPT =======================================

CREATE OR REPLACE PACKAGE BODY DA.DBK_DC_JBCONT AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.dbk_dc.display_status('DC_JBCONT',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS
--JBCONT_JCJOB_FK

cursor cJBCONT_JCJOB_FK is
  select dc_rownum,
	 JBC_COMP_CODE,
	 JBC_JOB_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.JCJOB_TABLE T2
                where nvl(T1.JBC_COMP_CODE,T2.JOB_COMP_CODE) = T2.JOB_COMP_CODE
		  and nvl(T1.JBC_JOB_CODE,T2.JOB_CODE) = T2.JOB_CODE );
--JBCONT_BACURRENCY_FK

cursor cJBCONT_BACURRENCY_FK is
  select dc_rownum,
	 JBC_CURR_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.BACURRENCY T2
                where nvl(T1.JBC_CURR_CODE,T2.BACURR_CODE) = T2.BACURR_CODE );
--JBCONT_REGION_FK

cursor cJBCONT_REGION_FK is
  select dc_rownum,
	 JBC_REGION_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.REGION T2
                where nvl(T1.JBC_REGION_CODE,T2.REG_CODE) = T2.REG_CODE );
--JBCONT_ARTAX_FK1

cursor cJBCONT_ARTAX_FK1 is
  select dc_rownum,
	 JBC_COMP_CODE,
	 JBC_TAX1_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JBC_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JBC_TAX1_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );
--JBCONT_ARTAX_FK2

cursor cJBCONT_ARTAX_FK2 is
  select dc_rownum,
	 JBC_COMP_CODE,
	 JBC_TAX2_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JBC_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JBC_TAX2_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );
--JBCONT_ARTAX_FK3

cursor cJBCONT_ARTAX_FK3 is
  select dc_rownum,
	 JBC_COMP_CODE,
	 JBC_TAX3_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JBC_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JBC_TAX3_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );
--JBCONT_DEPT_FK

cursor cJBCONT_DEPT_FK is
  select dc_rownum,
	 JBC_COMP_CODE,
	 JBC_DEPT_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.DEPT_TABLE T2
                where nvl(T1.JBC_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  and nvl(T1.JBC_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );
--JBCONT_COMPANY_FK

cursor cJBCONT_COMPANY_FK is
  select dc_rownum,
	 JBC_COMP_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.COMPANY T2
                where nvl(T1.JBC_COMP_CODE,T2.COMP_CODE) = T2.COMP_CODE );
--JBC_RULE_FK

cursor cJBC_RULE_FK is
  select dc_rownum,
	 JBC_RULE_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.JCSPREAD_RULE T2
                where nvl(T1.JBC_RULE_CODE,T2.JCSR_RULE_CODE) = T2.JCSR_RULE_CODE );
--JBCONT_JBPYTRADE_XREF_CODE_FK

cursor cJBCONT_JBPYTRADE_XREF_CODE_FK is
  select dc_rownum,
	 JBC_JBPYTRADE_XREF_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.JB_PY_XREF_TRADE_CODE T2
                where nvl(T1.JBC_JBPYTRADE_XREF_CODE,T2.JBPYXTC_JBPYTRADE_XREF_CODE) = T2.JBPYXTC_JBPYTRADE_XREF_CODE );
--JBCONT_BPCUSTOMERS_FK

cursor cJBCONT_BPCUSTOMERS_FK is
  select dc_rownum,
	 JBC_CUST_CODE,
	 JBC_COMP_CODE
	from DA.DC_JBCONT  T1
	where not exists
           (select '1'
              from DA.BPCUSTOMERS T2
                where nvl(T1.JBC_CUST_CODE,T2.BPCUST_BP_CODE) = T2.BPCUST_BP_CODE
		  and nvl(T1.JBC_COMP_CODE,T2.BPCUST_COMP_CODE) = T2.BPCUST_COMP_CODE );

BEGIN
null;
--JBCONT_JCJOB_FK
 for row_dc in cJBCONT_JCJOB_FK
 loop
  if ( row_dc.JBC_COMP_CODE is not null 
	 and  row_dc.JBC_JOB_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_JCJOB_FK',
                                 'JCJOB_TABLE',
                'Record with '|| ' JOB_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' JOB_CODE '||row_dc.JBC_JOB_CODE||
		' does not exist in DA.JCJOB_TABLE table.');
 end if;
end loop;
--JBCONT_BACURRENCY_FK
 for row_dc in cJBCONT_BACURRENCY_FK
 loop
  if ( row_dc.JBC_CURR_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_BACURRENCY_FK',
                                 'BACURRENCY',
                'Record with '|| ' BACURR_CODE '||row_dc.JBC_CURR_CODE||
		' does not exist in DA.BACURRENCY table.');
 end if;
end loop;
--JBCONT_REGION_FK
 for row_dc in cJBCONT_REGION_FK
 loop
  if ( row_dc.JBC_REGION_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_REGION_FK',
                                 'REGION',
                'Record with '|| ' REG_CODE '||row_dc.JBC_REGION_CODE||
		' does not exist in DA.REGION table.');
 end if;
end loop;
--JBCONT_ARTAX_FK1
 for row_dc in cJBCONT_ARTAX_FK1
 loop
  if ( row_dc.JBC_COMP_CODE is not null 
	 and  row_dc.JBC_TAX1_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_ARTAX_FK1',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JBC_TAX1_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JBCONT_ARTAX_FK2
 for row_dc in cJBCONT_ARTAX_FK2
 loop
  if ( row_dc.JBC_COMP_CODE is not null 
	 and  row_dc.JBC_TAX2_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_ARTAX_FK2',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JBC_TAX2_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JBCONT_ARTAX_FK3
 for row_dc in cJBCONT_ARTAX_FK3
 loop
  if ( row_dc.JBC_COMP_CODE is not null 
	 and  row_dc.JBC_TAX3_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_ARTAX_FK3',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JBC_TAX3_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JBCONT_DEPT_FK
 for row_dc in cJBCONT_DEPT_FK
 loop
  if ( row_dc.JBC_COMP_CODE is not null 
	 and  row_dc.JBC_DEPT_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_DEPT_FK',
                                 'DEPT_TABLE',
                'Record with '|| ' DEPT_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' DEPT_CODE '||row_dc.JBC_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 end if;
end loop;
--JBCONT_COMPANY_FK
 for row_dc in cJBCONT_COMPANY_FK
 loop
  if ( row_dc.JBC_COMP_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_COMPANY_FK',
                                 'COMPANY',
                'Record with '|| ' COMP_CODE '||row_dc.JBC_COMP_CODE||
		' does not exist in DA.COMPANY table.');
 end if;
end loop;
--JBC_RULE_FK
 for row_dc in cJBC_RULE_FK
 loop
  if ( row_dc.JBC_RULE_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBC_RULE_FK',
                                 'JCSPREAD_RULE',
                'Record with '|| ' JCSR_RULE_CODE '||row_dc.JBC_RULE_CODE||
		' does not exist in DA.JCSPREAD_RULE table.');
 end if;
end loop;
--JBCONT_JBPYTRADE_XREF_CODE_FK
 for row_dc in cJBCONT_JBPYTRADE_XREF_CODE_FK
 loop
  if ( row_dc.JBC_JBPYTRADE_XREF_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_JBPYTRADE_XREF_CODE_FK',
                                 'JB_PY_XREF_TRADE_CODE',
                'Record with '|| ' JBPYXTC_JBPYTRADE_XREF_CODE '||row_dc.JBC_JBPYTRADE_XREF_CODE||
		' does not exist in DA.JB_PY_XREF_TRADE_CODE table.');
 end if;
end loop;
--JBCONT_BPCUSTOMERS_FK
 for row_dc in cJBCONT_BPCUSTOMERS_FK
 loop
  if ( row_dc.JBC_CUST_CODE is not null 
	 and  row_dc.JBC_COMP_CODE is not null  ) then
	 da.dbk_dc.error('DC_JBCONT',
                                 row_dc.dc_rownum,
                                 'JBCONT_BPCUSTOMERS_FK',
                                 'BPCUSTOMERS',
                'Record with '|| ' BPCUST_BP_CODE '||row_dc.JBC_CUST_CODE||
		','||' BPCUST_COMP_CODE '||row_dc.JBC_COMP_CODE||
		' does not exist in DA.BPCUSTOMERS table.');
 end if;
end loop;

END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--SYS_C0063900 - "JBC_EXCL_NONINV_RECEIPTS" IS NOT NULL
 cursor cur_SYS_C0063900 is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_EXCL_NONINV_RECEIPTS" IS NOT NULL ;

--JBC_EXCL_NONINV_RECEIPTS - JBC_EXCL_NONINV_RECEIPTS in ('Y','N')
 cursor cur_JBC_EXCL_NONINV_RECEIPTS is
        select dc_rownum
          from DA.DC_JBCONT
            where not JBC_EXCL_NONINV_RECEIPTS in ('Y','N') ;

--JBC_SC_RFP_COST_FLAG_YN - JBC_SC_RFP_COST_FLAG in ('Y', 'N')
 cursor cur_JBC_SC_RFP_COST_FLAG_YN is
        select dc_rownum
          from DA.DC_JBCONT
            where not JBC_SC_RFP_COST_FLAG in ('Y', 'N') ;

--SYS_C0063895 - "JBC_COMP_CODE" IS NOT NULL
 cursor cur_SYS_C0063895 is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_COMP_CODE" IS NOT NULL ;

--JBC_W_CAT_NO_BILL_CODE_FLAG - jbc_w_cat_no_bill_code_flag in ('Y','N')
 cursor cur_JBC_W_CAT_NO_BILL_CODE_FLA is
        select dc_rownum
          from DA.DC_JBCONT
            where not jbc_w_cat_no_bill_code_flag in ('Y','N') ;

--SYS_C0063896 - "JBC_CONT_CODE" IS NOT NULL
 cursor cur_SYS_C0063896 is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_CONT_CODE" IS NOT NULL ;

--JBC_CURR_CODE_NN - "JBC_CURR_CODE" IS NOT NULL
 cursor cur_JBC_CURR_CODE_NN is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_CURR_CODE" IS NOT NULL ;

--JBC_INVOICE_CURR_CODE_NN - "JBC_INVOICE_CURR_CODE" IS NOT NULL
 cursor cur_JBC_INVOICE_CURR_CODE_NN is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_INVOICE_CURR_CODE" IS NOT NULL ;

--JBC_SC_RFP_COST_FLAG_NN - "JBC_SC_RFP_COST_FLAG" IS NOT NULL
 cursor cur_JBC_SC_RFP_COST_FLAG_NN is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_SC_RFP_COST_FLAG" IS NOT NULL ;

--JBC_STARTING_DRAW_NUM_NN - "JBC_STARTING_DRAW_NUM" IS NOT NULL
 cursor cur_JBC_STARTING_DRAW_NUM_NN is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_STARTING_DRAW_NUM" IS NOT NULL ;

--SYS_C0088285 - "JBC_W_CAT_NO_BILL_CODE_FLAG" IS NOT NULL
 cursor cur_SYS_C0088285 is
        select dc_rownum
          from DA.DC_JBCONT
            where not "JBC_W_CAT_NO_BILL_CODE_FLAG" IS NOT NULL ;

BEGIN
null;

 for row_dc in cur_SYS_C0063900
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'SYS_C0063900',
                    'SYS_C0063900',
                    'Condition "JBC_EXCL_NONINV_RECEIPTS" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_JBC_EXCL_NONINV_RECEIPTS
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'JBC_EXCL_NONINV_RECEIPTS',
                    'JBC_EXCL_NONINV_RECEIPTS',
                    'Condition JBC_EXCL_NONINV_RECEIPTS in (''Y'',''N'') failed.');
 end loop;

 for row_dc in cur_JBC_SC_RFP_COST_FLAG_YN
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'JBC_SC_RFP_COST_FLAG_YN',
                    'JBC_SC_RFP_COST_FLAG_YN',
                    'Condition JBC_SC_RFP_COST_FLAG in (''Y'', ''N'') failed.');
 end loop;

 for row_dc in cur_SYS_C0063895
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'SYS_C0063895',
                    'SYS_C0063895',
                    'Condition "JBC_COMP_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_JBC_W_CAT_NO_BILL_CODE_FLA
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'JBC_W_CAT_NO_BILL_CODE_FLAG',
                    'JBC_W_CAT_NO_BILL_CODE_FLAG',
                    'Condition jbc_w_cat_no_bill_code_flag in (''Y'',''N'') failed.');
 end loop;

 for row_dc in cur_SYS_C0063896
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'SYS_C0063896',
                    'SYS_C0063896',
                    'Condition "JBC_CONT_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_JBC_CURR_CODE_NN
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'JBC_CURR_CODE_NN',
                    'JBC_CURR_CODE_NN',
                    'Condition "JBC_CURR_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_JBC_INVOICE_CURR_CODE_NN
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'JBC_INVOICE_CURR_CODE_NN',
                    'JBC_INVOICE_CURR_CODE_NN',
                    'Condition "JBC_INVOICE_CURR_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_JBC_SC_RFP_COST_FLAG_NN
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'JBC_SC_RFP_COST_FLAG_NN',
                    'JBC_SC_RFP_COST_FLAG_NN',
                    'Condition "JBC_SC_RFP_COST_FLAG" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_JBC_STARTING_DRAW_NUM_NN
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'JBC_STARTING_DRAW_NUM_NN',
                    'JBC_STARTING_DRAW_NUM_NN',
                    'Condition "JBC_STARTING_DRAW_NUM" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0088285
 loop
    da.dbk_dc.error('DC_JBCONT',
                    row_dc.dc_rownum,
                    'SYS_C0088285',
                    'SYS_C0088285',
                    'Condition "JBC_W_CAT_NO_BILL_CODE_FLAG" IS NOT NULL failed.');
 end loop;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.JBCONT table
--======================================================================
PROCEDURE IDX_CHECK AS

--JBCONT_PK
cursor cur_JBCONT_PK is
  select dc_rownum,
	 JBC_CONT_CODE,
	 JBC_COMP_CODE
    from DA.DC_JBCONT S1
      where exists (select '1'
                      from DA.JBCONT S2
                        where S1.JBC_CONT_CODE = S2.JBC_CONT_CODE
			  and S1.JBC_COMP_CODE = S2.JBC_COMP_CODE );
BEGIN
 null; 

--JBCONT_PK
 for row_dc in cur_JBCONT_PK
 loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,
                'JBCONT_PK',
                'JBCONT_PK',
                'Record with '||'JBC_CONT_CODE '||row_dc.JBC_CONT_CODE ||
		', '||'JBC_COMP_CODE '||row_dc.JBC_COMP_CODE ||
		' already exists in DA.JBCONT table.');

 end loop;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_JBCONT table
--======================================================================
PROCEDURE IDX_DUPL AS

--JBCONT_PK
cursor cur_JBCONT_PK is
  select dc_rownum,
	 JBC_CONT_CODE,
	 JBC_COMP_CODE
    from DA.DC_JBCONT S1
      where
        exists (select '1'
                  from DA.DC_JBCONT S2
                    where S1.JBC_CONT_CODE = S2.JBC_CONT_CODE
		      and S1.JBC_COMP_CODE = S2.JBC_COMP_CODE
		      and S1.rowid != S2.rowid );
BEGIN
 null; 

--JBCONT_PK
 for row_dc in cur_JBCONT_PK
 loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,
                'JBCONT_PK',
                'JBCONT_PK',
                'Record with '||'JBC_CONT_CODE '||row_dc.JBC_CONT_CODE ||
		', '||'JBC_COMP_CODE '||row_dc.JBC_COMP_CODE ||
		' already exists in DA.DC_JBCONT table.');
end loop;
END IDX_DUPL;

--======================================================================
--JBC_COMP_CODE
--======================================================================
PROCEDURE JBC_COMP_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_COMP_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_COMP_CODE',
        'JBC_COMP_CODE',
        'JBC_COMP_CODE can not be null.');
  end loop;
END JBC_COMP_CODE;

--======================================================================
--JBC_COMP_CODE_2
--======================================================================
PROCEDURE JBC_COMP_CODE_2 AS
  cursor cur_JBC_COMP_CODE is
    select dc_rownum,
           JBC_COMP_CODE
      from DA.DC_JBCONT  ;

 t_result        da.apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 for row_dc in cur_JBC_COMP_CODE
 loop
   t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
              row_dc.JBC_COMP_CODE,t_comp_name);
   if ('0' != t_result) then
         da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   end if;
 end loop;
END JBC_COMP_CODE_2;

--======================================================================
--JBC_CONT_CODE
--======================================================================
PROCEDURE JBC_CONT_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_CONT_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_CONT_CODE',
        'JBC_CONT_CODE',
        'JBC_CONT_CODE can not be null.');
  end loop;
END JBC_CONT_CODE;

--======================================================================
--JBC_JOB_CODE
--======================================================================
PROCEDURE JBC_JOB_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_JOB_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_JOB_CODE',
        'JBC_JOB_CODE',
        'JBC_JOB_CODE can not be null.');
  end loop;
END JBC_JOB_CODE;

--======================================================================
--JBC_JOB_CODE_2
--======================================================================
PROCEDURE JBC_JOB_CODE_2 AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_JOB_CODE NOT IN (select 'ALL' from dual union all select 'ALLBID' from dual union all select job_code from da.jcjob_table where job_comp_code = JBC_COMP_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_JOB_CODE',
        'JBC_JOB_CODE',
        'Not a valid JBC_JOB_CODE value');
  end loop;
END JBC_JOB_CODE_2;

--======================================================================
--JBC_JOB_CTRL_CODE
--======================================================================
PROCEDURE JBC_JOB_CTRL_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JBC_COMP_CODE,
	   JBC_JOB_CTRL_CODE
	from DA.DC_JBCONT T1
	  where not exists (select '1'
                        from DA.JCJOB_TABLE  T2
                          where T1.JBC_COMP_CODE = T2.JOB_COMP_CODE
			    and T1.JBC_JOB_CTRL_CODE = T2.JOB_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JBC_JOB_CTRL_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_JOB_CTRL_CODE',
                'JCJOB_TABLE',
                'Record with'||
		' JOB_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' JOB_CODE '||row_dc.JBC_JOB_CTRL_CODE||
		' does not exist in DA.JCJOB_TABLE table.'); 
    end if;
 end loop;

END JBC_JOB_CTRL_CODE;

--======================================================================
--JBC_JOB_CTRL_CODE_2
--======================================================================
PROCEDURE JBC_JOB_CTRL_CODE_2 AS
  cursor cur_dc is
    select dc_rownum,
	   JBC_COMP_CODE,
	   JBC_JOB_CODE,
	   JBC_JOB_CTRL_CODE
	from DA.DC_JBCONT T1
	  where not exists (select '1'
                        from DA.JCJOBCAT  T2
                          where T1.JBC_COMP_CODE = T2.JCAT_COMP_CODE
			    and T1.JBC_JOB_CODE = T2.JCAT_JOB_CODE
			    and T1.JBC_JOB_CTRL_CODE = T2.JCAT_JOB_CTRL_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JBC_JOB_CTRL_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_JOB_CTRL_CODE',
                'JCJOBCAT',
                'Record with'||
		' JCAT_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' JCAT_JOB_CODE '||row_dc.JBC_JOB_CODE||
		','||' JCAT_JOB_CTRL_CODE '||row_dc.JBC_JOB_CTRL_CODE||
		' does not exist in DA.JCJOBCAT table.'); 
    end if;
 end loop;

END JBC_JOB_CTRL_CODE_2;

--======================================================================
--JBC_CUST_CODE
--======================================================================
PROCEDURE JBC_CUST_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_CUST_CODE NOT IN (select bpcust_bp_code from da.bpcustomers where bpcust_comp_code = JBC_COMP_CODE and bpcust_bp_code = JBC_CUST_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_CUST_CODE',
        'JBC_CUST_CODE',
        'Not a valid JBC_CUST_CODE value');
  end loop;
END JBC_CUST_CODE;

--======================================================================
--JBC_DEFAULT_BILLING_TYPE
--======================================================================
PROCEDURE JBC_DEFAULT_BILLING_TYPE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_DEFAULT_BILLING_TYPE IS NOT NULL AND JBC_DEFAULT_BILLING_TYPE NOT IN (select JBBT_BILLING_TYPE_CODE from DA.JBBILLINGTYPE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_DEFAULT_BILLING_TYPE',
        'JBC_DEFAULT_BILLING_TYPE',
        'Not a valid JBC_DEFAULT_BILLING_TYPE value');
  end loop;
END JBC_DEFAULT_BILLING_TYPE;

--======================================================================
--JBC_CURR_CODE
--======================================================================
PROCEDURE JBC_CURR_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_CURR_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_CURR_CODE',
        'JBC_CURR_CODE',
        'JBC_CURR_CODE can not be null.');
  end loop;
END JBC_CURR_CODE;

--======================================================================
--JBC_CURR_CODE_2
--======================================================================
PROCEDURE JBC_CURR_CODE_2 AS
  cursor cur_JBC_CURR_CODE_2 is
   select dc_rownum,
          JBC_CURR_CODE
     from DA.DC_JBCONT ;

 t_result       da.apkc.t_result_type%type;
 t_curr_name    da.bacurrency.bacurr_name%type;

BEGIN
 for row_dc in cur_JBC_CURR_CODE_2
 loop 
       t_result := da.apk_sys_currency.chk(da.apk_util.context(DA.APKC.IS_NOT_NULL,DA.APKC.IS_ON_FILE),
                                  row_dc.JBC_CURR_CODE,
                                  t_curr_name);

        if ('0' != t_result) then
             da.dbk_dc.error('DC_JBCONT',
                     row_dc.dc_rownum,
                     'JBC_CURR_CODE',
                     'CURR_CODE',
                     t_result);
      end if;

 end loop;
END JBC_CURR_CODE_2;

--======================================================================
--JBC_TERM_CODE
--======================================================================
PROCEDURE JBC_TERM_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JBC_COMP_CODE,
	   JBC_TERM_CODE
	from DA.DC_JBCONT T1
	  where not exists (select '1'
                        from DA.TERM  T2
                          where T1.JBC_COMP_CODE = T2.TERM_COMP_CODE
			    and T1.JBC_TERM_CODE = T2.TERM_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JBC_TERM_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_TERM_CODE',
                'TERM',
                'Record with'||
		' TERM_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' TERM_CODE '||row_dc.JBC_TERM_CODE||
		' does not exist in DA.TERM table.'); 
    end if;
 end loop;

END JBC_TERM_CODE;

--======================================================================
--JBC_TAX1_CODE
--======================================================================
PROCEDURE JBC_TAX1_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JBC_COMP_CODE,
	   JBC_TAX1_CODE
	from DA.DC_JBCONT T1
	  where not exists (select '1'
                        from DA.ARTAX  T2
                          where T1.JBC_COMP_CODE = T2.ARTAX_COMP_CODE
			    and T1.JBC_TAX1_CODE = T2.ARTAX_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JBC_TAX1_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_TAX1_CODE',
                'ARTAX',
                'Record with'||
		' ARTAX_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JBC_TAX1_CODE||
		' does not exist in DA.ARTAX table.'); 
    end if;
 end loop;

END JBC_TAX1_CODE;

--======================================================================
--JBC_TAX2_CODE
--======================================================================
PROCEDURE JBC_TAX2_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JBC_COMP_CODE,
	   JBC_TAX2_CODE
	from DA.DC_JBCONT T1
	  where not exists (select '1'
                        from DA.ARTAX  T2
                          where T1.JBC_COMP_CODE = T2.ARTAX_COMP_CODE
			    and T1.JBC_TAX2_CODE = T2.ARTAX_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JBC_TAX2_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_TAX2_CODE',
                'ARTAX',
                'Record with'||
		' ARTAX_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JBC_TAX2_CODE||
		' does not exist in DA.ARTAX table.'); 
    end if;
 end loop;

END JBC_TAX2_CODE;

--======================================================================
--JBC_TAX3_CODE
--======================================================================
PROCEDURE JBC_TAX3_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JBC_COMP_CODE,
	   JBC_TAX3_CODE
	from DA.DC_JBCONT T1
	  where not exists (select '1'
                        from DA.ARTAX  T2
                          where T1.JBC_COMP_CODE = T2.ARTAX_COMP_CODE
			    and T1.JBC_TAX3_CODE = T2.ARTAX_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JBC_TAX3_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_TAX3_CODE',
                'ARTAX',
                'Record with'||
		' ARTAX_COMP_CODE '||row_dc.JBC_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JBC_TAX3_CODE||
		' does not exist in DA.ARTAX table.'); 
    end if;
 end loop;

END JBC_TAX3_CODE;

--======================================================================
--JBC_ADD_TYPE_CODE
--======================================================================
PROCEDURE JBC_ADD_TYPE_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_ADD_TYPE_CODE IS NOT NULL AND JBC_ADD_TYPE_CODE NOT IN (select bpad_add_type_code from da.bpaddresses where bpad_bp_code = JBC_CUST_CODE and bpad_add_type_code = JBC_ADD_TYPE_CODE and nvl(bpad_active_flag, 'N')  = 'Y');
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_ADD_TYPE_CODE',
        'JBC_ADD_TYPE_CODE',
        'Not a valid JBC_ADD_TYPE_CODE value');
  end loop;
END JBC_ADD_TYPE_CODE;

--======================================================================
--JBC_REGION_CODE
--======================================================================
PROCEDURE JBC_REGION_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_REGION_CODE IS NOT NULL AND JBC_REGION_CODE NOT IN (select reg_code from da.region where reg_code = JBC_REGION_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_REGION_CODE',
        'JBC_REGION_CODE',
        'Not a valid JBC_REGION_CODE value');
  end loop;
END JBC_REGION_CODE;

--======================================================================
--JBC_DEFAULT_INV_FORMAT_CODE
--======================================================================
PROCEDURE JBC_DEFAULT_INV_FORMAT_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_DEFAULT_INV_FORMAT_CODE IS NOT NULL AND JBC_DEFAULT_INV_FORMAT_CODE NOT IN (select JBIF_INVOICE_FORMAT_CODE from da.jbinvoice_format where JBIF_INVOICE_FORMAT_CODE = JBC_DEFAULT_INV_FORMAT_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_DEFAULT_INV_FORMAT_CODE',
        'JBC_DEFAULT_INV_FORMAT_CODE',
        'Not a valid JBC_DEFAULT_INV_FORMAT_CODE value');
  end loop;
END JBC_DEFAULT_INV_FORMAT_CODE;

--======================================================================
--JBC_ARCHITECT_BP_CODE
--======================================================================
PROCEDURE JBC_ARCHITECT_BP_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_ARCHITECT_BP_CODE IS NOT NULL AND JBC_ARCHITECT_BP_CODE NOT IN (select bp_code from da.bpartners where bp_code = JBC_ARCHITECT_BP_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_ARCHITECT_BP_CODE',
        'JBC_ARCHITECT_BP_CODE',
        'Not a valid JBC_ARCHITECT_BP_CODE value');
  end loop;
END JBC_ARCHITECT_BP_CODE;

--======================================================================
--JBC_STARTING_DRAW_NUM
--======================================================================
PROCEDURE JBC_STARTING_DRAW_NUM AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_STARTING_DRAW_NUM is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_STARTING_DRAW_NUM',
        'JBC_STARTING_DRAW_NUM',
        'JBC_STARTING_DRAW_NUM can not be null.');
  end loop;
END JBC_STARTING_DRAW_NUM;

--======================================================================
--JBC_INVOICE_CURR_CODE
--======================================================================
PROCEDURE JBC_INVOICE_CURR_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_INVOICE_CURR_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_INVOICE_CURR_CODE',
        'JBC_INVOICE_CURR_CODE',
        'JBC_INVOICE_CURR_CODE can not be null.');
  end loop;
END JBC_INVOICE_CURR_CODE;

--======================================================================
--JBC_INVOICE_CURR_CODE_2
--======================================================================
PROCEDURE JBC_INVOICE_CURR_CODE_2 AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_INVOICE_CURR_CODE NOT IN (select BPCUST_CURR_CODE from da.bpcustomers where bpcust_comp_code = JBC_COMP_CODE and bpcust_bp_code = JBC_CUST_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_INVOICE_CURR_CODE',
        'JBC_INVOICE_CURR_CODE',
        'Not a valid JBC_INVOICE_CURR_CODE value');
  end loop;
END JBC_INVOICE_CURR_CODE_2;

--======================================================================
--JBC_PM_CONTACT_PARTN_TYPE_CODE
--======================================================================
PROCEDURE JBC_PM_CONTACT_PARTN_TYPE_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_PM_CONTACT_PARTN_TYPE_CODE IS NOT NULL AND JBC_PM_CONTACT_PARTN_TYPE_CODE NOT IN (select job_partn_type_code from da.jcjob_table WHERE JOB_COMP_CODE = JBC_COMP_CODE AND JOB_CODE = JBC_JOB_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_PM_CONTACT_PARTN_TYPE_CODE',
        'JBC_PM_CONTACT_PARTN_TYPE_CODE',
        'Not a valid JBC_PM_CONTACT_PARTN_TYPE_CODE value');
  end loop;
END JBC_PM_CONTACT_PARTN_TYPE_CODE;

--======================================================================
--JBC_PM_CONTACT_PARTN_CODE
--======================================================================
PROCEDURE JBC_PM_CONTACT_PARTN_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_PM_CONTACT_PARTN_CODE IS NOT NULL AND JBC_PM_CONTACT_PARTN_CODE NOT IN (select job_partn_code from da.jcjob_table WHERE JOB_COMP_CODE = JBC_COMP_CODE AND JOB_CODE = JBC_JOB_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_PM_CONTACT_PARTN_CODE',
        'JBC_PM_CONTACT_PARTN_CODE',
        'Not a valid JBC_PM_CONTACT_PARTN_CODE value');
  end loop;
END JBC_PM_CONTACT_PARTN_CODE;

--======================================================================
--JBC_PM_CONTACT_CODE
--======================================================================
PROCEDURE JBC_PM_CONTACT_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_PM_CONTACT_CODE IS NOT NULL AND JBC_PM_CONTACT_CODE NOT IN (select job_contact_code from da.jcjob_table WHERE JOB_COMP_CODE = JBC_COMP_CODE AND JOB_CODE = JBC_JOB_CODE);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_PM_CONTACT_CODE',
        'JBC_PM_CONTACT_CODE',
        'Not a valid JBC_PM_CONTACT_CODE value');
  end loop;
END JBC_PM_CONTACT_CODE;

--======================================================================
--JBC_RET_CODE
--======================================================================
PROCEDURE JBC_RET_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_RET_CODE IS NOT NULL AND JBC_RET_CODE NOT IN (SELECT JBRETR_CODE FROM da.jbretrate WHERE JBRETR_comp_Code = JBC_COMP_CODE AND JBRETR_cont_code IN ('ALL', JBC_CONT_CODE));
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_RET_CODE',
        'JBC_RET_CODE',
        'Not a valid JBC_RET_CODE value');
  end loop;
END JBC_RET_CODE;

--======================================================================
--JBC_RULE_CODE
--======================================================================
PROCEDURE JBC_RULE_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_RULE_CODE IS NOT NULL AND JBC_RULE_CODE NOT IN (select jcsr.jcsr_rule_code from da.jcspread_rule jcsr where jcsr_period_code in (select jcpp.jcpp_period_code from da.jcperiod_parameters jcpp where jcpp.jcpp_select_into_array is not null));
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_RULE_CODE',
        'JBC_RULE_CODE',
        'Not a valid JBC_RULE_CODE value');
  end loop;
END JBC_RULE_CODE;

--======================================================================
--TIME_PHASED_FLAG
--======================================================================
PROCEDURE TIME_PHASED_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JBC_TIME_PHASED_FLAG
      from DA.DC_JBCONT
        where nvl(JBC_TIME_PHASED_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_TIME_PHASED_FLAG',
        'JBC_TIME_PHASED_FLAG',
        'JBC_TIME_PHASED_FLAG must be set to ''Y'',''N''.');

  end loop;
END TIME_PHASED_FLAG;

--======================================================================
--DEPT_CODE_2
--======================================================================
PROCEDURE DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         JBC_COMP_CODE,
         JBC_DEPT_CODE
    from DA.DC_JBCONT ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL,DA.APKC.USER_HAS_ACCESS),
                row_dc.JBC_COMP_CODE,
                row_dc.JBC_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_JBCONT',
                row_dc.dc_rownum,
                'JBC_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END DEPT_CODE_2;

--======================================================================
--JBC_JBPYTRADE_XREF_CODE
--======================================================================
PROCEDURE JBC_JBPYTRADE_XREF_CODE AS
  cursor cur_dc is
    select dc_rownum
      from DA.DC_JBCONT
        where JBC_JBPYTRADE_XREF_CODE IS NOT NULL AND JBC_JBPYTRADE_XREF_CODE NOT IN (SELECT JBC_JBPYTRADE_XREF_CODE FROM da.JB_PY_XREF_Trade_Code);
BEGIN
  for row_dc in cur_dc
  loop
        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_JBPYTRADE_XREF_CODE',
        'JBC_JBPYTRADE_XREF_CODE',
        'Not a valid JBC_JBPYTRADE_XREF_CODE value');
  end loop;
END JBC_JBPYTRADE_XREF_CODE;

--======================================================================
--EXCL_NONINV_RECEIPTS
--======================================================================
PROCEDURE EXCL_NONINV_RECEIPTS AS
  cursor cur_dc is
    select dc_rownum,
           JBC_EXCL_NONINV_RECEIPTS
      from DA.DC_JBCONT
        where nvl(JBC_EXCL_NONINV_RECEIPTS,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_EXCL_NONINV_RECEIPTS',
        'JBC_EXCL_NONINV_RECEIPTS',
        'JBC_EXCL_NONINV_RECEIPTS must be set to ''Y'',''N''.');

  end loop;
END EXCL_NONINV_RECEIPTS;

--======================================================================
--SC_RFP_COST_FLAG
--======================================================================
PROCEDURE SC_RFP_COST_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JBC_SC_RFP_COST_FLAG
      from DA.DC_JBCONT
        where nvl(JBC_SC_RFP_COST_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_SC_RFP_COST_FLAG',
        'JBC_SC_RFP_COST_FLAG',
        'JBC_SC_RFP_COST_FLAG must be set to ''Y'',''N''.');

  end loop;
END SC_RFP_COST_FLAG;

--======================================================================
--W_CAT_NO_BILL_CODE_FLAG
--======================================================================
PROCEDURE W_CAT_NO_BILL_CODE_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JBC_W_CAT_NO_BILL_CODE_FLAG
      from DA.DC_JBCONT
        where nvl(JBC_W_CAT_NO_BILL_CODE_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_W_CAT_NO_BILL_CODE_FLAG',
        'JBC_W_CAT_NO_BILL_CODE_FLAG',
        'JBC_W_CAT_NO_BILL_CODE_FLAG must be set to ''Y'',''N''.');

  end loop;
END W_CAT_NO_BILL_CODE_FLAG;

--======================================================================
--INVOICE_LEVEL_RET_FLAG
--======================================================================
PROCEDURE INVOICE_LEVEL_RET_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JBC_INVOICE_LEVEL_RET_FLAG
      from DA.DC_JBCONT
        where nvl(JBC_INVOICE_LEVEL_RET_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JBCONT',row_dc.dc_rownum,'JBC_INVOICE_LEVEL_RET_FLAG',
        'JBC_INVOICE_LEVEL_RET_FLAG',
        'JBC_INVOICE_LEVEL_RET_FLAG must be set to ''Y'',''N''.');

  end loop;
END INVOICE_LEVEL_RET_FLAG;

--======================================================================
--VERIFY_DATA - run all verify procedures define for JBCONT table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
        display_status(' Delete rows DC_JBCONT from DA.DC_ERROR.');
        delete from da.dc_error
          where upper(dcerr_table_name) = 'DC_JBCONT' ;

        commit;

        display_status(' INDEX checking in DA.JBCONT');
        idx_check;

        commit;

        display_status(' INDEX  checking in DA.DC_JBCONT');
        idx_dupl;

        commit;

        display_status(' FOREIGN KEYS checking in DA.DC_JBCONT');
        Fk_con;

        commit;

        display_status(' CHECK constraints checking in DA.DC_JBCONT');
        check_con;

        commit;


        display_status(' JBC_JBC_COMP_CODE - checking');
        JBC_COMP_CODE;

        commit;

        display_status(' JBC_JBC_COMP_CODE_2 - checking');
        JBC_COMP_CODE_2;

        commit;

        display_status(' JBC_JBC_CONT_CODE - checking');
        JBC_CONT_CODE;

        commit;

        display_status(' JBC_JBC_JOB_CODE - checking');
        JBC_JOB_CODE;

        commit;

        display_status(' JBC_JBC_JOB_CODE_2 - checking');
        JBC_JOB_CODE_2;

        commit;

        display_status(' JBC_JOB_CTRL_CODE - checking');
        JBC_JOB_CTRL_CODE;

        commit;

        display_status(' JBC_JOB_CTRL_CODE_2 - checking');
        JBC_JOB_CTRL_CODE_2;

        commit;

        display_status(' JBC_JBC_CUST_CODE - checking');
        JBC_CUST_CODE;

        commit;

        display_status(' JBC_JBC_DEFAULT_BILLING_TYPE - checking');
        JBC_DEFAULT_BILLING_TYPE;

        commit;

        display_status(' JBC_JBC_CURR_CODE - checking');
        JBC_CURR_CODE;

        commit;

        display_status(' JBC_JBC_CURR_CODE_2 - checking');
        JBC_CURR_CODE_2;

        commit;

        display_status(' JBC_TERM_CODE - checking');
        JBC_TERM_CODE;

        commit;

        display_status(' JBC_TAX1_CODE - checking');
        JBC_TAX1_CODE;

        commit;

        display_status(' JBC_TAX2_CODE - checking');
        JBC_TAX2_CODE;

        commit;

        display_status(' JBC_TAX3_CODE - checking');
        JBC_TAX3_CODE;

        commit;

        display_status(' JBC_JBC_ADD_TYPE_CODE - checking');
        JBC_ADD_TYPE_CODE;

        commit;

        display_status(' JBC_JBC_REGION_CODE - checking');
        JBC_REGION_CODE;

        commit;

        display_status(' JBC_JBC_DEFAULT_INV_FORMAT_CODE - checking');
        JBC_DEFAULT_INV_FORMAT_CODE;

        commit;

        display_status(' JBC_JBC_ARCHITECT_BP_CODE - checking');
        JBC_ARCHITECT_BP_CODE;

        commit;

        display_status(' JBC_JBC_STARTING_DRAW_NUM - checking');
        JBC_STARTING_DRAW_NUM;

        commit;

        display_status(' JBC_JBC_INVOICE_CURR_CODE - checking');
        JBC_INVOICE_CURR_CODE;

        commit;

        display_status(' JBC_JBC_INVOICE_CURR_CODE_2 - checking');
        JBC_INVOICE_CURR_CODE_2;

        commit;

        display_status(' JBC_JBC_PM_CONTACT_PARTN_TYPE_CODE - checking');
        JBC_PM_CONTACT_PARTN_TYPE_CODE;

        commit;

        display_status(' JBC_JBC_PM_CONTACT_PARTN_CODE - checking');
        JBC_PM_CONTACT_PARTN_CODE;

        commit;

        display_status(' JBC_JBC_PM_CONTACT_CODE - checking');
        JBC_PM_CONTACT_CODE;

        commit;

        display_status(' JBC_JBC_RET_CODE - checking');
        JBC_RET_CODE;

        commit;

        display_status(' JBC_JBC_RULE_CODE - checking');
        JBC_RULE_CODE;

        commit;

        display_status(' JBC_TIME_PHASED_FLAG - checking');
        TIME_PHASED_FLAG;

        commit;

        display_status(' JBC_DEPT_CODE_2 - checking');
        DEPT_CODE_2;

        commit;

        display_status(' JBC_JBC_JBPYTRADE_XREF_CODE - checking');
        JBC_JBPYTRADE_XREF_CODE;

        commit;

        display_status(' JBC_EXCL_NONINV_RECEIPTS - checking');
        EXCL_NONINV_RECEIPTS;

        commit;

        display_status(' JBC_SC_RFP_COST_FLAG - checking');
        SC_RFP_COST_FLAG;

        commit;

        display_status(' JBC_W_CAT_NO_BILL_CODE_FLAG - checking');
        W_CAT_NO_BILL_CODE_FLAG;

        commit;

        display_status(' JBC_INVOICE_LEVEL_RET_FLAG - checking');
        INVOICE_LEVEL_RET_FLAG;

        commit;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.JBCONT table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_JBCONT table
   cursor cur_err_JBCONT is
     select count(1)
       from da.dc_error
        where upper(dcerr_table_name) = 'DC_JBCONT' ;

   t_n_err_JBCONT         NUMBER;

 cursor cInsert is 
   select
	JBC_COMP_CODE		--1
	,JBC_CONT_CODE		--2
	,JBC_JOB_CODE		--3
	,JBC_JOB_CTRL_CODE		--4
	,JBC_CUST_CODE		--5
	,JBC_DEFAULT_BILLING_TYPE		--6
	,JBC_NAME		--7
	,JBC_CURR_CODE		--8
	,JBC_TERM_CODE		--9
	,JBC_HLDBK_PC		--10
	,JBC_TAX1_CODE		--11
	,JBC_TAX2_CODE		--12
	,JBC_TAX3_CODE		--13
	,JBC_BID_DATE		--14
	,JBC_CONT_DATE		--15
	,JBC_LSTREV_DATE		--16
	,JBC_CLOSED_DATE		--17
	,JBC_ADD_TYPE_CODE		--18
	,JBC_CONTACT_NAME		--19
	,JBC_ADD1		--20
	,JBC_ADD2		--21
	,JBC_ADD3		--22
	,JBC_REGION_CODE		--23
	,JBC_COUNTRY		--24
	,JBC_POSTAL_CODE		--25
	,JBC_PHONE_NUM		--26
	,JBC_FAX_NUM		--27
	,JBC_DESC		--28
	,JBC_ENG_NAME		--29
	,JBC_ARC_NAME		--30
	,JBC_LAW_NAME		--31
	,JBC_SUP_NAME		--32
	,JBC_APPROVED_DATE		--33
	,JBC_APPROVED_USER		--34
	,JBC_MAX_BILLING_AMT		--35
	,JBC_BUDG_BILLING_AMT		--36
	,JBC_DEFAULT_INV_FORMAT_CODE		--37
	,JBC_PROJECT_MANAGER		--38
	,JBC_DEFAULT_TAX1_TAXABLE_PCT		--39
	,JBC_DEFAULT_TAX2_TAXABLE_PCT		--40
	,JBC_DEFAULT_TAX3_TAXABLE_PCT		--41
	,JBC_ARCHITECT_BP_CODE		--42
	,JBC_STARTING_DRAW_NUM		--43
	,JBC_MIN_CODE		--44
	,JBC_INVOICE_CURR_CODE		--45
	,JBC_FIXED_CURR_FACTOR_NUM		--46
	,JBC_PM_CONTACT_PARTN_TYPE_CODE		--47
	,JBC_PM_CONTACT_PARTN_CODE		--48
	,JBC_PM_CONTACT_CODE		--49
	,JBC_RET_CODE		--50
	,JBC_OBJECT_ORASEQ		--51
	,JBC_START_DATE		--52
	,JBC_END_DATE		--53
	,JBC_RULE_CODE		--54
	,JBC_TIME_PHASED_FLAG		--55
	,JBC_ALTERNATE_CUST_NAME		--56
	,JBC_DEPT_CODE		--57
	,JBC_JBPYTRADE_XREF_CODE		--58
	,JBC_ALT_CUST_ADD_CODE		--59
	,JBC_EXCL_NONINV_RECEIPTS		--60
	,JBC_SC_RFP_COST_FLAG		--61
	,JBC_W_CAT_NO_BILL_CODE_FLAG		--62
	,JBC_INVOICE_LEVEL_RET_FLAG		--63
   from DA.DC_JBCONT;

BEGIN
 open  cur_err_JBCONT;
 fetch cur_err_JBCONT into t_n_err_JBCONT;
 close cur_err_JBCONT;

 display_status('Number of errors in DC_ERROR table for DC_JBCONT table :'||
                to_char(t_n_err_JBCONT));

 if ( t_n_err_JBCONT = 0 )
 then

   display_status('Insert into DA.JBCONT');

--Insert select section 
-- use this statement if speed is the problem and there are no triggers
-- causing mutating problem

/*     insert into DA.JBCONT
        (JBC_COMP_CODE		--1
	,JBC_CONT_CODE		--2
	,JBC_JOB_CODE		--3
	,JBC_JOB_CTRL_CODE		--4
	,JBC_CUST_CODE		--5
	,JBC_DEFAULT_BILLING_TYPE		--6
	,JBC_NAME		--7
	,JBC_CURR_CODE		--8
	,JBC_TERM_CODE		--9
	,JBC_HLDBK_PC		--10
	,JBC_TAX1_CODE		--11
	,JBC_TAX2_CODE		--12
	,JBC_TAX3_CODE		--13
	,JBC_BID_DATE		--14
	,JBC_CONT_DATE		--15
	,JBC_LSTREV_DATE		--16
	,JBC_CLOSED_DATE		--17
	,JBC_ADD_TYPE_CODE		--18
	,JBC_CONTACT_NAME		--19
	,JBC_ADD1		--20
	,JBC_ADD2		--21
	,JBC_ADD3		--22
	,JBC_REGION_CODE		--23
	,JBC_COUNTRY		--24
	,JBC_POSTAL_CODE		--25
	,JBC_PHONE_NUM		--26
	,JBC_FAX_NUM		--27
	,JBC_DESC		--28
	,JBC_ENG_NAME		--29
	,JBC_ARC_NAME		--30
	,JBC_LAW_NAME		--31
	,JBC_SUP_NAME		--32
	,JBC_APPROVED_DATE		--33
	,JBC_APPROVED_USER		--34
	,JBC_MAX_BILLING_AMT		--35
	,JBC_BUDG_BILLING_AMT		--36
	,JBC_DEFAULT_INV_FORMAT_CODE		--37
	,JBC_PROJECT_MANAGER		--38
	,JBC_DEFAULT_TAX1_TAXABLE_PCT		--39
	,JBC_DEFAULT_TAX2_TAXABLE_PCT		--40
	,JBC_DEFAULT_TAX3_TAXABLE_PCT		--41
	,JBC_ARCHITECT_BP_CODE		--42
	,JBC_STARTING_DRAW_NUM		--43
	,JBC_MIN_CODE		--44
	,JBC_INVOICE_CURR_CODE		--45
	,JBC_FIXED_CURR_FACTOR_NUM		--46
	,JBC_PM_CONTACT_PARTN_TYPE_CODE		--47
	,JBC_PM_CONTACT_PARTN_CODE		--48
	,JBC_PM_CONTACT_CODE		--49
	,JBC_RET_CODE		--50
	,JBC_OBJECT_ORASEQ		--51
	,JBC_START_DATE		--52
	,JBC_END_DATE		--53
	,JBC_RULE_CODE		--54
	,JBC_TIME_PHASED_FLAG		--55
	,JBC_ALTERNATE_CUST_NAME		--56
	,JBC_DEPT_CODE		--57
	,JBC_JBPYTRADE_XREF_CODE		--58
	,JBC_ALT_CUST_ADD_CODE		--59
	,JBC_EXCL_NONINV_RECEIPTS		--60
	,JBC_SC_RFP_COST_FLAG		--61
	,JBC_W_CAT_NO_BILL_CODE_FLAG		--62
	,JBC_INVOICE_LEVEL_RET_FLAG		--63
) select
	JBC_COMP_CODE		--1
	,JBC_CONT_CODE		--2
	,JBC_JOB_CODE		--3
	,JBC_JOB_CTRL_CODE		--4
	,JBC_CUST_CODE		--5
	,JBC_DEFAULT_BILLING_TYPE		--6
	,JBC_NAME		--7
	,JBC_CURR_CODE		--8
	,JBC_TERM_CODE		--9
	,JBC_HLDBK_PC		--10
	,JBC_TAX1_CODE		--11
	,JBC_TAX2_CODE		--12
	,JBC_TAX3_CODE		--13
	,JBC_BID_DATE		--14
	,JBC_CONT_DATE		--15
	,JBC_LSTREV_DATE		--16
	,JBC_CLOSED_DATE		--17
	,JBC_ADD_TYPE_CODE		--18
	,JBC_CONTACT_NAME		--19
	,JBC_ADD1		--20
	,JBC_ADD2		--21
	,JBC_ADD3		--22
	,JBC_REGION_CODE		--23
	,JBC_COUNTRY		--24
	,JBC_POSTAL_CODE		--25
	,JBC_PHONE_NUM		--26
	,JBC_FAX_NUM		--27
	,JBC_DESC		--28
	,JBC_ENG_NAME		--29
	,JBC_ARC_NAME		--30
	,JBC_LAW_NAME		--31
	,JBC_SUP_NAME		--32
	,JBC_APPROVED_DATE		--33
	,JBC_APPROVED_USER		--34
	,JBC_MAX_BILLING_AMT		--35
	,JBC_BUDG_BILLING_AMT		--36
	,JBC_DEFAULT_INV_FORMAT_CODE		--37
	,JBC_PROJECT_MANAGER		--38
	,JBC_DEFAULT_TAX1_TAXABLE_PCT		--39
	,JBC_DEFAULT_TAX2_TAXABLE_PCT		--40
	,JBC_DEFAULT_TAX3_TAXABLE_PCT		--41
	,JBC_ARCHITECT_BP_CODE		--42
	,JBC_STARTING_DRAW_NUM		--43
	,JBC_MIN_CODE		--44
	,JBC_INVOICE_CURR_CODE		--45
	,JBC_FIXED_CURR_FACTOR_NUM		--46
	,JBC_PM_CONTACT_PARTN_TYPE_CODE		--47
	,JBC_PM_CONTACT_PARTN_CODE		--48
	,JBC_PM_CONTACT_CODE		--49
	,JBC_RET_CODE		--50
	,JBC_OBJECT_ORASEQ		--51
	,JBC_START_DATE		--52
	,JBC_END_DATE		--53
	,JBC_RULE_CODE		--54
	,JBC_TIME_PHASED_FLAG		--55
	,JBC_ALTERNATE_CUST_NAME		--56
	,JBC_DEPT_CODE		--57
	,JBC_JBPYTRADE_XREF_CODE		--58
	,JBC_ALT_CUST_ADD_CODE		--59
	,JBC_EXCL_NONINV_RECEIPTS		--60
	,JBC_SC_RFP_COST_FLAG		--61
	,JBC_W_CAT_NO_BILL_CODE_FLAG		--62
	,JBC_INVOICE_LEVEL_RET_FLAG		--63
   from DA.DC_JBCONT;
*/
--End of insert select section

--insert loop
   for row_dc in cInsert
   loop
     insert into DA.JBCONT
        (JBC_COMP_CODE		--1
	,JBC_CONT_CODE		--2
	,JBC_JOB_CODE		--3
	,JBC_JOB_CTRL_CODE		--4
	,JBC_CUST_CODE		--5
	,JBC_DEFAULT_BILLING_TYPE		--6
	,JBC_NAME		--7
	,JBC_CURR_CODE		--8
	,JBC_TERM_CODE		--9
	,JBC_HLDBK_PC		--10
	,JBC_TAX1_CODE		--11
	,JBC_TAX2_CODE		--12
	,JBC_TAX3_CODE		--13
	,JBC_BID_DATE		--14
	,JBC_CONT_DATE		--15
	,JBC_LSTREV_DATE		--16
	,JBC_CLOSED_DATE		--17
	,JBC_ADD_TYPE_CODE		--18
	,JBC_CONTACT_NAME		--19
	,JBC_ADD1		--20
	,JBC_ADD2		--21
	,JBC_ADD3		--22
	,JBC_REGION_CODE		--23
	,JBC_COUNTRY		--24
	,JBC_POSTAL_CODE		--25
	,JBC_PHONE_NUM		--26
	,JBC_FAX_NUM		--27
	,JBC_DESC		--28
	,JBC_ENG_NAME		--29
	,JBC_ARC_NAME		--30
	,JBC_LAW_NAME		--31
	,JBC_SUP_NAME		--32
	,JBC_APPROVED_DATE		--33
	,JBC_APPROVED_USER		--34
	,JBC_MAX_BILLING_AMT		--35
	,JBC_BUDG_BILLING_AMT		--36
	,JBC_DEFAULT_INV_FORMAT_CODE		--37
	,JBC_PROJECT_MANAGER		--38
	,JBC_DEFAULT_TAX1_TAXABLE_PCT		--39
	,JBC_DEFAULT_TAX2_TAXABLE_PCT		--40
	,JBC_DEFAULT_TAX3_TAXABLE_PCT		--41
	,JBC_ARCHITECT_BP_CODE		--42
	,JBC_STARTING_DRAW_NUM		--43
	,JBC_MIN_CODE		--44
	,JBC_INVOICE_CURR_CODE		--45
	,JBC_FIXED_CURR_FACTOR_NUM		--46
	,JBC_PM_CONTACT_PARTN_TYPE_CODE		--47
	,JBC_PM_CONTACT_PARTN_CODE		--48
	,JBC_PM_CONTACT_CODE		--49
	,JBC_RET_CODE		--50
	,JBC_OBJECT_ORASEQ		--51
	,JBC_START_DATE		--52
	,JBC_END_DATE		--53
	,JBC_RULE_CODE		--54
	,JBC_TIME_PHASED_FLAG		--55
	,JBC_ALTERNATE_CUST_NAME		--56
	,JBC_DEPT_CODE		--57
	,JBC_JBPYTRADE_XREF_CODE		--58
	,JBC_ALT_CUST_ADD_CODE		--59
	,JBC_EXCL_NONINV_RECEIPTS		--60
	,JBC_SC_RFP_COST_FLAG		--61
	,JBC_W_CAT_NO_BILL_CODE_FLAG		--62
	,JBC_INVOICE_LEVEL_RET_FLAG		--63
     )values
	(row_dc.JBC_COMP_CODE		--1
	,row_dc.JBC_CONT_CODE		--2
	,row_dc.JBC_JOB_CODE		--3
	,row_dc.JBC_JOB_CTRL_CODE		--4
	,row_dc.JBC_CUST_CODE		--5
	,row_dc.JBC_DEFAULT_BILLING_TYPE		--6
	,row_dc.JBC_NAME		--7
	,row_dc.JBC_CURR_CODE		--8
	,row_dc.JBC_TERM_CODE		--9
	,row_dc.JBC_HLDBK_PC		--10
	,row_dc.JBC_TAX1_CODE		--11
	,row_dc.JBC_TAX2_CODE		--12
	,row_dc.JBC_TAX3_CODE		--13
	,row_dc.JBC_BID_DATE		--14
	,row_dc.JBC_CONT_DATE		--15
	,row_dc.JBC_LSTREV_DATE		--16
	,row_dc.JBC_CLOSED_DATE		--17
	,row_dc.JBC_ADD_TYPE_CODE		--18
	,row_dc.JBC_CONTACT_NAME		--19
	,row_dc.JBC_ADD1		--20
	,row_dc.JBC_ADD2		--21
	,row_dc.JBC_ADD3		--22
	,row_dc.JBC_REGION_CODE		--23
	,row_dc.JBC_COUNTRY		--24
	,row_dc.JBC_POSTAL_CODE		--25
	,row_dc.JBC_PHONE_NUM		--26
	,row_dc.JBC_FAX_NUM		--27
	,row_dc.JBC_DESC		--28
	,row_dc.JBC_ENG_NAME		--29
	,row_dc.JBC_ARC_NAME		--30
	,row_dc.JBC_LAW_NAME		--31
	,row_dc.JBC_SUP_NAME		--32
	,row_dc.JBC_APPROVED_DATE		--33
	,row_dc.JBC_APPROVED_USER		--34
	,row_dc.JBC_MAX_BILLING_AMT		--35
	,row_dc.JBC_BUDG_BILLING_AMT		--36
	,row_dc.JBC_DEFAULT_INV_FORMAT_CODE		--37
	,row_dc.JBC_PROJECT_MANAGER		--38
	,row_dc.JBC_DEFAULT_TAX1_TAXABLE_PCT		--39
	,row_dc.JBC_DEFAULT_TAX2_TAXABLE_PCT		--40
	,row_dc.JBC_DEFAULT_TAX3_TAXABLE_PCT		--41
	,row_dc.JBC_ARCHITECT_BP_CODE		--42
	,row_dc.JBC_STARTING_DRAW_NUM		--43
	,row_dc.JBC_MIN_CODE		--44
	,row_dc.JBC_INVOICE_CURR_CODE		--45
	,row_dc.JBC_FIXED_CURR_FACTOR_NUM		--46
	,row_dc.JBC_PM_CONTACT_PARTN_TYPE_CODE		--47
	,row_dc.JBC_PM_CONTACT_PARTN_CODE		--48
	,row_dc.JBC_PM_CONTACT_CODE		--49
	,row_dc.JBC_RET_CODE		--50
	,row_dc.JBC_OBJECT_ORASEQ		--51
	,row_dc.JBC_START_DATE		--52
	,row_dc.JBC_END_DATE		--53
	,row_dc.JBC_RULE_CODE		--54
	,row_dc.JBC_TIME_PHASED_FLAG		--55
	,row_dc.JBC_ALTERNATE_CUST_NAME		--56
	,row_dc.JBC_DEPT_CODE		--57
	,row_dc.JBC_JBPYTRADE_XREF_CODE		--58
	,row_dc.JBC_ALT_CUST_ADD_CODE		--59
	,row_dc.JBC_EXCL_NONINV_RECEIPTS		--60
	,row_dc.JBC_SC_RFP_COST_FLAG		--61
	,row_dc.JBC_W_CAT_NO_BILL_CODE_FLAG		--62
	,row_dc.JBC_INVOICE_LEVEL_RET_FLAG		--63
     );
   end loop;
--end of loop insert


  --delete everything from DA.DC_JBCONT
    display_status('Delete rows from DA.DC_JBCONT table.');
    delete from DA.DC_JBCONT;
    display_status('Number of records deleted from DA.DC_JBCONT table:'||to_char(SQL%rowcount));

     display_status('JBCONT moving from temp table was successful.');
--     commit;

 end if; /*    if nvl(t_n_err_JBCONT,0) = 0 */

exception when others
     then
       display_status('Can not move data from DA.DC_JBCONT into DA.JBCONT.');
       da.dbk_dc.output(SQLERRM);
       rollback;
       raise;

END Process_temp_data ;

END DBK_DC_JBCONT;
/
show error
/
