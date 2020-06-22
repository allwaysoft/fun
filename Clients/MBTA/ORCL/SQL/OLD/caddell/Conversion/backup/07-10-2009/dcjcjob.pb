--Thu Sep 28 15:12:20 2006
PROMPT =======================================
PROMPT   Create DBK_DC_JCJOB_TABLE package body
PROMPT =======================================

CREATE OR REPLACE PACKAGE BODY DA.DBK_DC_JCJOB_TABLE AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.dbk_dc.display_status('DC_JCJOB_TABLE',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS

cursor cur_JCJOB_YESNO_FK7 is
  select dc_rownum,
	 JOB_PM_FLAG
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_PM_FLAG,T2.YN) = T2.YN );

cursor cur_JCJOB_WGTMES_FK is
  select dc_rownum,
	 JOB_WM_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.WGTMES_TABLE T2
                where nvl(T1.JOB_WM_CODE,T2.WM_CODE) = T2.WM_CODE );

cursor cur_JCJOB_DEPT_FK5 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_BILL_DEPT_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.DEPT_TABLE T2
                where nvl(T1.JOB_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  and nvl(T1.JOB_BILL_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );

cursor cur_JCJOB_CILOCATION_FK is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_CILOC_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.CILOCATION T2
                where nvl(T1.JOB_COMP_CODE,T2.CILOC_COMP_CODE) = T2.CILOC_COMP_CODE
		  and nvl(T1.JOB_CILOC_CODE,T2.CILOC_CODE) = T2.CILOC_CODE );

cursor cur_JCJOB_DEPT_FK1 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_WIP_DEPT_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.DEPT_TABLE T2
                where nvl(T1.JOB_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  and nvl(T1.JOB_WIP_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );

cursor cur_JCJOB_COMPANY_FK is
  select dc_rownum,
	 JOB_COMP_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.COMPANY T2
                where nvl(T1.JOB_COMP_CODE,T2.COMP_CODE) = T2.COMP_CODE );

cursor cur_JCJOB_TABLE_ARTAX_FK2 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_AP_TAX2_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JOB_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JOB_AP_TAX2_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );

cursor cur_JCJOB_JCSTATUS_FK is
  select dc_rownum,
	 JOB_STATUS_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.JCSTATUS T2
                where nvl(T1.JOB_STATUS_CODE,T2.JCSTATUS_CODE) = T2.JCSTATUS_CODE );

cursor cur_JCJOB_YESNO_FK6 is
  select dc_rownum,
	 JOB_BID_FLAG
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_BID_FLAG,T2.YN) = T2.YN );

cursor cur_JCJOB_TABLE_ARTAX_FK1 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_AP_TAX1_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JOB_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JOB_AP_TAX1_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );

cursor cur_JCJOB_DEPT_FK4 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_CC_DEPT_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.DEPT_TABLE T2
                where nvl(T1.JOB_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  and nvl(T1.JOB_CC_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );

cursor cur_JCJOB_TABLE_ARTAX_FK5 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_AR_TAX2_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JOB_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JOB_AR_TAX2_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );

cursor cur_JCJOB_YESNO_FK8 is
  select dc_rownum,
	 JOB_MAKEUP_FLAG
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_MAKEUP_FLAG,T2.YN) = T2.YN );

cursor cur_JCJOB_TABLE_ARTAX_FK4 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_AR_TAX1_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JOB_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JOB_AR_TAX1_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );

cursor cur_JCJOB_YESNO_FK4 is
  select dc_rownum,
	 JOB_SUB_FLAG
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_SUB_FLAG,T2.YN) = T2.YN );

cursor cur_JCJOB_DEPT_FK6 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_UNBILLED_REV_DEPT_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.DEPT_TABLE T2
                where nvl(T1.JOB_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  and nvl(T1.JOB_UNBILLED_REV_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );

cursor cur_JCJOB_YESNO_FK1 is
  select dc_rownum,
	 JOB_PREVAILING_WAGE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_PREVAILING_WAGE,T2.YN) = T2.YN );

cursor cur_JCJOB_JOBBILLMETHOD_FK is
  select dc_rownum,
	 JOB_BILL_METH_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.JOBBILLMETHOD T2
                where nvl(T1.JOB_BILL_METH_CODE,T2.BMETH_CODE) = T2.BMETH_CODE );

cursor cur_JCJOB_TABLE_ARTAX_FK6 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_AR_TAX3_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JOB_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JOB_AR_TAX3_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );

cursor cur_JCJOB_TABLE_ARTAX_FK3 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_AP_TAX3_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.ARTAX T2
                where nvl(T1.JOB_COMP_CODE,T2.ARTAX_COMP_CODE) = T2.ARTAX_COMP_CODE
		  and nvl(T1.JOB_AP_TAX3_CODE,T2.ARTAX_CODE) = T2.ARTAX_CODE );

cursor cur_JCJOB_YESNO_FK2 is
  select dc_rownum,
	 JOB_COST_FLAG
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_COST_FLAG,T2.YN) = T2.YN );

cursor cur_JCJOB_YESNO_FK3 is
  select dc_rownum,
	 JOB_BILL_FLAG
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_BILL_FLAG,T2.YN) = T2.YN );

cursor cur_JCJOB_YESNO_FK5 is
  select dc_rownum,
	 JOB_BUDGCST_SAME_LEVEL_FLAG
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.YESNO T2
                where nvl(T1.JOB_BUDGCST_SAME_LEVEL_FLAG,T2.YN) = T2.YN );

cursor cur_JCJOB_JCACCMETH_FK is
  select dc_rownum,
	 JOB_ACCMETH_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.JCACCMETH T2
                where nvl(T1.JOB_ACCMETH_CODE,T2.METH_CODE) = T2.METH_CODE );

cursor cur_JCJOB_DEPT_FK2 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_LBC_DEPT_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.DEPT_TABLE T2
                where nvl(T1.JOB_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  and nvl(T1.JOB_LBC_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );

cursor cur_JCJOB_JCMETH_FK is
  select dc_rownum,
	 JOB_COST_METH_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.JCMETH T2
                where nvl(T1.JOB_COST_METH_CODE,T2.JCMETH_CODE) = T2.JCMETH_CODE );

cursor cur_JCJOB_JCJOBSIZE_FK is
  select dc_rownum,
	 JOB_SIZE_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.JCJOBSIZE T2
                where nvl(T1.JOB_SIZE_CODE,T2.SIZE_CODE) = T2.SIZE_CODE );

cursor cur_JCJOB_DEPT_FK3 is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_LTC_DEPT_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.DEPT_TABLE T2
                where nvl(T1.JOB_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  and nvl(T1.JOB_LTC_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );

cursor cur_JCJOB_BPCUSTOMERS_FK is
  select dc_rownum,
	 JOB_CUST_CODE,
	 JOB_COMP_CODE
	from DA.DC_JCJOB_TABLE  T1
	where not exists
           (select '1'
              from DA.BPCUSTOMERS T2
                where nvl(T1.JOB_CUST_CODE,T2.BPCUST_BP_CODE) = T2.BPCUST_BP_CODE
		  and nvl(T1.JOB_COMP_CODE,T2.BPCUST_COMP_CODE) = T2.BPCUST_COMP_CODE );

BEGIN
null;
--JCJOB_YESNO_FK7
 for row_dc in cur_JCJOB_YESNO_FK7
loop
  if ( row_dc.JOB_PM_FLAG is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK7',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_PM_FLAG||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_WGTMES_FK
 for row_dc in cur_JCJOB_WGTMES_FK
loop
  if ( row_dc.JOB_WM_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_WGTMES_FK',
                                 'WGTMES_TABLE',
                'Record with '|| ' WM_CODE '||row_dc.JOB_WM_CODE||
		' does not exist in DA.WGTMES_TABLE table.');
 end if;
end loop;
--JCJOB_DEPT_FK5
 for row_dc in cur_JCJOB_DEPT_FK5
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_BILL_DEPT_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_DEPT_FK5',
                                 'DEPT_TABLE',
                'Record with '|| ' DEPT_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' DEPT_CODE '||row_dc.JOB_BILL_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 end if;
end loop;
--JCJOB_CILOCATION_FK
 for row_dc in cur_JCJOB_CILOCATION_FK
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_CILOC_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_CILOCATION_FK',
                                 'CILOCATION',
                'Record with '|| ' CILOC_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' CILOC_CODE '||row_dc.JOB_CILOC_CODE||
		' does not exist in DA.CILOCATION table.');
 end if;
end loop;
--JCJOB_DEPT_FK1
 for row_dc in cur_JCJOB_DEPT_FK1
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_WIP_DEPT_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_DEPT_FK1',
                                 'DEPT_TABLE',
                'Record with '|| ' DEPT_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' DEPT_CODE '||row_dc.JOB_WIP_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 end if;
end loop;
--JCJOB_COMPANY_FK
 for row_dc in cur_JCJOB_COMPANY_FK
loop
  if ( row_dc.JOB_COMP_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_COMPANY_FK',
                                 'COMPANY',
                'Record with '|| ' COMP_CODE '||row_dc.JOB_COMP_CODE||
		' does not exist in DA.COMPANY table.');
 end if;
end loop;
--JCJOB_TABLE_ARTAX_FK2
 for row_dc in cur_JCJOB_TABLE_ARTAX_FK2
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_AP_TAX2_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_TABLE_ARTAX_FK2',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_AP_TAX2_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JCJOB_JCSTATUS_FK
 for row_dc in cur_JCJOB_JCSTATUS_FK
loop
  if ( row_dc.JOB_STATUS_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_JCSTATUS_FK',
                                 'JCSTATUS',
                'Record with '|| ' JCSTATUS_CODE '||row_dc.JOB_STATUS_CODE||
		' does not exist in DA.JCSTATUS table.');
 end if;
end loop;
--JCJOB_YESNO_FK6
 for row_dc in cur_JCJOB_YESNO_FK6
loop
  if ( row_dc.JOB_BID_FLAG is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK6',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_BID_FLAG||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_TABLE_ARTAX_FK1
 for row_dc in cur_JCJOB_TABLE_ARTAX_FK1
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_AP_TAX1_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_TABLE_ARTAX_FK1',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_AP_TAX1_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JCJOB_DEPT_FK4
 for row_dc in cur_JCJOB_DEPT_FK4
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_CC_DEPT_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_DEPT_FK4',
                                 'DEPT_TABLE',
                'Record with '|| ' DEPT_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' DEPT_CODE '||row_dc.JOB_CC_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 end if;
end loop;
--JCJOB_TABLE_ARTAX_FK5
 for row_dc in cur_JCJOB_TABLE_ARTAX_FK5
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_AR_TAX2_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_TABLE_ARTAX_FK5',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_AR_TAX2_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JCJOB_YESNO_FK8
 for row_dc in cur_JCJOB_YESNO_FK8
loop
  if ( row_dc.JOB_MAKEUP_FLAG is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK8',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_MAKEUP_FLAG||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_TABLE_ARTAX_FK4
 for row_dc in cur_JCJOB_TABLE_ARTAX_FK4
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_AR_TAX1_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_TABLE_ARTAX_FK4',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_AR_TAX1_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JCJOB_YESNO_FK4
 for row_dc in cur_JCJOB_YESNO_FK4
loop
  if ( row_dc.JOB_SUB_FLAG is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK4',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_SUB_FLAG||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_DEPT_FK6
 for row_dc in cur_JCJOB_DEPT_FK6
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_UNBILLED_REV_DEPT_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_DEPT_FK6',
                                 'DEPT_TABLE',
                'Record with '|| ' DEPT_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' DEPT_CODE '||row_dc.JOB_UNBILLED_REV_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 end if;
end loop;
--JCJOB_YESNO_FK1
 for row_dc in cur_JCJOB_YESNO_FK1
loop
  if ( row_dc.JOB_PREVAILING_WAGE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK1',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_PREVAILING_WAGE||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_JOBBILLMETHOD_FK
 for row_dc in cur_JCJOB_JOBBILLMETHOD_FK
loop
  if ( row_dc.JOB_BILL_METH_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_JOBBILLMETHOD_FK',
                                 'JOBBILLMETHOD',
                'Record with '|| ' BMETH_CODE '||row_dc.JOB_BILL_METH_CODE||
		' does not exist in DA.JOBBILLMETHOD table.');
 end if;
end loop;
--JCJOB_TABLE_ARTAX_FK6
 for row_dc in cur_JCJOB_TABLE_ARTAX_FK6
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_AR_TAX3_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_TABLE_ARTAX_FK6',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_AR_TAX3_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JCJOB_TABLE_ARTAX_FK3
 for row_dc in cur_JCJOB_TABLE_ARTAX_FK3
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_AP_TAX3_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_TABLE_ARTAX_FK3',
                                 'ARTAX',
                'Record with '|| ' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_AP_TAX3_CODE||
		' does not exist in DA.ARTAX table.');
 end if;
end loop;
--JCJOB_YESNO_FK2
 for row_dc in cur_JCJOB_YESNO_FK2
loop
  if ( row_dc.JOB_COST_FLAG is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK2',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_COST_FLAG||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_YESNO_FK3
 for row_dc in cur_JCJOB_YESNO_FK3
loop
  if ( row_dc.JOB_BILL_FLAG is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK3',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_BILL_FLAG||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_YESNO_FK5
 for row_dc in cur_JCJOB_YESNO_FK5
loop
  if ( row_dc.JOB_BUDGCST_SAME_LEVEL_FLAG is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_YESNO_FK5',
                                 'YESNO',
                'Record with '|| ' YN '||row_dc.JOB_BUDGCST_SAME_LEVEL_FLAG||
		' does not exist in DA.YESNO table.');
 end if;
end loop;
--JCJOB_JCACCMETH_FK
 for row_dc in cur_JCJOB_JCACCMETH_FK
loop
  if ( row_dc.JOB_ACCMETH_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_JCACCMETH_FK',
                                 'JCACCMETH',
                'Record with '|| ' METH_CODE '||row_dc.JOB_ACCMETH_CODE||
		' does not exist in DA.JCACCMETH table.');
 end if;
end loop;
--JCJOB_DEPT_FK2
 for row_dc in cur_JCJOB_DEPT_FK2
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_LBC_DEPT_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_DEPT_FK2',
                                 'DEPT_TABLE',
                'Record with '|| ' DEPT_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' DEPT_CODE '||row_dc.JOB_LBC_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 end if;
end loop;
--JCJOB_JCMETH_FK
 for row_dc in cur_JCJOB_JCMETH_FK
loop
  if ( row_dc.JOB_COST_METH_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_JCMETH_FK',
                                 'JCMETH',
                'Record with '|| ' JCMETH_CODE '||row_dc.JOB_COST_METH_CODE||
		' does not exist in DA.JCMETH table.');
 end if;
end loop;
--JCJOB_JCJOBSIZE_FK
 for row_dc in cur_JCJOB_JCJOBSIZE_FK
loop
  if ( row_dc.JOB_SIZE_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_JCJOBSIZE_FK',
                                 'JCJOBSIZE',
                'Record with '|| ' SIZE_CODE '||row_dc.JOB_SIZE_CODE||
		' does not exist in DA.JCJOBSIZE table.');
 end if;
end loop;
--JCJOB_DEPT_FK3
 for row_dc in cur_JCJOB_DEPT_FK3
loop
  if ( row_dc.JOB_COMP_CODE is not null 
	 and  row_dc.JOB_LTC_DEPT_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_DEPT_FK3',
                                 'DEPT_TABLE',
                'Record with '|| ' DEPT_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' DEPT_CODE '||row_dc.JOB_LTC_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 end if;
end loop;
--JCJOB_BPCUSTOMERS_FK
 for row_dc in cur_JCJOB_BPCUSTOMERS_FK
loop
  if ( row_dc.JOB_CUST_CODE is not null 
	 and  row_dc.JOB_COMP_CODE is not null  ) then
	 da.dbk_dc.error('DC_JCJOB_TABLE',
                                 row_dc.dc_rownum,
                                 'JCJOB_BPCUSTOMERS_FK',
                                 'BPCUSTOMERS',
                'Record with '|| ' BPCUST_BP_CODE '||row_dc.JOB_CUST_CODE||
		','||' BPCUST_COMP_CODE '||row_dc.JOB_COMP_CODE||
		' does not exist in DA.BPCUSTOMERS table.');
 end if;
end loop;

END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--JOB_IB_ALLOW_FLAG_YN - job_ib_allow_flag in ('Y', 'N')
 cursor cur_JOB_IB_ALLOW_FLAG_YN is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not job_ib_allow_flag in ('Y', 'N') ;

--SYS_C009361 - JOB_PREVAILING_WAGE IN ('Y', 'N')
 cursor cur_SYS_C009361 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not JOB_PREVAILING_WAGE IN ('Y', 'N') ;

--SYS_C009360 - JOB_PREVAILING_WAGE IN ('Y', 'N')
 cursor cur_SYS_C009360 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not JOB_PREVAILING_WAGE IN ('Y', 'N') ;

--SYS_C009358 - "JOB_UE_VALID_FLAG" IS NOT NULL
 cursor cur_SYS_C009358 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_UE_VALID_FLAG" IS NOT NULL ;

--SYS_C009351 - "JOB_COMP_CODE" IS NOT NULL
 cursor cur_SYS_C009351 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_COMP_CODE" IS NOT NULL ;

--SYS_C009352 - "JOB_CODE" IS NOT NULL
 cursor cur_SYS_C009352 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_CODE" IS NOT NULL ;

--SYS_C009354 - "JOB_SEC_GROUP" IS NOT NULL
 cursor cur_SYS_C009354 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_SEC_GROUP" IS NOT NULL ;

--JOB_IB_ALLOW_FLAG_NN - "JOB_IB_ALLOW_FLAG" IS NOT NULL
 cursor cur_JOB_IB_ALLOW_FLAG_NN is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_IB_ALLOW_FLAG" IS NOT NULL ;

--SYS_C009355 - "JOB_REVENUE_GEN_STATE" IS NOT NULL
 cursor cur_SYS_C009355 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_REVENUE_GEN_STATE" IS NOT NULL ;

--AVCON_JCJOB_JOB_P_000 - JOB_PREVAILING_WAGE IN ('Y', 'N')
 cursor cur_AVCON_JCJOB_JOB_P_000 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not JOB_PREVAILING_WAGE IN ('Y', 'N') ;

--JOB_IB_FULL_TARIFF_FLAG_YN - job_ib_full_tariff_flag in ('Y', 'N')
 cursor cur_JOB_IB_FULL_TARIFF_FLAG_YN is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not job_ib_full_tariff_flag in ('Y', 'N') ;

--JOB_UE_VALID_FLAG_YN - job_ue_valid_flag IN ('Y', 'N')
 cursor cur_JOB_UE_VALID_FLAG_YN is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not job_ue_valid_flag IN ('Y', 'N') ;

--JOB_OBJECT_ORASEQ_NN - "JOB_OBJECT_ORASEQ" IS NOT NULL
/* cursor cur_JOB_OBJECT_ORASEQ_NN is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_OBJECT_ORASEQ" IS NOT NULL ;
*/

--SYS_C009353 - "JOB_CTRL_CODE" IS NOT NULL
 cursor cur_SYS_C009353 is
        select dc_rownum
          from DA.DC_JCJOB_TABLE
            where not "JOB_CTRL_CODE" IS NOT NULL ;

BEGIN
null;

 for row_dc in cur_JOB_IB_ALLOW_FLAG_YN
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'JOB_IB_ALLOW_FLAG_YN',
                    'JOB_IB_ALLOW_FLAG_YN',
                    'Condition job_ib_allow_flag in (''Y'', ''N'') failed.');
 end loop;

 for row_dc in cur_SYS_C009361
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009361',
                    'SYS_C009361',
                    'Condition JOB_PREVAILING_WAGE IN (''Y'', ''N'') failed.');
 end loop;

 for row_dc in cur_SYS_C009360
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009360',
                    'SYS_C009360',
                    'Condition JOB_PREVAILING_WAGE IN (''Y'', ''N'') failed.');
 end loop;

 for row_dc in cur_SYS_C009358
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009358',
                    'SYS_C009358',
                    'Condition "JOB_UE_VALID_FLAG" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C009351
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009351',
                    'SYS_C009351',
                    'Condition "JOB_COMP_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C009352
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009352',
                    'SYS_C009352',
                    'Condition "JOB_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C009354
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009354',
                    'SYS_C009354',
                    'Condition "JOB_SEC_GROUP" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_JOB_IB_ALLOW_FLAG_NN
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'JOB_IB_ALLOW_FLAG_NN',
                    'JOB_IB_ALLOW_FLAG_NN',
                    'Condition "JOB_IB_ALLOW_FLAG" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C009355
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009355',
                    'SYS_C009355',
                    'Condition "JOB_REVENUE_GEN_STATE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_AVCON_JCJOB_JOB_P_000
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'AVCON_JCJOB_JOB_P_000',
                    'AVCON_JCJOB_JOB_P_000',
                    'Condition JOB_PREVAILING_WAGE IN (''Y'', ''N'') failed.');
 end loop;

 for row_dc in cur_JOB_IB_FULL_TARIFF_FLAG_YN
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'JOB_IB_FULL_TARIFF_FLAG_YN',
                    'JOB_IB_FULL_TARIFF_FLAG_YN',
                    'Condition job_ib_full_tariff_flag in (''Y'', ''N'') failed.');
 end loop;

/* 
for row_dc in cur_JOB_UE_VALID_FLAG_YN
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'JOB_UE_VALID_FLAG_YN',
                    'JOB_UE_VALID_FLAG_YN',
                    'Condition job_ue_valid_flag IN (''Y'', ''N'') failed.');
 end loop;


 for row_dc in cur_JOB_OBJECT_ORASEQ_NN
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'JOB_OBJECT_ORASEQ_NN',
                    'JOB_OBJECT_ORASEQ_NN',
                    'Condition "JOB_OBJECT_ORASEQ" IS NOT NULL failed.');
 end loop;
*/
 for row_dc in cur_SYS_C009353
 loop
    da.dbk_dc.error('DC_JCJOB_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C009353',
                    'SYS_C009353',
                    'Condition "JOB_CTRL_CODE" IS NOT NULL failed.');
 end loop;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.JCJOB_TABLE table
--======================================================================
PROCEDURE IDX_CHECK AS

--JCJOB_PK
cursor cur_JCJOB_PK is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_CODE
    from DA.DC_JCJOB_TABLE S1
      where exists (select '1'
                      from DA.JCJOB_TABLE S2
                        where S1.JOB_COMP_CODE = S2.JOB_COMP_CODE
			  and S1.JOB_CODE = S2.JOB_CODE );
--IJOB_HIER
cursor cur_IJOB_HIER is
  select dc_rownum,
	 JOB_HIER
    from DA.DC_JCJOB_TABLE S1
      where exists (select '1'
                      from DA.JCJOB_TABLE S2
                        where S1.JOB_HIER = S2.JOB_HIER );
--JCJOB_TABLE_UK9
cursor cur_JCJOB_TABLE_UK9 is
  select dc_rownum,
	 JOB_OBJECT_ORASEQ
    from DA.DC_JCJOB_TABLE S1
      where exists (select '1'
                      from DA.JCJOB_TABLE S2
                        where S1.JOB_OBJECT_ORASEQ = S2.JOB_OBJECT_ORASEQ );
BEGIN
 null; 

--JCJOB_PK
 for row_dc in cur_JCJOB_PK
 loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,
                'JCJOB_PK',
                'JCJOB_PK',
                'Record with '||'JOB_COMP_CODE '||row_dc.JOB_COMP_CODE ||
		', '||'JOB_CODE '||row_dc.JOB_CODE ||
		' already exists in DA.JCJOB_TABLE table.');

 end loop;

--IJOB_HIER
 for row_dc in cur_IJOB_HIER
 loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,
                'IJOB_HIER',
                'IJOB_HIER',
                'Record with '||'JOB_HIER '||row_dc.JOB_HIER ||
		' already exists in DA.JCJOB_TABLE table.');

 end loop;

--JCJOB_TABLE_UK9
 for row_dc in cur_JCJOB_TABLE_UK9
 loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,
                'JCJOB_TABLE_UK9',
                'JCJOB_TABLE_UK9',
                'Record with '||'JOB_OBJECT_ORASEQ '||to_char(row_dc.JOB_OBJECT_ORASEQ) ||
		' already exists in DA.JCJOB_TABLE table.');

 end loop;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_JCJOB_TABLE table
--======================================================================
PROCEDURE IDX_DUPL AS

--JCJOB_PK
cursor cur_JCJOB_PK is
  select dc_rownum,
	 JOB_COMP_CODE,
	 JOB_CODE
    from DA.DC_JCJOB_TABLE S1
      where
        exists (select '1'
                  from DA.DC_JCJOB_TABLE S2
                    where S1.JOB_COMP_CODE = S2.JOB_COMP_CODE
		      and S1.JOB_CODE = S2.JOB_CODE
		      and S1.rowid != S2.rowid );
--IJOB_HIER
cursor cur_IJOB_HIER is
  select dc_rownum,
	 JOB_HIER
    from DA.DC_JCJOB_TABLE S1
      where
        exists (select '1'
                  from DA.DC_JCJOB_TABLE S2
                    where S1.JOB_HIER = S2.JOB_HIER
		      and S1.rowid != S2.rowid );
--JCJOB_TABLE_UK9
cursor cur_JCJOB_TABLE_UK9 is
  select dc_rownum,
	 JOB_OBJECT_ORASEQ
    from DA.DC_JCJOB_TABLE S1
      where
        exists (select '1'
                  from DA.DC_JCJOB_TABLE S2
                    where S1.JOB_OBJECT_ORASEQ = S2.JOB_OBJECT_ORASEQ
		      and S1.rowid != S2.rowid );
BEGIN
 null; 

--JCJOB_PK
 for row_dc in cur_JCJOB_PK
 loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,
                'JCJOB_PK',
                'JCJOB_PK',
                'Record with '||'JOB_COMP_CODE '||row_dc.JOB_COMP_CODE ||
		', '||'JOB_CODE '||row_dc.JOB_CODE ||
		' already exists in DA.DC_JCJOB_TABLE table.');
end loop;

--IJOB_HIER
 for row_dc in cur_IJOB_HIER
 loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,
                'IJOB_HIER',
                'IJOB_HIER',
                'Record with '||'JOB_HIER '||row_dc.JOB_HIER ||
		' already exists in DA.DC_JCJOB_TABLE table.');
end loop;

--JCJOB_TABLE_UK9
 for row_dc in cur_JCJOB_TABLE_UK9
 loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,
                'JCJOB_TABLE_UK9',
                'JCJOB_TABLE_UK9',
                'Record with '||'JOB_OBJECT_ORASEQ '||to_char(row_dc.JOB_OBJECT_ORASEQ) ||
		' already exists in DA.DC_JCJOB_TABLE table.');
end loop;
END IDX_DUPL;

--======================================================================
--JOB_COMP_CODE
--======================================================================
PROCEDURE JOB_COMP_CODE AS
  cursor cur_JOB_COMP_CODE is
    select dc_rownum,
           JOB_COMP_CODE
      from DA.DC_JCJOB_TABLE  ;

 t_result        da.apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 for row_dc in cur_JOB_COMP_CODE
 loop
   t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
              row_dc.JOB_COMP_CODE,t_comp_name);
   if ('0' != t_result) then
         da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   end if;
 end loop;
END JOB_COMP_CODE;

--======================================================================
--JOB_CODE
--======================================================================
PROCEDURE JOB_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JCJOB_TABLE
        where JOB_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_CODE',
        'JOB_CODE',
        'JOB_CODE can not be null.');
  end loop;
END JOB_CODE;

--======================================================================
--JOB_CTRL_CODE
--======================================================================
PROCEDURE JOB_CTRL_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JCJOB_TABLE
        where JOB_CTRL_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_CTRL_CODE',
        'JOB_CTRL_CODE',
        'JOB_CTRL_CODE can not be null.');
  end loop;
END JOB_CTRL_CODE;

--======================================================================
--JOB_CTRL_CODE_2
--======================================================================
PROCEDURE JOB_CTRL_CODE_2 AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_COMP_CODE,
	   JOB_CTRL_CODE
		from DA.DC_JCJOB_TABLE T1
		  where nvl(JOB_CTRL_CODE,'xxx') not in ('ALL')
		    and not exists (select '1'
                        from DA.JCJOB_TABLE  T2
                          where T1.JOB_COMP_CODE = T2.JOB_COMP_CODE
			    and T1.JOB_CTRL_CODE = T2.JOB_CODE ) 
		    and not exists (select '1'
                        from DA.DC_JCJOB_TABLE T3
                          where T1.JOB_COMP_CODE = T3.JOB_COMP_CODE
			    and T1.JOB_CTRL_CODE = T3.JOB_CTRL_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_CTRL_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_CTRL_CODE',
                'JCJOB_TABLE',
                'Record with'||
				' JOB_COMP_CODE '||row_dc.JOB_COMP_CODE ||
','||		' JOB_CTRL_CODE '||row_dc.JOB_CTRL_CODE ||
		' does not exist in 
, DA.DC_JCJOB_TABLE tables.'); 
    end if;
 end loop;

END JOB_CTRL_CODE_2;

--======================================================================
--JOB_NAME
--======================================================================
PROCEDURE JOB_NAME AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JCJOB_TABLE
        where JOB_NAME is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_NAME',
        'JOB_NAME',
        'JOB_NAME can not be null.');
  end loop;
END JOB_NAME;

--======================================================================
--WIP_DEPT_CODE_2
--======================================================================
PROCEDURE WIP_DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_WIP_DEPT_CODE
    from DA.DC_JCJOB_TABLE ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_WIP_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_WIP_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END WIP_DEPT_CODE_2;

--======================================================================
--WIP_ACC_CODE
--======================================================================
PROCEDURE WIP_ACC_CODE AS
 t_result        da.apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_WIP_DEPT_CODE,
         JOB_WIP_ACC_CODE
   from  DA.DC_JCJOB_TABLE ;

BEGIN

 for row_dc in cur_acc_code
 loop
   if (row_dc.JOB_WIP_ACC_CODE is not null) then 
    t_result := da.apk_gl_account.chk_by_company_dept(
                        da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.ACCOUNT_ALLOWS_TRANSACTIONS),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_WIP_DEPT_CODE,
                row_dc.JOB_WIP_ACC_CODE,
                t_acc_name);
    if ('0' != t_result)
    then
      da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_WIP_ACC_CODE',
                'ACC_CODE',
                t_result);
    end if; 
  end if;
 end loop;
END WIP_ACC_CODE;

--======================================================================
--LTC_DEPT_CODE_2
--======================================================================
PROCEDURE LTC_DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_LTC_DEPT_CODE
    from DA.DC_JCJOB_TABLE ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_LTC_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_LTC_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END LTC_DEPT_CODE_2;

--======================================================================
--LTC_ACC_CODE
--======================================================================
PROCEDURE LTC_ACC_CODE AS
 t_result        da.apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_LTC_DEPT_CODE,
         JOB_LTC_ACC_CODE
   from  DA.DC_JCJOB_TABLE ;

BEGIN

 for row_dc in cur_acc_code
 loop
    t_result := da.apk_gl_account.chk_by_company_dept(
                        da.apk_util.context(DA.APKC.IS_NOT_NULL,DA.APKC.IS_ON_FILE,DA.APKC.ACCOUNT_ALLOWS_TRANSACTIONS),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_LTC_DEPT_CODE,
                row_dc.JOB_LTC_ACC_CODE,
                t_acc_name);
    if ('0' != t_result)
    then
      da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_LTC_ACC_CODE',
                'ACC_CODE',
                t_result);
    end if; 
 end loop;
END LTC_ACC_CODE;

--======================================================================
--CC_DEPT_CODE_2
--======================================================================
PROCEDURE CC_DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_CC_DEPT_CODE
    from DA.DC_JCJOB_TABLE ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_CC_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_CC_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END CC_DEPT_CODE_2;

--======================================================================
--CC_ACC_CODE
--======================================================================
PROCEDURE CC_ACC_CODE AS
 t_result        da.apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_CC_DEPT_CODE,
         JOB_CC_ACC_CODE
   from  DA.DC_JCJOB_TABLE ;

BEGIN

 for row_dc in cur_acc_code
 loop
    t_result := da.apk_gl_account.chk_by_company_dept(
                        da.apk_util.context(DA.APKC.IS_NOT_NULL,DA.APKC.IS_ON_FILE,DA.APKC.ACCOUNT_ALLOWS_TRANSACTIONS),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_CC_DEPT_CODE,
                row_dc.JOB_CC_ACC_CODE,
                t_acc_name);
    if ('0' != t_result)
    then
      da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_CC_ACC_CODE',
                'ACC_CODE',
                t_result);
    end if; 
 end loop;
END CC_ACC_CODE;

--======================================================================
--BILL_DEPT_CODE_2
--======================================================================
PROCEDURE BILL_DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_BILL_DEPT_CODE
    from DA.DC_JCJOB_TABLE ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_BILL_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_BILL_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END BILL_DEPT_CODE_2;

--======================================================================
--BILL_ACC_CODE
--======================================================================
PROCEDURE BILL_ACC_CODE AS
 t_result        da.apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_BILL_DEPT_CODE,
         JOB_BILL_ACC_CODE
   from  DA.DC_JCJOB_TABLE ;

BEGIN

 for row_dc in cur_acc_code
 loop
   if (row_dc.JOB_BILL_ACC_CODE is not null) then 
    t_result := da.apk_gl_account.chk_by_company_dept(
                        da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.ACCOUNT_ALLOWS_TRANSACTIONS),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_BILL_DEPT_CODE,
                row_dc.JOB_BILL_ACC_CODE,
                t_acc_name);
    if ('0' != t_result)
    then
      da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_BILL_ACC_CODE',
                'ACC_CODE',
                t_result);
    end if; 
  end if;
 end loop;
END BILL_ACC_CODE;

--======================================================================
--COST_METH_CODE
--======================================================================
PROCEDURE COST_METH_CODE AS
  cursor cur_dc is
    select dc_rownum,
           JOB_COST_METH_CODE
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_COST_METH_CODE,'xxxx') not in ('C','B');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_COST_METH_CODE',
        'JOB_COST_METH_CODE',
        'JOB_COST_METH_CODE must be set to ''C'',''B''.');

  end loop;
END COST_METH_CODE;

--======================================================================
--STATUS_CODE
--======================================================================
PROCEDURE STATUS_CODE AS
  cursor cur_dc is
    select dc_rownum,
           JOB_STATUS_CODE
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_STATUS_CODE,'xxxx') not in ('P','I','C');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_STATUS_CODE',
        'JOB_STATUS_CODE',
        'JOB_STATUS_CODE must be set to ''P'',''I'',''C''.');

  end loop;
END STATUS_CODE;

--======================================================================
--JOB_CERTIFY_CODE
--======================================================================
PROCEDURE JOB_CERTIFY_CODE AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_JCJOB_TABLE
        where JOB_CERTIFY_CODE is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_CERTIFY_CODE',
        'JOB_CERTIFY_CODE',
        'JOB_CERTIFY_CODE can not be null.');
  end loop;
END JOB_CERTIFY_CODE;

--======================================================================
--SIZE_CODE
--======================================================================
PROCEDURE SIZE_CODE AS
  cursor cur_dc is
    select dc_rownum,
           JOB_SIZE_CODE
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_SIZE_CODE,'xxxx') not in ('L');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_SIZE_CODE',
        'JOB_SIZE_CODE',
        'JOB_SIZE_CODE must be set to ''L''.');

  end loop;
END SIZE_CODE;

--======================================================================
--COST_FLAG
--======================================================================
PROCEDURE COST_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JOB_COST_FLAG
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_COST_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_COST_FLAG',
        'JOB_COST_FLAG',
        'JOB_COST_FLAG must be set to ''Y'',''N''.');

  end loop;
END COST_FLAG;

--======================================================================
--SEC_GROUP
--======================================================================
PROCEDURE SEC_GROUP AS
  cursor cur_dc is
    select dc_rownum,
           JOB_SEC_GROUP
      from DA.DC_JCJOB_TABLE
        where nvl(to_char(JOB_SEC_GROUP),'xxxx') not in ('10');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_SEC_GROUP',
        'JOB_SEC_GROUP',
        'JOB_SEC_GROUP must be set to ''10''.');

  end loop;
END SEC_GROUP;

--======================================================================
--BUDGCST_SAME_LEVEL_FLAG
--======================================================================
PROCEDURE BUDGCST_SAME_LEVEL_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JOB_BUDGCST_SAME_LEVEL_FLAG
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_BUDGCST_SAME_LEVEL_FLAG,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_BUDGCST_SAME_LEVEL_FLAG',
        'JOB_BUDGCST_SAME_LEVEL_FLAG',
        'JOB_BUDGCST_SAME_LEVEL_FLAG must be set to ''Y''.');

  end loop;
END BUDGCST_SAME_LEVEL_FLAG;

--======================================================================
--WBSV_REQUIRED_FLAG1
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG1 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG1
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG1,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG1',
        'JOB_WBSV_REQUIRED_FLAG1',
        'JOB_WBSV_REQUIRED_FLAG1 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG1;

--======================================================================
--WBSV_REQUIRED_FLAG2
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG2 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG2
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG2,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG2',
        'JOB_WBSV_REQUIRED_FLAG2',
        'JOB_WBSV_REQUIRED_FLAG2 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG2;

--======================================================================
--WBSV_REQUIRED_FLAG3
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG3 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG3
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG3,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG3',
        'JOB_WBSV_REQUIRED_FLAG3',
        'JOB_WBSV_REQUIRED_FLAG3 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG3;

--======================================================================
--WBSV_REQUIRED_FLAG4
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG4 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG4
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG4,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG4',
        'JOB_WBSV_REQUIRED_FLAG4',
        'JOB_WBSV_REQUIRED_FLAG4 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG4;

--======================================================================
--WBSV_REQUIRED_FLAG5
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG5 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG5
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG5,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG5',
        'JOB_WBSV_REQUIRED_FLAG5',
        'JOB_WBSV_REQUIRED_FLAG5 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG5;

--======================================================================
--WBSV_REQUIRED_FLAG6
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG6 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG6
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG6,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG6',
        'JOB_WBSV_REQUIRED_FLAG6',
        'JOB_WBSV_REQUIRED_FLAG6 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG6;

--======================================================================
--WBSV_REQUIRED_FLAG7
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG7 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG7
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG7,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG7',
        'JOB_WBSV_REQUIRED_FLAG7',
        'JOB_WBSV_REQUIRED_FLAG7 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG7;

--======================================================================
--WBSV_REQUIRED_FLAG8
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG8 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG8
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG8,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG8',
        'JOB_WBSV_REQUIRED_FLAG8',
        'JOB_WBSV_REQUIRED_FLAG8 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG8;

--======================================================================
--WBSV_REQUIRED_FLAG9
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG9 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG9
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG9,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG9',
        'JOB_WBSV_REQUIRED_FLAG9',
        'JOB_WBSV_REQUIRED_FLAG9 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG9;

--======================================================================
--WBSV_REQUIRED_FLAG10
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG10 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG10
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG10,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG10',
        'JOB_WBSV_REQUIRED_FLAG10',
        'JOB_WBSV_REQUIRED_FLAG10 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG10;

--======================================================================
--WBSV_REQUIRED_FLAG11
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG11 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG11
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG11,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG11',
        'JOB_WBSV_REQUIRED_FLAG11',
        'JOB_WBSV_REQUIRED_FLAG11 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG11;

--======================================================================
--WBSV_REQUIRED_FLAG12
--======================================================================
PROCEDURE WBSV_REQUIRED_FLAG12 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_REQUIRED_FLAG12
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_REQUIRED_FLAG12,'xxxx') not in ('N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_REQUIRED_FLAG12',
        'JOB_WBSV_REQUIRED_FLAG12',
        'JOB_WBSV_REQUIRED_FLAG12 must be set to ''N''.');

  end loop;
END WBSV_REQUIRED_FLAG12;

--======================================================================
--WBSV_EDITABLE_FLAG1
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG1 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG1
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG1,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG1',
        'JOB_WBSV_EDITABLE_FLAG1',
        'JOB_WBSV_EDITABLE_FLAG1 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG1;

--======================================================================
--WBSV_EDITABLE_FLAG2
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG2 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG2
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG2,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG2',
        'JOB_WBSV_EDITABLE_FLAG2',
        'JOB_WBSV_EDITABLE_FLAG2 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG2;

--======================================================================
--WBSV_EDITABLE_FLAG3
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG3 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG3
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG3,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG3',
        'JOB_WBSV_EDITABLE_FLAG3',
        'JOB_WBSV_EDITABLE_FLAG3 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG3;

--======================================================================
--WBSV_EDITABLE_FLAG4
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG4 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG4
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG4,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG4',
        'JOB_WBSV_EDITABLE_FLAG4',
        'JOB_WBSV_EDITABLE_FLAG4 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG4;

--======================================================================
--WBSV_EDITABLE_FLAG5
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG5 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG5
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG5,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG5',
        'JOB_WBSV_EDITABLE_FLAG5',
        'JOB_WBSV_EDITABLE_FLAG5 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG5;

--======================================================================
--WBSV_EDITABLE_FLAG6
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG6 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG6
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG6,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG6',
        'JOB_WBSV_EDITABLE_FLAG6',
        'JOB_WBSV_EDITABLE_FLAG6 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG6;

--======================================================================
--WBSV_EDITABLE_FLAG7
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG7 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG7
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG7,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG7',
        'JOB_WBSV_EDITABLE_FLAG7',
        'JOB_WBSV_EDITABLE_FLAG7 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG7;

--======================================================================
--WBSV_EDITABLE_FLAG8
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG8 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG8
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG8,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG8',
        'JOB_WBSV_EDITABLE_FLAG8',
        'JOB_WBSV_EDITABLE_FLAG8 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG8;

--======================================================================
--WBSV_EDITABLE_FLAG9
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG9 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG9
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG9,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG9',
        'JOB_WBSV_EDITABLE_FLAG9',
        'JOB_WBSV_EDITABLE_FLAG9 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG9;

--======================================================================
--WBSV_EDITABLE_FLAG10
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG10 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG10
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG10,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG10',
        'JOB_WBSV_EDITABLE_FLAG10',
        'JOB_WBSV_EDITABLE_FLAG10 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG10;

--======================================================================
--WBSV_EDITABLE_FLAG11
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG11 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG11
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG11,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG11',
        'JOB_WBSV_EDITABLE_FLAG11',
        'JOB_WBSV_EDITABLE_FLAG11 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG11;

--======================================================================
--WBSV_EDITABLE_FLAG12
--======================================================================
PROCEDURE WBSV_EDITABLE_FLAG12 AS
  cursor cur_dc is
    select dc_rownum,
           JOB_WBSV_EDITABLE_FLAG12
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_WBSV_EDITABLE_FLAG12,'xxxx') not in ('Y');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_WBSV_EDITABLE_FLAG12',
        'JOB_WBSV_EDITABLE_FLAG12',
        'JOB_WBSV_EDITABLE_FLAG12 must be set to ''Y''.');

  end loop;
END WBSV_EDITABLE_FLAG12;

--======================================================================
--BID_FLAG
--======================================================================
PROCEDURE BID_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JOB_BID_FLAG
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_BID_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_BID_FLAG',
        'JOB_BID_FLAG',
        'JOB_BID_FLAG must be set to ''Y or N''.');

  end loop;
END BID_FLAG;

--======================================================================
--BILL_METH_CODE
--======================================================================
PROCEDURE BILL_METH_CODE AS
  cursor cur_dc is
    select dc_rownum,
           JOB_BILL_METH_CODE
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_BILL_METH_CODE,'xxxx') not in ('JB','AR');
BEGIN
  for row_dc in cur_dc
  loop 
    if ( row_dc.JOB_BILL_METH_CODE is not null ) then 
	 
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_BILL_METH_CODE',
        'JOB_BILL_METH_CODE',
        'JOB_BILL_METH_CODE must be set to ''JB'',''AR'' or NULL.');
    end if; 
  end loop;
END BILL_METH_CODE;

--======================================================================
--REVENUE_GEN_STATE
--======================================================================
PROCEDURE REVENUE_GEN_STATE AS
  cursor cur_dc is
    select dc_rownum,
           JOB_REVENUE_GEN_STATE
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_REVENUE_GEN_STATE,'xxxx') not in ('G','J');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_REVENUE_GEN_STATE',
        'JOB_REVENUE_GEN_STATE',
        'JOB_REVENUE_GEN_STATE must be set to ''G'',''J''.');

  end loop;
END REVENUE_GEN_STATE;

--======================================================================
--PREVAILING_WAGE
--======================================================================
PROCEDURE PREVAILING_WAGE AS
  cursor cur_dc is
    select dc_rownum,
           JOB_PREVAILING_WAGE
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_PREVAILING_WAGE,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_PREVAILING_WAGE',
        'JOB_PREVAILING_WAGE',
        'JOB_PREVAILING_WAGE must be set to ''Y'',''N''.');

  end loop;
END PREVAILING_WAGE;

--======================================================================
--CONT_TYPE_CODE
--======================================================================
PROCEDURE CONT_TYPE_CODE AS
  cursor cur_dc is
    select dc_rownum,
           JOB_CONT_TYPE_CODE
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_CONT_TYPE_CODE,'xxxx') not in ('U','A');
BEGIN
  for row_dc in cur_dc
  loop 
    if ( row_dc.JOB_CONT_TYPE_CODE is not null ) then 
	 
        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_CONT_TYPE_CODE',
        'JOB_CONT_TYPE_CODE',
        'JOB_CONT_TYPE_CODE must be set to ''U'',''A'' or NULL.');
    end if; 
  end loop;
END CONT_TYPE_CODE;

--======================================================================
--JOB_BILLING_TYPE_CODE
--======================================================================
PROCEDURE JOB_BILLING_TYPE_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_BILLING_TYPE_CODE
	from DA.DC_JCJOB_TABLE T1
	  where not exists (select '1'
                        from DA.JBBILLINGTYPE  T2
                          where T1.JOB_BILLING_TYPE_CODE = T2.JBBT_BILLING_TYPE_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_BILLING_TYPE_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_BILLING_TYPE_CODE',
                'JBBILLINGTYPE',
                'Record with'||
		' JBBT_BILLING_TYPE_CODE '||row_dc.JOB_BILLING_TYPE_CODE||
		' does not exist in DA.JBBILLINGTYPE table.'); 
    end if;
 end loop;

END JOB_BILLING_TYPE_CODE;

--======================================================================
--JOB_INVOICE_FORMAT_CODE
--======================================================================
PROCEDURE JOB_INVOICE_FORMAT_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_INVOICE_FORMAT_CODE
	from DA.DC_JCJOB_TABLE T1
	  where not exists (select '1'
                        from DA.JBINVOICE_FORMAT  T2
                          where T1.JOB_INVOICE_FORMAT_CODE = T2.JBIF_INVOICE_FORMAT_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_INVOICE_FORMAT_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_INVOICE_FORMAT_CODE',
                'JBINVOICE_FORMAT',
                'Record with'||
		' JBIF_INVOICE_FORMAT_CODE '||row_dc.JOB_INVOICE_FORMAT_CODE||
		' does not exist in DA.JBINVOICE_FORMAT table.'); 
    end if;
 end loop;

END JOB_INVOICE_FORMAT_CODE;

--======================================================================
--JOB_TERM_CODE
--======================================================================
PROCEDURE JOB_TERM_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_COMP_CODE,
	   JOB_TERM_CODE
	from DA.DC_JCJOB_TABLE T1
	  where not exists (select '1'
                        from DA.TERM  T2
                          where T1.JOB_COMP_CODE = T2.TERM_COMP_CODE
			    and T1.JOB_TERM_CODE = T2.TERM_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_TERM_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_TERM_CODE',
                'TERM',
                'Record with'||
		' TERM_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' TERM_CODE '||row_dc.JOB_TERM_CODE||
		' does not exist in DA.TERM table.'); 
    end if;
 end loop;

END JOB_TERM_CODE;

--======================================================================
--JOB_TAX1_CODE
--======================================================================
PROCEDURE JOB_TAX1_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_COMP_CODE,
	   JOB_TAX1_CODE
	from DA.DC_JCJOB_TABLE T1
	  where not exists (select '1'
                        from DA.ARTAX  T2
                          where T1.JOB_COMP_CODE = T2.ARTAX_COMP_CODE
			    and T1.JOB_TAX1_CODE = T2.ARTAX_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_TAX1_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_TAX1_CODE',
                'ARTAX',
                'Record with'||
		' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_TAX1_CODE||
		' does not exist in DA.ARTAX table.'); 
    end if;
 end loop;

END JOB_TAX1_CODE;

--======================================================================
--JOB_TAX2_CODE
--======================================================================
PROCEDURE JOB_TAX2_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_COMP_CODE,
	   JOB_TAX2_CODE
	from DA.DC_JCJOB_TABLE T1
	  where not exists (select '1'
                        from DA.ARTAX  T2
                          where T1.JOB_COMP_CODE = T2.ARTAX_COMP_CODE
			    and T1.JOB_TAX2_CODE = T2.ARTAX_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_TAX2_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_TAX2_CODE',
                'ARTAX',
                'Record with'||
		' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_TAX2_CODE||
		' does not exist in DA.ARTAX table.'); 
    end if;
 end loop;

END JOB_TAX2_CODE;

--======================================================================
--JOB_TAX3_CODE
--======================================================================
PROCEDURE JOB_TAX3_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_COMP_CODE,
	   JOB_TAX3_CODE
	from DA.DC_JCJOB_TABLE T1
	  where not exists (select '1'
                        from DA.ARTAX  T2
                          where T1.JOB_COMP_CODE = T2.ARTAX_COMP_CODE
			    and T1.JOB_TAX3_CODE = T2.ARTAX_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_TAX3_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_TAX3_CODE',
                'ARTAX',
                'Record with'||
		' ARTAX_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' ARTAX_CODE '||row_dc.JOB_TAX3_CODE||
		' does not exist in DA.ARTAX table.'); 
    end if;
 end loop;

END JOB_TAX3_CODE;

--======================================================================
--USE_PAY_BILL_RATE_FLAG
--======================================================================
PROCEDURE USE_PAY_BILL_RATE_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JOB_USE_PAY_BILL_RATE_FLAG
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_USE_PAY_BILL_RATE_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_USE_PAY_BILL_RATE_FLAG',
        'JOB_USE_PAY_BILL_RATE_FLAG',
        'JOB_USE_PAY_BILL_RATE_FLAG must be set to ''Y'',''N''.');

  end loop;
END USE_PAY_BILL_RATE_FLAG;

--======================================================================
--USE_EQP_BILL_RATE_FLAG
--======================================================================
PROCEDURE USE_EQP_BILL_RATE_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JOB_USE_EQP_BILL_RATE_FLAG
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_USE_EQP_BILL_RATE_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_USE_EQP_BILL_RATE_FLAG',
        'JOB_USE_EQP_BILL_RATE_FLAG',
        'JOB_USE_EQP_BILL_RATE_FLAG must be set to ''Y'',''N''.');

  end loop;
END USE_EQP_BILL_RATE_FLAG;

--======================================================================
--IB_ALLOW_FLAG
--======================================================================
PROCEDURE IB_ALLOW_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JOB_IB_ALLOW_FLAG
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_IB_ALLOW_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_IB_ALLOW_FLAG',
        'JOB_IB_ALLOW_FLAG',
        'JOB_IB_ALLOW_FLAG must be set to ''Y'',''N''.');

  end loop;
END IB_ALLOW_FLAG;

--======================================================================
--JOB_BILLING_RATE_TABLE_CODE
--======================================================================
PROCEDURE JOB_BILLING_RATE_TABLE_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   JOB_COMP_CODE,
	   JOB_BILLING_RATE_TABLE_CODE
	from DA.DC_JCJOB_TABLE T1
	  where not exists (select '1'
                        from DA.JB_BILLING_RATE_HEADER  T2
                          where T1.JOB_COMP_CODE = T2.JBBRH_COMP_CODE
			    and T1.JOB_BILLING_RATE_TABLE_CODE = T2.JBBRH_BILLING_RATE_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.JOB_BILLING_RATE_TABLE_CODE is not null ) then 
	 	da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_BILLING_RATE_TABLE_CODE',
                'JB_BILLING_RATE_HEADER',
                'Record with'||
		' JBBRH_COMP_CODE '||row_dc.JOB_COMP_CODE||
		','||' JBBRH_BILLING_RATE_CODE '||row_dc.JOB_BILLING_RATE_TABLE_CODE||
		' does not exist in DA.JB_BILLING_RATE_HEADER table.'); 
    end if;
 end loop;

END JOB_BILLING_RATE_TABLE_CODE;

--======================================================================
--RESERVE_REV_DEPT_CODE_2
--======================================================================
PROCEDURE RESERVE_REV_DEPT_CODE_2 AS

 t_result        da.apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

cursor cur_dept_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_RESERVE_REV_DEPT_CODE
    from DA.DC_JCJOB_TABLE ;


begin
 for row_dc in cur_dept_code
 loop
  t_result := da.apk_gl_dept.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_RESERVE_REV_DEPT_CODE,
                t_dept_name);
 if (t_result != '0')
 then
    da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_RESERVE_REV_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 end if;

end loop;
END RESERVE_REV_DEPT_CODE_2;

--======================================================================
--RESERVE_REV_ACC_CODE
--======================================================================
PROCEDURE RESERVE_REV_ACC_CODE AS
 t_result        da.apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

cursor cur_acc_code is
  select dc_rownum,
         JOB_COMP_CODE,
         JOB_RESERVE_REV_DEPT_CODE,
         JOB_RESERVE_REV_ACC_CODE
   from  DA.DC_JCJOB_TABLE ;

BEGIN

 for row_dc in cur_acc_code
 loop
    t_result := da.apk_gl_account.chk_by_company_dept(
                        da.apk_util.context(DA.APKC.IS_NOT_NULL,DA.APKC.IS_ON_FILE,DA.APKC.ACCOUNT_ALLOWS_TRANSACTIONS),
                row_dc.JOB_COMP_CODE,
                row_dc.JOB_RESERVE_REV_DEPT_CODE,
                row_dc.JOB_RESERVE_REV_ACC_CODE,
                t_acc_name);
    if ('0' != t_result)
    then
      da.dbk_dc.error('DC_JCJOB_TABLE',
                row_dc.dc_rownum,
                'JOB_RESERVE_REV_ACC_CODE',
                'ACC_CODE',
                t_result);
    end if; 
 end loop;
END RESERVE_REV_ACC_CODE;

--======================================================================
--IB_FULL_TARIFF_FLAG
--======================================================================
PROCEDURE IB_FULL_TARIFF_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           JOB_IB_FULL_TARIFF_FLAG
      from DA.DC_JCJOB_TABLE
        where nvl(JOB_IB_FULL_TARIFF_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 

        da.dbk_dc.error('DC_JCJOB_TABLE',row_dc.dc_rownum,'JOB_IB_FULL_TARIFF_FLAG',
        'JOB_IB_FULL_TARIFF_FLAG',
        'JOB_IB_FULL_TARIFF_FLAG must be set to ''Y'',''N''.');

  end loop;
END IB_FULL_TARIFF_FLAG;

--======================================================================
--VERIFY_DATA - run all verify procedures define for JCJOB_TABLE table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
        display_status(' Delete rows DC_JCJOB_TABLE from DA.DC_ERROR.');
        delete from da.dc_error
          where upper(dcerr_table_name) = 'DC_JCJOB_TABLE' ;

        commit;

        display_status(' INDEX checking in DA.JCJOB_TABLE');
        idx_check;

        commit;

        display_status(' INDEX  checking in DA.DC_JCJOB_TABLE');
        idx_dupl;

        commit;

        display_status(' FOREIGN KEYS checking in DA.DC_JCJOB_TABLE');
        Fk_con;

        commit;

        display_status(' CHECK constraints checking in DA.DC_JCJOB_TABLE');
        check_con;

        commit;


        display_status(' JOB_JOB_COMP_CODE - checking');
        JOB_COMP_CODE;

        commit;

        display_status(' JOB_JOB_CODE - checking');
        JOB_CODE;

        commit;

        display_status(' JOB_JOB_CTRL_CODE - checking');
        JOB_CTRL_CODE;

        commit;

        display_status(' JOB_CTRL_CODE_2 - checking');
        JOB_CTRL_CODE_2;

        commit;

        display_status(' JOB_JOB_NAME - checking');
        JOB_NAME;

        commit;

        display_status(' JOB_WIP_DEPT_CODE_2 - checking');
        WIP_DEPT_CODE_2;

        commit;

        display_status(' JOB_WIP_ACC_CODE - checking');
        WIP_ACC_CODE;

        commit;

        display_status(' JOB_LTC_DEPT_CODE_2 - checking');
        LTC_DEPT_CODE_2;

        commit;

        display_status(' JOB_LTC_ACC_CODE - checking');
        LTC_ACC_CODE;

        commit;

        display_status(' JOB_CC_DEPT_CODE_2 - checking');
        CC_DEPT_CODE_2;

        commit;

        display_status(' JOB_CC_ACC_CODE - checking');
        CC_ACC_CODE;

        commit;

        display_status(' JOB_BILL_DEPT_CODE_2 - checking');
        BILL_DEPT_CODE_2;

        commit;

        display_status(' JOB_BILL_ACC_CODE - checking');
        BILL_ACC_CODE;

        commit;

        display_status(' JOB_COST_METH_CODE - checking');
        COST_METH_CODE;

        commit;

        display_status(' JOB_STATUS_CODE - checking');
        STATUS_CODE;

        commit;

        display_status(' JOB_JOB_CERTIFY_CODE - checking');
        JOB_CERTIFY_CODE;

        commit;

        display_status(' JOB_SIZE_CODE - checking');
        SIZE_CODE;

        commit;

        display_status(' JOB_COST_FLAG - checking');
        COST_FLAG;

        commit;

        display_status(' JOB_SEC_GROUP - checking');
        SEC_GROUP;

        commit;

        display_status(' JOB_BUDGCST_SAME_LEVEL_FLAG - checking');
        BUDGCST_SAME_LEVEL_FLAG;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG1 - checking');
        WBSV_REQUIRED_FLAG1;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG2 - checking');
        WBSV_REQUIRED_FLAG2;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG3 - checking');
        WBSV_REQUIRED_FLAG3;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG4 - checking');
        WBSV_REQUIRED_FLAG4;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG5 - checking');
        WBSV_REQUIRED_FLAG5;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG6 - checking');
        WBSV_REQUIRED_FLAG6;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG7 - checking');
        WBSV_REQUIRED_FLAG7;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG8 - checking');
        WBSV_REQUIRED_FLAG8;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG9 - checking');
        WBSV_REQUIRED_FLAG9;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG10 - checking');
        WBSV_REQUIRED_FLAG10;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG11 - checking');
        WBSV_REQUIRED_FLAG11;

        commit;

        display_status(' JOB_WBSV_REQUIRED_FLAG12 - checking');
        WBSV_REQUIRED_FLAG12;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG1 - checking');
        WBSV_EDITABLE_FLAG1;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG2 - checking');
        WBSV_EDITABLE_FLAG2;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG3 - checking');
        WBSV_EDITABLE_FLAG3;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG4 - checking');
        WBSV_EDITABLE_FLAG4;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG5 - checking');
        WBSV_EDITABLE_FLAG5;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG6 - checking');
        WBSV_EDITABLE_FLAG6;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG7 - checking');
        WBSV_EDITABLE_FLAG7;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG8 - checking');
        WBSV_EDITABLE_FLAG8;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG9 - checking');
        WBSV_EDITABLE_FLAG9;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG10 - checking');
        WBSV_EDITABLE_FLAG10;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG11 - checking');
        WBSV_EDITABLE_FLAG11;

        commit;

        display_status(' JOB_WBSV_EDITABLE_FLAG12 - checking');
        WBSV_EDITABLE_FLAG12;

        commit;

        display_status(' JOB_BID_FLAG - checking');
        BID_FLAG;

        commit;

        display_status(' JOB_BILL_METH_CODE - checking');
        BILL_METH_CODE;

        commit;

        display_status(' JOB_REVENUE_GEN_STATE - checking');
        REVENUE_GEN_STATE;

        commit;

        display_status(' JOB_PREVAILING_WAGE - checking');
        PREVAILING_WAGE;

        commit;

        display_status(' JOB_CONT_TYPE_CODE - checking');
        CONT_TYPE_CODE;

        commit;

        display_status(' JOB_BILLING_TYPE_CODE - checking');
        JOB_BILLING_TYPE_CODE;

        commit;

        display_status(' JOB_INVOICE_FORMAT_CODE - checking');
        JOB_INVOICE_FORMAT_CODE;

        commit;

        display_status(' JOB_TERM_CODE - checking');
        JOB_TERM_CODE;

        commit;

        display_status(' JOB_TAX1_CODE - checking');
        JOB_TAX1_CODE;

        commit;

        display_status(' JOB_TAX2_CODE - checking');
        JOB_TAX2_CODE;

        commit;

        display_status(' JOB_TAX3_CODE - checking');
        JOB_TAX3_CODE;

        commit;

        display_status(' JOB_USE_PAY_BILL_RATE_FLAG - checking');
        USE_PAY_BILL_RATE_FLAG;

        commit;

        display_status(' JOB_USE_EQP_BILL_RATE_FLAG - checking');
        USE_EQP_BILL_RATE_FLAG;

        commit;

        display_status(' JOB_IB_ALLOW_FLAG - checking');
        IB_ALLOW_FLAG;

        commit;

        display_status(' JOB_BILLING_RATE_TABLE_CODE - checking');
        JOB_BILLING_RATE_TABLE_CODE;

        commit;

        display_status(' JOB_RESERVE_REV_DEPT_CODE_2 - checking');
        RESERVE_REV_DEPT_CODE_2;

        commit;

        display_status(' JOB_RESERVE_REV_ACC_CODE - checking');
        RESERVE_REV_ACC_CODE;

        commit;

        display_status(' JOB_IB_FULL_TARIFF_FLAG - checking');
        IB_FULL_TARIFF_FLAG;

        commit;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.JCJOB_TABLE table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_JCJOB_TABLE table
   cursor cur_err_JCJOB_TABLE is
     select count(1)
       from da.dc_error
        where upper(dcerr_table_name) = 'DC_JCJOB_TABLE' ;

   t_num_errors_JCJOB_TABLE         NUMBER;

BEGIN
 open  cur_err_JCJOB_TABLE;
 fetch cur_err_JCJOB_TABLE into t_num_errors_JCJOB_TABLE;
 close cur_err_JCJOB_TABLE;

 display_status('Number of errors in DC_ERROR table for DC_JCJOB_TABLE table :'||
                to_char(t_num_errors_JCJOB_TABLE));

 if ( t_num_errors_JCJOB_TABLE = 0 )
 then

   display_status('Insert into DA.JCJOB_TABLE');


for i in 
(select
 	 JOB_COMP_CODE		--1
	,JOB_CODE		--2
	,JOB_CTRL_CODE		--3
	,JOB_NAME		--4
	,JOB_CUST_CODE		--5
	,JOB_CONTRACT_CODE		--6
	,JOB_WIP_DEPT_CODE		--7
	,JOB_WIP_ACC_CODE		--8
	,JOB_LBC_DEPT_CODE		--9
	,JOB_LBC_ACC_CODE		--10
	,JOB_LTC_DEPT_CODE		--11
	,JOB_LTC_ACC_CODE		--12
	,JOB_CC_DEPT_CODE		--13
	,JOB_CC_ACC_CODE		--14
	,JOB_BILL_DEPT_CODE		--15
	,JOB_BILL_ACC_CODE		--16
	,JOB_BILL_AMT		--17
	,JOB_COST_METH_CODE		--18
	,JOB_STATUS_CODE		--19
	,JOB_ACCMETH_CODE		--20
	,JOB_CERTIFY_CODE		--21
	,JOB_SIZE_CODE		--22
	,JOB_WM_CODE		--23
	,JOB_ACTION_CODE		--24
	,JOB_EST_START_DATE		--25
	,JOB_ACT_START_DATE		--26
	,JOB_EST_COMPL_DATE		--27
	,JOB_ACT_COMPL_DATE		--28
	,JOB_LST_ADDON_DATE		--29
	,JOB_LST_REC_DATE		--30
	,JOB_REC_AMT		--31
	,JOB_HB_REC_AMT		--32
	,JOB_REVREC_AMT		--33
	,JOB_HB_AMT		--34
	,JOB_PROFREC_AMT		--35
	,JOB_LST_REC_PC		--36
	,JOB_LOC_CODE		--37
	,JOB_BUDG_UNIT		--38
	,JOB_COMPL_UNIT		--39
	,JOB_DISB_AMT		--40
	,JOB_REVREC_LST_PC		--41
	,JOB_REVREC_PC		--42
	,JOB_CONTRACT_AMT		--43
	,JOB_COST_FLAG		--44
	,JOB_BILL_FLAG		--45
	,JOB_SUB_FLAG		--46
	,JOB_SEC_GROUP		--47
	,JOB_BUDGCST_SAME_LEVEL_FLAG		--48
	,JOB_WBSV_CODE1		--49
	,JOB_WBSV_CODE2		--50
	,JOB_WBSV_CODE3		--51
	,JOB_WBSV_CODE4		--52
	,JOB_WBSV_CODE5		--53
	,JOB_WBSV_CODE6		--54
	,JOB_WBSV_CODE7		--55
	,JOB_WBSV_CODE8		--56
	,JOB_WBSV_CODE9		--57
	,JOB_WBSV_CODE10		--58
	,JOB_WBSV_CODE11		--59
	,JOB_WBSV_CODE12		--60
	,JOB_WBSV_REQUIRED_FLAG1		--61
	,JOB_WBSV_REQUIRED_FLAG2		--62
	,JOB_WBSV_REQUIRED_FLAG3		--63
	,JOB_WBSV_REQUIRED_FLAG4		--64
	,JOB_WBSV_REQUIRED_FLAG5		--65
	,JOB_WBSV_REQUIRED_FLAG6		--66
	,JOB_WBSV_REQUIRED_FLAG7		--67
	,JOB_WBSV_REQUIRED_FLAG8		--68
	,JOB_WBSV_REQUIRED_FLAG9		--69
	,JOB_WBSV_REQUIRED_FLAG10		--70
	,JOB_WBSV_REQUIRED_FLAG11		--71
	,JOB_WBSV_REQUIRED_FLAG12		--72
	,JOB_WBSV_EDITABLE_FLAG1		--73
	,JOB_WBSV_EDITABLE_FLAG2		--74
	,JOB_WBSV_EDITABLE_FLAG3		--75
	,JOB_WBSV_EDITABLE_FLAG4		--76
	,JOB_WBSV_EDITABLE_FLAG5		--77
	,JOB_WBSV_EDITABLE_FLAG6		--78
	,JOB_WBSV_EDITABLE_FLAG7		--79
	,JOB_WBSV_EDITABLE_FLAG8		--80
	,JOB_WBSV_EDITABLE_FLAG9		--81
	,JOB_WBSV_EDITABLE_FLAG10		--82
	,JOB_WBSV_EDITABLE_FLAG11		--83
	,JOB_WBSV_EDITABLE_FLAG12		--84
	,JOB_BID_FLAG		--85
	,JOB_BID_STATUS_CODE		--86
	,JOB_BID_CODE		--87
	,JOB_MAKEUP_FLAG		--88
	,JOB_PM_FLAG		--89
	,JOB_BILL_METH_CODE		--90
	,JOB_INV_FORMAT_CODE		--91
	,JOB_BID_SUBMIT_DATE		--92
	,JOB_PROPERTY_ID		--93
	,JOB_AREA_DISTRICT		--94
	,JOB_PROVINCE_CODE		--95
	,JOB_REVENUE_GEN_STATE		--96
	,JOB_UNBILLED_REV_DEPT_CODE		--97
	,JOB_UNBILLED_REV_ACC_CODE		--98
	,JOB_HIER		--99
	,JOB_CHG_SEQ_NUM		--100
	,JOB_BUDGR_SEQ_NUM		--101
	,JOB_AUTH_RQ_SEQ_NUM		--102
	,JOB_SI_SEQ_NUM		--103
	,JOB_REVREC_CURR_DATE		--104
	,JOB_REVREC_LST_AMT		--105
	,WORK_LOC		--106
	,JOB_MUTLI_OVHD_PC_FLAG		--107
	,JOB_WORK_LOC		--108
	,JOB_POLICY_NO		--109
	,JOB_PREVAILING_WAGE		--110
	,JOB_PL_POLICY_NO		--111
	,JOB_FULLY_PAID_INVS		--112
	,JOB_DAYS_OUTST_INV_PAID_TTL		--113
	,JOB_RATE_BY_JOB_FLAG		--114
	,JOB_USE_PAY_BILL_RATE_FLAG		--115
	,JOB_USE_EQP_BILL_RATE_FLAG		--116
	,JOB_CUST_CONTACT_NAME		--117
	,JOB_TERM_CODE		--118
	,JOB_INVOICE_GROUP_CODE		--119
	,JOB_BILLING_TYPE_CODE		--120
	,JOB_INVOICE_FORMAT_CODE		--121
	,JOB_CONSTRUCTION_VALUE		--122
	,JOB_MAX_HOURLY_RATE		--123
	,JOB_MAX_BILLING_AMT		--124
	,JOB_MAX_BILLING_BUDGET_AMT		--125
	,JOB_BILLING_RATE_TABLE_CODE		--126
	,JOB_IB_ALLOW_FLAG		--127
	,JOB_IB_FULL_TARIFF_FLAG		--128
	,JOB_CONT_TYPE_CODE		--129
	,JOB_LONG_CODE		--130
	,JOB_RESERVE_REV_DEPT_CODE		--131
	,JOB_RESERVE_REV_ACC_CODE		--132
	,JOB_CONSTRUCTION_VALUE_PCT		--133
	,JOB_MAX_HOURS		--134
	,JOB_CILOC_CODE		--135
	,JOB_JTR_EXP_FLAG		--136
	,JOB_IB_EXPENSE_CAT_CODE		--137
	,JOB_ORIGINAL_CONTRACT_AMT		--138
	,JOB_DEFAULT_DEPT_CODE		--139
	,JOB_AP_TAX1_CODE		--140
	,JOB_AP_TAX2_CODE		--141
	,JOB_AP_TAX3_CODE		--142
	,JOB_AR_TAX1_CODE		--143
	,JOB_AR_TAX2_CODE		--144
	,JOB_AR_TAX3_CODE		--145
	,JOB_JB_MAP_CODE		--146
	,JOB_CAL_SAL_CHARGE_RATE		--147
	,JOB_WIP_OVERRIDE_CONT_AMT		--148
	,JOB_TAX1_CODE		--149
	,JOB_TAX2_CODE		--150
	,JOB_TAX3_CODE		--151
	,JOB_APPLY_DB_RULES		--152
	,JOB_ATTACH_ORASEQ		--153
	-- , PMORASEQ.NEXTVAL		--154
	-- ,JOB_OBJECT_ORASEQ		--154
	,JOB_WIP_ROLL_IN_SUBJOB_FLAG		--155
	,JOB_UE_VALID_FLAG		--156
	,JOB_ALLOW_OVERHEAD_FLAG		--157
	,JOB_COST_TO_COMPL_OVRD_FLG		--158
	,JOB_SHOW_CPR_AS_COST_AMT_FLAG		--159
	,JOB_PHS_TYPE_REQUIRED_FLG		--160
   from DA.DC_JCJOB_TABLE
order by decode(job_ctrl_code,'ALL',1,2),job_code
) loop
     insert into DA.JCJOB_TABLE
        (JOB_COMP_CODE		--1
	,JOB_CODE		--2
	,JOB_CTRL_CODE		--3
	,JOB_NAME		--4
	,JOB_CUST_CODE		--5
	,JOB_CONTRACT_CODE		--6
	,JOB_WIP_DEPT_CODE		--7
	,JOB_WIP_ACC_CODE		--8
	,JOB_LBC_DEPT_CODE		--9
	,JOB_LBC_ACC_CODE		--10
	,JOB_LTC_DEPT_CODE		--11
	,JOB_LTC_ACC_CODE		--12
	,JOB_CC_DEPT_CODE		--13
	,JOB_CC_ACC_CODE		--14
	,JOB_BILL_DEPT_CODE		--15
	,JOB_BILL_ACC_CODE		--16
	,JOB_BILL_AMT		--17
	,JOB_COST_METH_CODE		--18
	,JOB_STATUS_CODE		--19
	,JOB_ACCMETH_CODE		--20
	,JOB_CERTIFY_CODE		--21
	,JOB_SIZE_CODE		--22
	,JOB_WM_CODE		--23
	,JOB_ACTION_CODE		--24
	,JOB_EST_START_DATE		--25
	,JOB_ACT_START_DATE		--26
	,JOB_EST_COMPL_DATE		--27
	,JOB_ACT_COMPL_DATE		--28
	,JOB_LST_ADDON_DATE		--29
	,JOB_LST_REC_DATE		--30
	,JOB_REC_AMT		--31
	,JOB_HB_REC_AMT		--32
	,JOB_REVREC_AMT		--33
	,JOB_HB_AMT		--34
	,JOB_PROFREC_AMT		--35
	,JOB_LST_REC_PC		--36
	,JOB_LOC_CODE		--37
	,JOB_BUDG_UNIT		--38
	,JOB_COMPL_UNIT		--39
	,JOB_DISB_AMT		--40
	,JOB_REVREC_LST_PC		--41
	,JOB_REVREC_PC		--42
	,JOB_CONTRACT_AMT		--43
	,JOB_COST_FLAG		--44
	,JOB_BILL_FLAG		--45
	,JOB_SUB_FLAG		--46
	,JOB_SEC_GROUP		--47
	,JOB_BUDGCST_SAME_LEVEL_FLAG		--48
	,JOB_WBSV_CODE1		--49
	,JOB_WBSV_CODE2		--50
	,JOB_WBSV_CODE3		--51
	,JOB_WBSV_CODE4		--52
	,JOB_WBSV_CODE5		--53
	,JOB_WBSV_CODE6		--54
	,JOB_WBSV_CODE7		--55
	,JOB_WBSV_CODE8		--56
	,JOB_WBSV_CODE9		--57
	,JOB_WBSV_CODE10		--58
	,JOB_WBSV_CODE11		--59
	,JOB_WBSV_CODE12		--60
	,JOB_WBSV_REQUIRED_FLAG1		--61
	,JOB_WBSV_REQUIRED_FLAG2		--62
	,JOB_WBSV_REQUIRED_FLAG3		--63
	,JOB_WBSV_REQUIRED_FLAG4		--64
	,JOB_WBSV_REQUIRED_FLAG5		--65
	,JOB_WBSV_REQUIRED_FLAG6		--66
	,JOB_WBSV_REQUIRED_FLAG7		--67
	,JOB_WBSV_REQUIRED_FLAG8		--68
	,JOB_WBSV_REQUIRED_FLAG9		--69
	,JOB_WBSV_REQUIRED_FLAG10		--70
	,JOB_WBSV_REQUIRED_FLAG11		--71
	,JOB_WBSV_REQUIRED_FLAG12		--72
	,JOB_WBSV_EDITABLE_FLAG1		--73
	,JOB_WBSV_EDITABLE_FLAG2		--74
	,JOB_WBSV_EDITABLE_FLAG3		--75
	,JOB_WBSV_EDITABLE_FLAG4		--76
	,JOB_WBSV_EDITABLE_FLAG5		--77
	,JOB_WBSV_EDITABLE_FLAG6		--78
	,JOB_WBSV_EDITABLE_FLAG7		--79
	,JOB_WBSV_EDITABLE_FLAG8		--80
	,JOB_WBSV_EDITABLE_FLAG9		--81
	,JOB_WBSV_EDITABLE_FLAG10		--82
	,JOB_WBSV_EDITABLE_FLAG11		--83
	,JOB_WBSV_EDITABLE_FLAG12		--84
	,JOB_BID_FLAG		--85
	,JOB_BID_STATUS_CODE		--86
	,JOB_BID_CODE		--87
	,JOB_MAKEUP_FLAG		--88
	,JOB_PM_FLAG		--89
	,JOB_BILL_METH_CODE		--90
	,JOB_INV_FORMAT_CODE		--91
	,JOB_BID_SUBMIT_DATE		--92
	,JOB_PROPERTY_ID		--93
	,JOB_AREA_DISTRICT		--94
	,JOB_PROVINCE_CODE		--95
	,JOB_REVENUE_GEN_STATE		--96
	,JOB_UNBILLED_REV_DEPT_CODE		--97
	,JOB_UNBILLED_REV_ACC_CODE		--98
	,JOB_HIER		--99
	,JOB_CHG_SEQ_NUM		--100
	,JOB_BUDGR_SEQ_NUM		--101
	,JOB_AUTH_RQ_SEQ_NUM		--102
	,JOB_SI_SEQ_NUM		--103
	,JOB_REVREC_CURR_DATE		--104
	,JOB_REVREC_LST_AMT		--105
	,WORK_LOC		--106
	,JOB_MUTLI_OVHD_PC_FLAG		--107
	,JOB_WORK_LOC		--108
	,JOB_POLICY_NO		--109
	,JOB_PREVAILING_WAGE		--110
	,JOB_PL_POLICY_NO		--111
	,JOB_FULLY_PAID_INVS		--112
	,JOB_DAYS_OUTST_INV_PAID_TTL		--113
	,JOB_RATE_BY_JOB_FLAG		--114
	,JOB_USE_PAY_BILL_RATE_FLAG		--115
	,JOB_USE_EQP_BILL_RATE_FLAG		--116
	,JOB_CUST_CONTACT_NAME		--117
	,JOB_TERM_CODE		--118
	,JOB_INVOICE_GROUP_CODE		--119
	,JOB_BILLING_TYPE_CODE		--120
	,JOB_INVOICE_FORMAT_CODE		--121
	,JOB_CONSTRUCTION_VALUE		--122
	,JOB_MAX_HOURLY_RATE		--123
	,JOB_MAX_BILLING_AMT		--124
	,JOB_MAX_BILLING_BUDGET_AMT		--125
	,JOB_BILLING_RATE_TABLE_CODE		--126
	,JOB_IB_ALLOW_FLAG		--127
	,JOB_IB_FULL_TARIFF_FLAG		--128
	,JOB_CONT_TYPE_CODE		--129
	,JOB_LONG_CODE		--130
	,JOB_RESERVE_REV_DEPT_CODE		--131
	,JOB_RESERVE_REV_ACC_CODE		--132
	,JOB_CONSTRUCTION_VALUE_PCT		--133
	,JOB_MAX_HOURS		--134
	,JOB_CILOC_CODE		--135
	,JOB_JTR_EXP_FLAG		--136
	,JOB_IB_EXPENSE_CAT_CODE		--137
	,JOB_ORIGINAL_CONTRACT_AMT		--138
	,JOB_DEFAULT_DEPT_CODE		--139
	,JOB_AP_TAX1_CODE		--140
	,JOB_AP_TAX2_CODE		--141
	,JOB_AP_TAX3_CODE		--142
	,JOB_AR_TAX1_CODE		--143
	,JOB_AR_TAX2_CODE		--144
	,JOB_AR_TAX3_CODE		--145
	,JOB_JB_MAP_CODE		--146
	,JOB_CAL_SAL_CHARGE_RATE		--147
	,JOB_WIP_OVERRIDE_CONT_AMT		--148
	,JOB_TAX1_CODE		--149
	,JOB_TAX2_CODE		--150
	,JOB_TAX3_CODE		--151
	,JOB_APPLY_DB_RULES		--152
	,JOB_ATTACH_ORASEQ		--153
	-- ,JOB_OBJECT_ORASEQ		--154
	,JOB_WIP_ROLL_IN_SUBJOB_FLAG		--155
	,JOB_UE_VALID_FLAG		--156
	,JOB_ALLOW_OVERHEAD_FLAG		--157
	,JOB_COST_TO_COMPL_OVRD_FLG		--158
	,JOB_SHOW_CPR_AS_COST_AMT_FLAG		--159
	,JOB_PHS_TYPE_REQUIRED_FLG		--160
)
values
(
	 i.JOB_COMP_CODE		--1
	,i.job_CODE		--2
	,i.job_CTRL_CODE		--3
	,i.job_NAME		--4
	,i.job_CUST_CODE		--5
	,i.job_CONTRACT_CODE		--6
	,i.job_WIP_DEPT_CODE		--7
	,i.job_WIP_ACC_CODE		--8
	,i.job_LBC_DEPT_CODE		--9
	,i.job_LBC_ACC_CODE		--10
	,i.job_LTC_DEPT_CODE		--11
	,i.job_LTC_ACC_CODE		--12
	,i.job_CC_DEPT_CODE		--13
	,i.job_CC_ACC_CODE		--14
	,i.job_BILL_DEPT_CODE		--15
	,i.job_BILL_ACC_CODE		--16
	,i.job_BILL_AMT		--17
	,i.job_COST_METH_CODE		--18
	,i.job_STATUS_CODE		--19
	,i.job_ACCMETH_CODE		--20
	,i.job_CERTIFY_CODE		--21
	,i.job_SIZE_CODE		--22
	,i.job_WM_CODE		--23
	,i.job_ACTION_CODE		--24
	,i.job_EST_START_DATE		--25
	,i.job_ACT_START_DATE		--26
	,i.job_EST_COMPL_DATE		--27
	,i.job_ACT_COMPL_DATE		--28
	,i.job_LST_ADDON_DATE		--29
	,i.job_LST_REC_DATE		--30
	,i.job_REC_AMT		--31
	,i.job_HB_REC_AMT		--32
	,i.job_REVREC_AMT		--33
	,i.job_HB_AMT		--34
	,i.job_PROFREC_AMT		--35
	,i.job_LST_REC_PC		--36
	,i.job_LOC_CODE		--37
	,i.job_BUDG_UNIT		--38
	,i.job_COMPL_UNIT		--39
	,i.job_DISB_AMT		--40
	,i.job_REVREC_LST_PC		--41
	,i.job_REVREC_PC		--42
	,i.job_CONTRACT_AMT		--43
	,i.job_COST_FLAG		--44
	,i.job_BILL_FLAG		--45
	,i.job_SUB_FLAG		--46
	,i.job_SEC_GROUP		--47
	,i.job_BUDGCST_SAME_LEVEL_FLAG		--48
	,i.job_WBSV_CODE1		--49
	,i.job_WBSV_CODE2		--50
	,i.job_WBSV_CODE3		--51
	,i.job_WBSV_CODE4		--52
	,i.job_WBSV_CODE5		--53
	,i.job_WBSV_CODE6		--54
	,i.job_WBSV_CODE7		--55
	,i.job_WBSV_CODE8		--56
	,i.job_WBSV_CODE9		--57
	,i.job_WBSV_CODE10		--58
	,i.job_WBSV_CODE11		--59
	,i.job_WBSV_CODE12		--60
	,i.job_WBSV_REQUIRED_FLAG1		--61
	,i.job_WBSV_REQUIRED_FLAG2		--62
	,i.job_WBSV_REQUIRED_FLAG3		--63
	,i.job_WBSV_REQUIRED_FLAG4		--64
	,i.job_WBSV_REQUIRED_FLAG5		--65
	,i.job_WBSV_REQUIRED_FLAG6		--66
	,i.job_WBSV_REQUIRED_FLAG7		--67
	,i.job_WBSV_REQUIRED_FLAG8		--68
	,i.job_WBSV_REQUIRED_FLAG9		--69
	,i.job_WBSV_REQUIRED_FLAG10		--70
	,i.job_WBSV_REQUIRED_FLAG11		--71
	,i.job_WBSV_REQUIRED_FLAG12		--72
	,i.job_WBSV_EDITABLE_FLAG1		--73
	,i.job_WBSV_EDITABLE_FLAG2		--74
	,i.job_WBSV_EDITABLE_FLAG3		--75
	,i.job_WBSV_EDITABLE_FLAG4		--76
	,i.job_WBSV_EDITABLE_FLAG5		--77
	,i.job_WBSV_EDITABLE_FLAG6		--78
	,i.job_WBSV_EDITABLE_FLAG7		--79
	,i.job_WBSV_EDITABLE_FLAG8		--80
	,i.job_WBSV_EDITABLE_FLAG9		--81
	,i.job_WBSV_EDITABLE_FLAG10		--82
	,i.job_WBSV_EDITABLE_FLAG11		--83
	,i.job_WBSV_EDITABLE_FLAG12		--84
	,i.job_BID_FLAG		--85
	,i.job_BID_STATUS_CODE		--86
	,i.job_BID_CODE		--87
	,i.job_MAKEUP_FLAG		--88
	,i.job_PM_FLAG		--89
	,i.job_BILL_METH_CODE		--90
	,i.job_INV_FORMAT_CODE		--91
	,i.job_BID_SUBMIT_DATE		--92
	,i.job_PROPERTY_ID		--93
	,i.job_AREA_DISTRICT		--94
	,i.job_PROVINCE_CODE		--95
	,i.job_REVENUE_GEN_STATE		--96
	,i.job_UNBILLED_REV_DEPT_CODE		--97
	,i.job_UNBILLED_REV_ACC_CODE		--98
	,i.job_HIER		--99
	,i.job_CHG_SEQ_NUM		--100
	,i.job_BUDGR_SEQ_NUM		--101
	,i.job_AUTH_RQ_SEQ_NUM		--102
	,i.job_SI_SEQ_NUM		--103
	,i.job_REVREC_CURR_DATE		--104
	,i.job_REVREC_LST_AMT		--105
	,i.WORK_LOC		--106
	,i.job_MUTLI_OVHD_PC_FLAG		--107
	,i.job_WORK_LOC		--108
	,i.job_POLICY_NO		--109
	,i.job_PREVAILING_WAGE		--110
	,i.job_PL_POLICY_NO		--111
	,i.job_FULLY_PAID_INVS		--112
	,i.job_DAYS_OUTST_INV_PAID_TTL		--113
	,i.job_RATE_BY_JOB_FLAG		--114
	,i.job_USE_PAY_BILL_RATE_FLAG		--115
	,i.job_USE_EQP_BILL_RATE_FLAG		--116
	,i.job_CUST_CONTACT_NAME		--117
	,i.job_TERM_CODE		--118
	,i.job_INVOICE_GROUP_CODE		--119
	,i.job_BILLING_TYPE_CODE		--120
	,i.job_INVOICE_FORMAT_CODE		--121
	,i.job_CONSTRUCTION_VALUE		--122
	,i.job_MAX_HOURLY_RATE		--123
	,i.job_MAX_BILLING_AMT		--124
	,i.job_MAX_BILLING_BUDGET_AMT		--125
	,i.job_BILLING_RATE_TABLE_CODE		--126
	,i.job_IB_ALLOW_FLAG		--127
	,i.job_IB_FULL_TARIFF_FLAG		--128
	,i.job_CONT_TYPE_CODE		--129
	,i.job_LONG_CODE		--130
	,i.job_RESERVE_REV_DEPT_CODE		--131
	,i.job_RESERVE_REV_ACC_CODE		--132
	,i.job_CONSTRUCTION_VALUE_PCT		--133
	,i.job_MAX_HOURS		--134
	,i.job_CILOC_CODE		--135
	,i.job_JTR_EXP_FLAG		--136
	,i.job_IB_EXPENSE_CAT_CODE		--137
	,i.job_ORIGINAL_CONTRACT_AMT		--138
	,i.job_DEFAULT_DEPT_CODE		--139
	,i.job_AP_TAX1_CODE		--140
	,i.job_AP_TAX2_CODE		--141
	,i.job_AP_TAX3_CODE		--142
	,i.job_AR_TAX1_CODE		--143
	,i.job_AR_TAX2_CODE		--144
	,i.job_AR_TAX3_CODE		--145
	,i.job_JB_MAP_CODE		--146
	,i.job_CAL_SAL_CHARGE_RATE		--147
	,i.job_WIP_OVERRIDE_CONT_AMT		--148
	,i.job_TAX1_CODE		--149
	,i.job_TAX2_CODE		--150
	,i.job_TAX3_CODE		--151
	,i.job_APPLY_DB_RULES		--152
	,i.job_ATTACH_ORASEQ		--153
	-- , PMORASEQ.NEXTVAL		--154
	-- ,i.job_OBJECT_ORASEQ		--154
	,i.job_WIP_ROLL_IN_SUBJOB_FLAG		--155
	,i.job_UE_VALID_FLAG		--156
	,i.job_allow_overhead_flag	--157
	,i.JOB_COST_TO_COMPL_OVRD_FLG		--158
	,i.JOB_SHOW_CPR_AS_COST_AMT_FLAG		--159
	,i.JOB_PHS_TYPE_REQUIRED_FLG		--160
);
end loop;

/*

     insert into DA.JCJOB_TABLE
        (JOB_COMP_CODE		--1
	,JOB_CODE		--2
	,JOB_CTRL_CODE		--3
	,JOB_NAME		--4
	,JOB_CUST_CODE		--5
	,JOB_CONTRACT_CODE		--6
	,JOB_WIP_DEPT_CODE		--7
	,JOB_WIP_ACC_CODE		--8
	,JOB_LBC_DEPT_CODE		--9
	,JOB_LBC_ACC_CODE		--10
	,JOB_LTC_DEPT_CODE		--11
	,JOB_LTC_ACC_CODE		--12
	,JOB_CC_DEPT_CODE		--13
	,JOB_CC_ACC_CODE		--14
	,JOB_BILL_DEPT_CODE		--15
	,JOB_BILL_ACC_CODE		--16
	,JOB_BILL_AMT		--17
	,JOB_COST_METH_CODE		--18
	,JOB_STATUS_CODE		--19
	,JOB_ACCMETH_CODE		--20
	,JOB_CERTIFY_CODE		--21
	,JOB_SIZE_CODE		--22
	,JOB_WM_CODE		--23
	,JOB_ACTION_CODE		--24
	,JOB_EST_START_DATE		--25
	,JOB_ACT_START_DATE		--26
	,JOB_EST_COMPL_DATE		--27
	,JOB_ACT_COMPL_DATE		--28
	,JOB_LST_ADDON_DATE		--29
	,JOB_LST_REC_DATE		--30
	,JOB_REC_AMT		--31
	,JOB_HB_REC_AMT		--32
	,JOB_REVREC_AMT		--33
	,JOB_HB_AMT		--34
	,JOB_PROFREC_AMT		--35
	,JOB_LST_REC_PC		--36
	,JOB_LOC_CODE		--37
	,JOB_BUDG_UNIT		--38
	,JOB_COMPL_UNIT		--39
	,JOB_DISB_AMT		--40
	,JOB_REVREC_LST_PC		--41
	,JOB_REVREC_PC		--42
	,JOB_CONTRACT_AMT		--43
	,JOB_COST_FLAG		--44
	,JOB_BILL_FLAG		--45
	,JOB_SUB_FLAG		--46
	,JOB_SEC_GROUP		--47
	,JOB_BUDGCST_SAME_LEVEL_FLAG		--48
	,JOB_WBSV_CODE1		--49
	,JOB_WBSV_CODE2		--50
	,JOB_WBSV_CODE3		--51
	,JOB_WBSV_CODE4		--52
	,JOB_WBSV_CODE5		--53
	,JOB_WBSV_CODE6		--54
	,JOB_WBSV_CODE7		--55
	,JOB_WBSV_CODE8		--56
	,JOB_WBSV_CODE9		--57
	,JOB_WBSV_CODE10		--58
	,JOB_WBSV_CODE11		--59
	,JOB_WBSV_CODE12		--60
	,JOB_WBSV_REQUIRED_FLAG1		--61
	,JOB_WBSV_REQUIRED_FLAG2		--62
	,JOB_WBSV_REQUIRED_FLAG3		--63
	,JOB_WBSV_REQUIRED_FLAG4		--64
	,JOB_WBSV_REQUIRED_FLAG5		--65
	,JOB_WBSV_REQUIRED_FLAG6		--66
	,JOB_WBSV_REQUIRED_FLAG7		--67
	,JOB_WBSV_REQUIRED_FLAG8		--68
	,JOB_WBSV_REQUIRED_FLAG9		--69
	,JOB_WBSV_REQUIRED_FLAG10		--70
	,JOB_WBSV_REQUIRED_FLAG11		--71
	,JOB_WBSV_REQUIRED_FLAG12		--72
	,JOB_WBSV_EDITABLE_FLAG1		--73
	,JOB_WBSV_EDITABLE_FLAG2		--74
	,JOB_WBSV_EDITABLE_FLAG3		--75
	,JOB_WBSV_EDITABLE_FLAG4		--76
	,JOB_WBSV_EDITABLE_FLAG5		--77
	,JOB_WBSV_EDITABLE_FLAG6		--78
	,JOB_WBSV_EDITABLE_FLAG7		--79
	,JOB_WBSV_EDITABLE_FLAG8		--80
	,JOB_WBSV_EDITABLE_FLAG9		--81
	,JOB_WBSV_EDITABLE_FLAG10		--82
	,JOB_WBSV_EDITABLE_FLAG11		--83
	,JOB_WBSV_EDITABLE_FLAG12		--84
	,JOB_BID_FLAG		--85
	,JOB_BID_STATUS_CODE		--86
	,JOB_BID_CODE		--87
	,JOB_MAKEUP_FLAG		--88
	,JOB_PM_FLAG		--89
	,JOB_BILL_METH_CODE		--90
	,JOB_INV_FORMAT_CODE		--91
	,JOB_BID_SUBMIT_DATE		--92
	,JOB_PROPERTY_ID		--93
	,JOB_AREA_DISTRICT		--94
	,JOB_PROVINCE_CODE		--95
	,JOB_REVENUE_GEN_STATE		--96
	,JOB_UNBILLED_REV_DEPT_CODE		--97
	,JOB_UNBILLED_REV_ACC_CODE		--98
	,JOB_HIER		--99
	,JOB_CHG_SEQ_NUM		--100
	,JOB_BUDGR_SEQ_NUM		--101
	,JOB_AUTH_RQ_SEQ_NUM		--102
	,JOB_SI_SEQ_NUM		--103
	,JOB_REVREC_CURR_DATE		--104
	,JOB_REVREC_LST_AMT		--105
	,WORK_LOC		--106
	,JOB_MUTLI_OVHD_PC_FLAG		--107
	,JOB_WORK_LOC		--108
	,JOB_POLICY_NO		--109
	,JOB_PREVAILING_WAGE		--110
	,JOB_PL_POLICY_NO		--111
	,JOB_FULLY_PAID_INVS		--112
	,JOB_DAYS_OUTST_INV_PAID_TTL		--113
	,JOB_RATE_BY_JOB_FLAG		--114
	,JOB_USE_PAY_BILL_RATE_FLAG		--115
	,JOB_USE_EQP_BILL_RATE_FLAG		--116
	,JOB_CUST_CONTACT_NAME		--117
	,JOB_TERM_CODE		--118
	,JOB_INVOICE_GROUP_CODE		--119
	,JOB_BILLING_TYPE_CODE		--120
	,JOB_INVOICE_FORMAT_CODE		--121
	,JOB_CONSTRUCTION_VALUE		--122
	,JOB_MAX_HOURLY_RATE		--123
	,JOB_MAX_BILLING_AMT		--124
	,JOB_MAX_BILLING_BUDGET_AMT		--125
	,JOB_BILLING_RATE_TABLE_CODE		--126
	,JOB_IB_ALLOW_FLAG		--127
	,JOB_IB_FULL_TARIFF_FLAG		--128
	,JOB_CONT_TYPE_CODE		--129
	,JOB_LONG_CODE		--130
	,JOB_RESERVE_REV_DEPT_CODE		--131
	,JOB_RESERVE_REV_ACC_CODE		--132
	,JOB_CONSTRUCTION_VALUE_PCT		--133
	,JOB_MAX_HOURS		--134
	,JOB_CILOC_CODE		--135
	,JOB_JTR_EXP_FLAG		--136
	,JOB_IB_EXPENSE_CAT_CODE		--137
	,JOB_ORIGINAL_CONTRACT_AMT		--138
	,JOB_DEFAULT_DEPT_CODE		--139
	,JOB_AP_TAX1_CODE		--140
	,JOB_AP_TAX2_CODE		--141
	,JOB_AP_TAX3_CODE		--142
	,JOB_AR_TAX1_CODE		--143
	,JOB_AR_TAX2_CODE		--144
	,JOB_AR_TAX3_CODE		--145
	,JOB_JB_MAP_CODE		--146
	,JOB_CAL_SAL_CHARGE_RATE		--147
	,JOB_WIP_OVERRIDE_CONT_AMT		--148
	,JOB_TAX1_CODE		--149
	,JOB_TAX2_CODE		--150
	,JOB_TAX3_CODE		--151
	,JOB_APPLY_DB_RULES		--152
	,JOB_ATTACH_ORASEQ		--153
	-- ,JOB_OBJECT_ORASEQ		--154
	,JOB_WIP_ROLL_IN_SUBJOB_FLAG		--155
	,JOB_UE_VALID_FLAG		--156
	,JOB_ALLOW_OVERHEAD_FLAG		--157
	,JOB_COST_TO_COMPL_OVRD_FLG		--158
	,JOB_SHOW_CPR_AS_COST_AMT_FLAG		--159
	,JOB_PHS_TYPE_REQUIRED_FLG		--160
) select
	JOB_COMP_CODE		--1
	,JOB_CODE		--2
	,JOB_CTRL_CODE		--3
	,JOB_NAME		--4
	,JOB_CUST_CODE		--5
	,JOB_CONTRACT_CODE		--6
	,JOB_WIP_DEPT_CODE		--7
	,JOB_WIP_ACC_CODE		--8
	,JOB_LBC_DEPT_CODE		--9
	,JOB_LBC_ACC_CODE		--10
	,JOB_LTC_DEPT_CODE		--11
	,JOB_LTC_ACC_CODE		--12
	,JOB_CC_DEPT_CODE		--13
	,JOB_CC_ACC_CODE		--14
	,JOB_BILL_DEPT_CODE		--15
	,JOB_BILL_ACC_CODE		--16
	,JOB_BILL_AMT		--17
	,JOB_COST_METH_CODE		--18
	,JOB_STATUS_CODE		--19
	,JOB_ACCMETH_CODE		--20
	,JOB_CERTIFY_CODE		--21
	,JOB_SIZE_CODE		--22
	,JOB_WM_CODE		--23
	,JOB_ACTION_CODE		--24
	,JOB_EST_START_DATE		--25
	,JOB_ACT_START_DATE		--26
	,JOB_EST_COMPL_DATE		--27
	,JOB_ACT_COMPL_DATE		--28
	,JOB_LST_ADDON_DATE		--29
	,JOB_LST_REC_DATE		--30
	,JOB_REC_AMT		--31
	,JOB_HB_REC_AMT		--32
	,JOB_REVREC_AMT		--33
	,JOB_HB_AMT		--34
	,JOB_PROFREC_AMT		--35
	,JOB_LST_REC_PC		--36
	,JOB_LOC_CODE		--37
	,JOB_BUDG_UNIT		--38
	,JOB_COMPL_UNIT		--39
	,JOB_DISB_AMT		--40
	,JOB_REVREC_LST_PC		--41
	,JOB_REVREC_PC		--42
	,JOB_CONTRACT_AMT		--43
	,JOB_COST_FLAG		--44
	,JOB_BILL_FLAG		--45
	,JOB_SUB_FLAG		--46
	,JOB_SEC_GROUP		--47
	,JOB_BUDGCST_SAME_LEVEL_FLAG		--48
	,JOB_WBSV_CODE1		--49
	,JOB_WBSV_CODE2		--50
	,JOB_WBSV_CODE3		--51
	,JOB_WBSV_CODE4		--52
	,JOB_WBSV_CODE5		--53
	,JOB_WBSV_CODE6		--54
	,JOB_WBSV_CODE7		--55
	,JOB_WBSV_CODE8		--56
	,JOB_WBSV_CODE9		--57
	,JOB_WBSV_CODE10		--58
	,JOB_WBSV_CODE11		--59
	,JOB_WBSV_CODE12		--60
	,JOB_WBSV_REQUIRED_FLAG1		--61
	,JOB_WBSV_REQUIRED_FLAG2		--62
	,JOB_WBSV_REQUIRED_FLAG3		--63
	,JOB_WBSV_REQUIRED_FLAG4		--64
	,JOB_WBSV_REQUIRED_FLAG5		--65
	,JOB_WBSV_REQUIRED_FLAG6		--66
	,JOB_WBSV_REQUIRED_FLAG7		--67
	,JOB_WBSV_REQUIRED_FLAG8		--68
	,JOB_WBSV_REQUIRED_FLAG9		--69
	,JOB_WBSV_REQUIRED_FLAG10		--70
	,JOB_WBSV_REQUIRED_FLAG11		--71
	,JOB_WBSV_REQUIRED_FLAG12		--72
	,JOB_WBSV_EDITABLE_FLAG1		--73
	,JOB_WBSV_EDITABLE_FLAG2		--74
	,JOB_WBSV_EDITABLE_FLAG3		--75
	,JOB_WBSV_EDITABLE_FLAG4		--76
	,JOB_WBSV_EDITABLE_FLAG5		--77
	,JOB_WBSV_EDITABLE_FLAG6		--78
	,JOB_WBSV_EDITABLE_FLAG7		--79
	,JOB_WBSV_EDITABLE_FLAG8		--80
	,JOB_WBSV_EDITABLE_FLAG9		--81
	,JOB_WBSV_EDITABLE_FLAG10		--82
	,JOB_WBSV_EDITABLE_FLAG11		--83
	,JOB_WBSV_EDITABLE_FLAG12		--84
	,JOB_BID_FLAG		--85
	,JOB_BID_STATUS_CODE		--86
	,JOB_BID_CODE		--87
	,JOB_MAKEUP_FLAG		--88
	,JOB_PM_FLAG		--89
	,JOB_BILL_METH_CODE		--90
	,JOB_INV_FORMAT_CODE		--91
	,JOB_BID_SUBMIT_DATE		--92
	,JOB_PROPERTY_ID		--93
	,JOB_AREA_DISTRICT		--94
	,JOB_PROVINCE_CODE		--95
	,JOB_REVENUE_GEN_STATE		--96
	,JOB_UNBILLED_REV_DEPT_CODE		--97
	,JOB_UNBILLED_REV_ACC_CODE		--98
	,JOB_HIER		--99
	,JOB_CHG_SEQ_NUM		--100
	,JOB_BUDGR_SEQ_NUM		--101
	,JOB_AUTH_RQ_SEQ_NUM		--102
	,JOB_SI_SEQ_NUM		--103
	,JOB_REVREC_CURR_DATE		--104
	,JOB_REVREC_LST_AMT		--105
	,WORK_LOC		--106
	,JOB_MUTLI_OVHD_PC_FLAG		--107
	,JOB_WORK_LOC		--108
	,JOB_POLICY_NO		--109
	,JOB_PREVAILING_WAGE		--110
	,JOB_PL_POLICY_NO		--111
	,JOB_FULLY_PAID_INVS		--112
	,JOB_DAYS_OUTST_INV_PAID_TTL		--113
	,JOB_RATE_BY_JOB_FLAG		--114
	,JOB_USE_PAY_BILL_RATE_FLAG		--115
	,JOB_USE_EQP_BILL_RATE_FLAG		--116
	,JOB_CUST_CONTACT_NAME		--117
	,JOB_TERM_CODE		--118
	,JOB_INVOICE_GROUP_CODE		--119
	,JOB_BILLING_TYPE_CODE		--120
	,JOB_INVOICE_FORMAT_CODE		--121
	,JOB_CONSTRUCTION_VALUE		--122
	,JOB_MAX_HOURLY_RATE		--123
	,JOB_MAX_BILLING_AMT		--124
	,JOB_MAX_BILLING_BUDGET_AMT		--125
	,JOB_BILLING_RATE_TABLE_CODE		--126
	,JOB_IB_ALLOW_FLAG		--127
	,JOB_IB_FULL_TARIFF_FLAG		--128
	,JOB_CONT_TYPE_CODE		--129
	,JOB_LONG_CODE		--130
	,JOB_RESERVE_REV_DEPT_CODE		--131
	,JOB_RESERVE_REV_ACC_CODE		--132
	,JOB_CONSTRUCTION_VALUE_PCT		--133
	,JOB_MAX_HOURS		--134
	,JOB_CILOC_CODE		--135
	,JOB_JTR_EXP_FLAG		--136
	,JOB_IB_EXPENSE_CAT_CODE		--137
	,JOB_ORIGINAL_CONTRACT_AMT		--138
	,JOB_DEFAULT_DEPT_CODE		--139
	,JOB_AP_TAX1_CODE		--140
	,JOB_AP_TAX2_CODE		--141
	,JOB_AP_TAX3_CODE		--142
	,JOB_AR_TAX1_CODE		--143
	,JOB_AR_TAX2_CODE		--144
	,JOB_AR_TAX3_CODE		--145
	,JOB_JB_MAP_CODE		--146
	,JOB_CAL_SAL_CHARGE_RATE		--147
	,JOB_WIP_OVERRIDE_CONT_AMT		--148
	,JOB_TAX1_CODE		--149
	,JOB_TAX2_CODE		--150
	,JOB_TAX3_CODE		--151
	,JOB_APPLY_DB_RULES		--152
	,JOB_ATTACH_ORASEQ		--153
	-- , PMORASEQ.NEXTVAL		--154
	-- ,JOB_OBJECT_ORASEQ		--154
	,JOB_WIP_ROLL_IN_SUBJOB_FLAG		--155
	,JOB_UE_VALID_FLAG		--156
	,JOB_ALLOW_OVERHEAD_FLAG		--157
	,JOB_COST_TO_COMPL_OVRD_FLG		--158
	,JOB_SHOW_CPR_AS_COST_AMT_FLAG		--159
	,JOB_PHS_TYPE_REQUIRED_FLG		--160
   from DA.DC_JCJOB_TABLE;
*/
  --delete everything from DA.DC_JCJOB_TABLE
    display_status('Delete rows from DA.DC_JCJOB_TABLE table.');
    delete from DA.DC_JCJOB_TABLE;
    display_status('Number of records deleted from DA.DC_JCJOB_TABLE table:'||to_char(SQL%rowcount));

     display_status('JCJOB_TABLE moving from temp table was successful.');
--     commit;

 end if; /*    if nvl(t_num_errors_JCJOB_TABLE,0) = 0 */

exception when others
     then
       display_status('Can not move data from DA.DC_JCJOB_TABLE into DA.JCJOB_TABLE.');
       da.dbk_dc.output(SQLERRM);
       rollback;
       raise;

END Process_temp_data ;

END DBK_DC_JCJOB_TABLE;
/
show error
/
