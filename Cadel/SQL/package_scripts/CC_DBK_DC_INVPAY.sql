CREATE OR REPLACE PACKAGE    CC_DBK_DC_INVPAY AS

 PROCEDURE Verify_data;

 PROCEDURE Process_Temp_Data;

 PROCEDURE Idx_check;

 PROCEDURE Idx_dupl;

 PROCEDURE Fk_con;

 PROCEDURE Check_con;


 PROCEDURE COMP_CODE;

 PROCEDURE INV_COMP_CODE;

 PROCEDURE IPAY_INV_NUM;

 PROCEDURE IPAY_INV_NUM_2;

 PROCEDURE IPAY_SEQ_NUM;

 PROCEDURE IPAY_SEQ_NUM_2;

 PROCEDURE SOURCE_CODE;

 PROCEDURE IPAY_PAY_AMT;

 PROCEDURE IPAY_POST_DATE;

END CC_DBK_DC_INVPAY;
/


CREATE OR REPLACE PACKAGE BODY    CC_DBK_DC_INVPAY AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.dbk_dc.display_status('DC_INVPAY',text);
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
--SYS_C0037816 - "IPAY_COMP_CODE" IS NOT NULL
 cursor cur_SYS_C0037816 is
        select dc_rownum
          from DA.DC_INVPAY
            where not "IPAY_COMP_CODE" IS NOT NULL ;

--SYS_C0037817 - "IPAY_INV_NUM" IS NOT NULL
 cursor cur_SYS_C0037817 is
        select dc_rownum
          from DA.DC_INVPAY
            where not "IPAY_INV_NUM" IS NOT NULL ;

--SYS_C0037818 - "IPAY_SEQ_NUM" IS NOT NULL
 cursor cur_SYS_C0037818 is
        select dc_rownum
          from DA.DC_INVPAY
            where not "IPAY_SEQ_NUM" IS NOT NULL ;

BEGIN
null;

 for row_dc in cur_SYS_C0037816
 loop
    da.dbk_dc.error('DC_INVPAY',
                    row_dc.dc_rownum,
                    'SYS_C0037816',
                    'SYS_C0037816',
                    'Condition "IPAY_COMP_CODE" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0037817
 loop
    da.dbk_dc.error('DC_INVPAY',
                    row_dc.dc_rownum,
                    'SYS_C0037817',
                    'SYS_C0037817',
                    'Condition "IPAY_INV_NUM" IS NOT NULL failed.');
 end loop;

 for row_dc in cur_SYS_C0037818
 loop
    da.dbk_dc.error('DC_INVPAY',
                    row_dc.dc_rownum,
                    'SYS_C0037818',
                    'SYS_C0037818',
                    'Condition "IPAY_SEQ_NUM" IS NOT NULL failed.');
 end loop;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.INVPAY table
--======================================================================
PROCEDURE IDX_CHECK AS

--IINVPAY1
cursor cur_IINVPAY1 is
  select dc_rownum,
	 IPAY_INV_NUM,
	 IPAY_SEQ_NUM,
	 IPAY_COMP_CODE
    from DA.DC_INVPAY S1
      where exists (select '1'
      		      from DA.INVPAY S2
			where S1.IPAY_INV_NUM = S2.IPAY_INV_NUM
			  and S1.IPAY_SEQ_NUM = S2.IPAY_SEQ_NUM
			  and S1.IPAY_COMP_CODE = S2.IPAY_COMP_CODE );
BEGIN
 null;

--IINVPAY1
 for row_dc in cur_IINVPAY1
 loop
 	da.dbk_dc.error('DC_INVPAY',row_dc.dc_rownum,
		'IINVPAY1',
		'IINVPAY1',
                'Record with '||'IPAY_INV_NUM '||row_dc.IPAY_INV_NUM ||
		', '||'IPAY_SEQ_NUM '||to_char(row_dc.IPAY_SEQ_NUM) ||
		', '||'IPAY_COMP_CODE '||row_dc.IPAY_COMP_CODE ||
		' already exists in DA.INVPAY table.');

 end loop;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_INVPAY table
--======================================================================
PROCEDURE IDX_DUPL AS

--IINVPAY1
cursor cur_IINVPAY1 is
  select dc_rownum,
	 IPAY_INV_NUM,
	 IPAY_SEQ_NUM,
	 IPAY_COMP_CODE
    from DA.DC_INVPAY S1
      where
	exists (select '1'
		  from DA.DC_INVPAY S2
		    where S1.IPAY_INV_NUM = S2.IPAY_INV_NUM
		      and S1.IPAY_SEQ_NUM = S2.IPAY_SEQ_NUM
		      and S1.IPAY_COMP_CODE = S2.IPAY_COMP_CODE
		      and S1.rowid != S2.rowid );
BEGIN
 null;

--IINVPAY1
 for row_dc in cur_IINVPAY1
 loop
 	da.dbk_dc.error('DC_INVPAY',row_dc.dc_rownum,
		'IINVPAY1',
 		'IINVPAY1',
                'Record with '||'IPAY_INV_NUM '||row_dc.IPAY_INV_NUM ||
		', '||'IPAY_SEQ_NUM '||to_char(row_dc.IPAY_SEQ_NUM) ||
		', '||'IPAY_COMP_CODE '||row_dc.IPAY_COMP_CODE ||
		' already exists in DA.DC_INVPAY table.');
end loop;
END IDX_DUPL;

--======================================================================
--COMP_CODE
--======================================================================
PROCEDURE COMP_CODE AS
  cursor cur_COMP_CODE is
    select dc_rownum,
           IPAY_COMP_CODE
      from DA.DC_INVPAY;

 t_result        da.apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 for row_dc in cur_COMP_CODE
 loop
   t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_ON_FILE,DA.APKC.IS_NOT_NULL),
              row_dc.IPAY_COMP_CODE,t_comp_name);
   if ('0' != t_result) then
         da.dbk_dc.error('DC_INVPAY',
         	row_dc.dc_rownum,
                'IPAY_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   end if;
 end loop;
END COMP_CODE;

--======================================================================
--INV_COMP_CODE
--======================================================================
PROCEDURE INV_COMP_CODE AS
   cursor cur_COMP_CODE is
      select dc_rownum,
             IPAY_INV_COMP_CODE
        from DA.DC_INVPAY;

   t_result        da.apkc.t_result_type%TYPE;
   t_comp_name     da.company.comp_name%TYPE;
BEGIN
   for row_dc in cur_COMP_CODE loop
      t_result := da.apk_gl_company.chk(da.apk_util.context(DA.APKC.IS_ON_FILE),
                                        row_dc.IPAY_INV_COMP_CODE,
                                        t_comp_name);
      if '0' != t_result then
         da.dbk_dc.error('DC_INVPAY',
         	         row_dc.dc_rownum,
                         'IPAY_INV_COMP_CODE',
                         'IPAY_INV_COMP_CODE',
                         t_result);
      end if;
   end loop;
END INV_COMP_CODE;

--======================================================================
--IPAY_INV_NUM
--======================================================================
PROCEDURE IPAY_INV_NUM AS
  cursor cur_IPAY_INV_NUM_null is
    select dc_rownum
      from DA.DC_INVPAY
        where IPAY_INV_NUM is null;
BEGIN
  for row_dc in cur_IPAY_INV_NUM_null
  loop
	da.dbk_dc.error('DC_INVPAY',row_dc.dc_rownum,'IPAY_INV_NUM',
        'IPAY_INV_NUM',
        'IPAY_INV_NUM can not be null.');
  end loop;
END IPAY_INV_NUM;

--======================================================================
--IPAY_INV_NUM_2
--======================================================================
PROCEDURE IPAY_INV_NUM_2 AS
  cursor cur_IPAY_INV_NUM_2 is
    select dc_rownum,
	   IPAY_COMP_CODE,
	   IPAY_INV_NUM
	from DA.DC_INVPAY T1
	  where not exists (select '1'
                        from DA.INVOICE  T2
                          where T1.IPAY_COMP_CODE = T2.INV_COMP_CODE
			    and T1.IPAY_INV_NUM = T2.INV_NUM );

BEGIN
  for row_dc in cur_IPAY_INV_NUM_2
  loop
    if ( row_dc.IPAY_INV_NUM is not null ) then
	 	da.dbk_dc.error('DC_INVPAY',
                row_dc.dc_rownum,
                'IPAY_INV_NUM',
                'INVOICE',
                'Record with'||
		' INV_COMP_CODE '||row_dc.IPAY_COMP_CODE||
		','||' INV_NUM '||row_dc.IPAY_INV_NUM||
		' does not exist in DA.INVOICE table.');
    end if;
 end loop;

END IPAY_INV_NUM_2;

--======================================================================
--IPAY_SEQ_NUM
--======================================================================
PROCEDURE IPAY_SEQ_NUM AS
  cursor cur_IPAY_SEQ_NUM_null is
    select dc_rownum
      from DA.DC_INVPAY
        where IPAY_SEQ_NUM is null;
BEGIN
  for row_dc in cur_IPAY_SEQ_NUM_null
  loop
	da.dbk_dc.error('DC_INVPAY',row_dc.dc_rownum,'IPAY_SEQ_NUM',
        'IPAY_SEQ_NUM',
        'IPAY_SEQ_NUM can not be null.');
  end loop;
END IPAY_SEQ_NUM;

--======================================================================
--IPAY_SEQ_NUM_2
--======================================================================
PROCEDURE IPAY_SEQ_NUM_2 AS
  cursor cur_IPAY_SEQ_NUM_2 is
    select dc_rownum,
	   IPAY_COMP_CODE,
	   IPAY_SEQ_NUM
	from DA.DC_INVPAY T1
	  where not exists (select '1'
                        from DA.PAYMENT  T2
                          where T1.IPAY_COMP_CODE = T2.PAY_COMP_CODE
			    and T1.IPAY_SEQ_NUM = T2.PAY_SEQ_NUM );

BEGIN
  for row_dc in cur_IPAY_SEQ_NUM_2
  loop
    if ( row_dc.IPAY_SEQ_NUM is not null ) then
	 	da.dbk_dc.error('DC_INVPAY',
                row_dc.dc_rownum,
                'IPAY_SEQ_NUM',
                'PAYMENT',
                'Record with'||
		' PAY_COMP_CODE '||row_dc.IPAY_COMP_CODE||
		','||' PAY_SEQ_NUM '||to_char(row_dc.IPAY_SEQ_NUM)||
		' does not exist in DA.PAYMENT table.');
    end if;
 end loop;

END IPAY_SEQ_NUM_2;

--======================================================================
--SOURCE_CODE
--======================================================================
PROCEDURE SOURCE_CODE AS
  cursor cur_SOURCE_CODE is
    select dc_rownum,
           IPAY_SOURCE_CODE
      from DA.DC_INVPAY
        where nvl(IPAY_SOURCE_CODE,'xxxx') not in ('I');
BEGIN
  for row_dc in cur_SOURCE_CODE
  loop

	da.dbk_dc.error('DC_INVPAY',row_dc.dc_rownum,'IPAY_SOURCE_CODE',
        'IPAY_SOURCE_CODE',
        'IPAY_SOURCE_CODE must be set to ''I''.');

  end loop;
END SOURCE_CODE;

--======================================================================
--IPAY_PAY_AMT
--======================================================================
PROCEDURE IPAY_PAY_AMT AS
  cursor cur_IPAY_PAY_AMT_null is
    select dc_rownum
      from DA.DC_INVPAY
        where IPAY_PAY_AMT is null;
BEGIN
  for row_dc in cur_IPAY_PAY_AMT_null
  loop
	da.dbk_dc.error('DC_INVPAY',row_dc.dc_rownum,'IPAY_PAY_AMT',
        'IPAY_PAY_AMT',
        'IPAY_PAY_AMT can not be null.');
  end loop;
END IPAY_PAY_AMT;

--======================================================================
--IPAY_POST_DATE
--======================================================================
PROCEDURE IPAY_POST_DATE AS
  cursor cur_IPAY_POST_DATE_null is
    select dc_rownum
      from DA.DC_INVPAY
        where IPAY_POST_DATE is null;
BEGIN
  for row_dc in cur_IPAY_POST_DATE_null
  loop
	da.dbk_dc.error('DC_INVPAY',row_dc.dc_rownum,'IPAY_POST_DATE',
        'IPAY_POST_DATE',
        'IPAY_POST_DATE can not be null.');
  end loop;
END IPAY_POST_DATE;

--======================================================================
--VERIFY_DATA - run all verify procedures define for INVPAY table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
	display_status(' Delete rows DC_INVPAY from DA.DC_ERROR.');
	delete from da.dc_error
	  where upper(dcerr_table_name) = 'DC_INVPAY' ;
/*
        if not da.dbk_dc_verify.verify('DC_INVPAY') then
          return;
        end if;
*/
        commit;

      	display_status(' INDEX checking in DA.INVPAY');
        idx_check;

        commit;

	display_status(' INDEX  checking in DA.DC_INVPAY');
        idx_dupl;

        commit;

        display_status(' FOREIGN KEYS checking in DA.DC_INVPAY');
        Fk_con;

        commit;

        display_status(' CHECK constraints checking in DA.DC_INVPAY');
        check_con;

        commit;


        display_status(' IPAY_COMP_CODE - checking');
        COMP_CODE;

        commit;

        display_status(' IPAY_IPAY_INV_NUM - checking');
        IPAY_INV_NUM;

        commit;

        display_status(' IPAY_INV_NUM_2 - checking');
        IPAY_INV_NUM_2;

        commit;

        display_status(' IPAY_IPAY_SEQ_NUM - checking');
        IPAY_SEQ_NUM;

        commit;

        display_status(' IPAY_SEQ_NUM_2 - checking');
        IPAY_SEQ_NUM_2;

        commit;

        display_status(' IPAY_SOURCE_CODE - checking');
        SOURCE_CODE;

        commit;

        display_status(' IPAY_IPAY_PAY_AMT - checking');
        IPAY_PAY_AMT;

        commit;

        display_status(' IPAY_IPAY_POST_DATE - checking');
        IPAY_POST_DATE;

        commit;

        display_status(' IPAY_INV_COMP_CODE - checking');
        INV_COMP_CODE;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.INVPAY table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_INVPAY table
   cursor cur_err_INVPAY is
     select count(1)
       from da.dc_error
        where upper(dcerr_table_name) = 'DC_INVPAY' ;

   t_num_errors_INVPAY         NUMBER;

BEGIN
 open  cur_err_INVPAY;
 fetch cur_err_INVPAY into t_num_errors_INVPAY;
 close cur_err_INVPAY;

 display_status('Number of errors in DC_ERROR table for DC_INVPAY table :'||
                to_char(t_num_errors_INVPAY));

 if ( t_num_errors_INVPAY = 0 )
 then

   display_status('Insert into DA.INVPAY');

     insert into DA.INVPAY
        (IPAY_COMP_CODE		--1
	,IPAY_INV_NUM		--2
	,IPAY_SEQ_NUM		--3
	,IPAY_SOURCE_CODE		--4
	,IPAY_INV_TO_NUM		--5
	,IPAY_INV_DATE		--6
	,IPAY_PAY_AMT		--7
	,IPAY_DISC_AMT		--8
	,IPAY_HLDBK_AMT		--9
	,IPAY_WO_AMT		--10
	,IPAY_ALLOW_AMT		--11
	,IPAY_HLDBK_PAID_AMT		--12
	,IPAY_CURR_PAY_AMT		--13
	,IPAY_CURR_DISC_AMT		--14
	,IPAY_CURR_HLDBK_AMT		--15
	,IPAY_CURR_WO_AMT		--16
	,IPAY_CURR_ALLOW_AMT		--17
	,IPAY_CURR_HLDBK_PAID_AMT		--18
	,IPAY_POST_DATE		--19
	,IPAY_REV_DATE		--20
	,IPAY_CURR_TAX_AMT		--21
	,IPAY_CURR_MAT_AMT		--22
	,IPAY_TAX_AMT		--23
	,IPAY_MAT_AMT		--24
	,IPAY_WO_TAX_AMT		--25
	,IPAY_CURR_WO_TAX_AMT		--26
	,IPAY_WO_MAT_AMT		--27
	,IPAY_CURR_WO_MAT_AMT		--28
	,IPAY_INV_COMP_CODE             --29
) select
	IPAY_COMP_CODE		--1
	,IPAY_INV_NUM		--2
	,IPAY_SEQ_NUM		--3
	,IPAY_SOURCE_CODE		--4
	,IPAY_INV_TO_NUM		--5
	,IPAY_INV_DATE		--6
	,IPAY_PAY_AMT		--7
	,IPAY_DISC_AMT		--8
	,IPAY_HLDBK_AMT		--9
	,IPAY_WO_AMT		--10
	,IPAY_ALLOW_AMT		--11
	,IPAY_HLDBK_PAID_AMT		--12
	,IPAY_CURR_PAY_AMT		--13
	,IPAY_CURR_DISC_AMT		--14
	,IPAY_CURR_HLDBK_AMT		--15
	,IPAY_CURR_WO_AMT		--16
	,IPAY_CURR_ALLOW_AMT		--17
	,IPAY_CURR_HLDBK_PAID_AMT		--18
	,IPAY_POST_DATE		--19
	,IPAY_REV_DATE		--20
	,IPAY_CURR_TAX_AMT		--21
	,IPAY_CURR_MAT_AMT		--22
	,IPAY_TAX_AMT		--23
	,IPAY_MAT_AMT		--24
	,IPAY_WO_TAX_AMT		--25
	,IPAY_CURR_WO_TAX_AMT		--26
	,IPAY_WO_MAT_AMT		--27
	,IPAY_CURR_WO_MAT_AMT		--28
	,IPAY_INV_COMP_CODE             --29
   from DA.DC_INVPAY;

  --delete everything from DA.DC_INVPAY
    display_status('Delete rows from DA.DC_INVPAY table.');
    delete from DA.DC_INVPAY;
    display_status('Number of records deleted from DA.DC_INVPAY table:'||to_char(SQL%rowcount));

     display_status('INVPAY moving from temp table was successful.');
--     commit;

 end if; /*    if nvl(t_num_errors_INVPAY,0) = 0 */

exception when others
     then
       display_status('Can not move data from DA.DC_INVPAY into DA.INVPAY.');
       dbms_output.put_line(SQLERRM);
       rollback;
       raise;

END Process_temp_data ;

END CC_DBK_DC_INVPAY;
/
