CREATE OR REPLACE PACKAGE    CC_Dbk_Dc_Payment AS

 PROCEDURE Verify_data;

 PROCEDURE Process_Temp_Data;

END CC_Dbk_Dc_Payment;
/


CREATE OR REPLACE PACKAGE BODY    CC_Dbk_Dc_Payment AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.Dbk_Dc.display_status('DC_PAYMENT',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS

CURSOR cur_PAYMENT_BPCUSTOMERS_FK IS
  SELECT dc_rownum,
	 PAY_COMP_CODE,
	 PAY_CUST_CODE
	FROM DA.DC_PAYMENT  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.BPCUSTOMERS T2
		WHERE NVL(T1.PAY_COMP_CODE,T2.BPCUST_COMP_CODE) = T2.BPCUST_COMP_CODE
		  AND NVL(T1.PAY_CUST_CODE,T2.BPCUST_BP_CODE) = T2.BPCUST_BP_CODE );

BEGIN
NULL;
--PAYMENT_BPCUSTOMERS_FK
 FOR row_dc IN cur_PAYMENT_BPCUSTOMERS_FK
 LOOP
	 da.Dbk_Dc.error('DC_PAYMENT',
                                 row_dc.dc_rownum,
                                 'PAYMENT_BPCUSTOMERS_FK',
                                 'BPCUSTOMERS',
		'Record with '|| ' BPCUST_COMP_CODE '||row_dc.PAY_COMP_CODE||
				','||' BPCUST_BP_CODE '||row_dc.PAY_CUST_CODE||
		' does not exist in DA.BPCUSTOMERS table.');
 END LOOP;


END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--SYS_C0038431 - "PAY_COMP_CODE" IS NOT NULL
 CURSOR cur_SYS_C0038431 IS
        SELECT dc_rownum
          FROM DA.DC_PAYMENT
            WHERE NOT "PAY_COMP_CODE" IS NOT NULL ;

--SYS_C0038432 - "PAY_SEQ_NUM" IS NOT NULL
 CURSOR cur_SYS_C0038432 IS
        SELECT dc_rownum
          FROM DA.DC_PAYMENT
            WHERE NOT "PAY_SEQ_NUM" IS NOT NULL ;

BEGIN
NULL;

 FOR row_dc IN cur_SYS_C0038431
 LOOP
    da.Dbk_Dc.error('DC_PAYMENT',
                    row_dc.dc_rownum,
                    'SYS_C0038431',
                    'SYS_C0038431',
                    'Condition "PAY_COMP_CODE" IS NOT NULL failed.');
 END LOOP;

 FOR row_dc IN cur_SYS_C0038432
 LOOP
    da.Dbk_Dc.error('DC_PAYMENT',
                    row_dc.dc_rownum,
                    'SYS_C0038432',
                    'SYS_C0038432',
                    'Condition "PAY_SEQ_NUM" IS NOT NULL failed.');
 END LOOP;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.PAYMENT table
--======================================================================
PROCEDURE IDX_CHECK AS

--IPAYMENT1
CURSOR cur_IPAYMENT1 IS
  SELECT dc_rownum,
	 PAY_SEQ_NUM,
	 PAY_COMP_CODE
    FROM DA.DC_PAYMENT S1
      WHERE EXISTS (SELECT '1'
      		      FROM DA.PAYMENT S2
			WHERE S1.PAY_SEQ_NUM = S2.PAY_SEQ_NUM
			  AND S1.PAY_COMP_CODE = S2.PAY_COMP_CODE );
BEGIN
 NULL;

--IPAYMENT1
 FOR row_dc IN cur_IPAYMENT1
 LOOP
 	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,
		'IPAYMENT1',
		'IPAYMENT1',
                'Record with '||'PAY_SEQ_NUM '||TO_CHAR(row_dc.PAY_SEQ_NUM) ||
		', '||'PAY_COMP_CODE '||row_dc.PAY_COMP_CODE ||
		' already exists in DA.PAYMENT table.');

 END LOOP;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_PAYMENT table
--======================================================================
PROCEDURE IDX_DUPL AS

--IPAYMENT1
CURSOR cur_IPAYMENT1 IS
  SELECT dc_rownum,
	 PAY_SEQ_NUM,
	 PAY_COMP_CODE
    FROM DA.DC_PAYMENT S1
      WHERE
	EXISTS (SELECT '1'
		  FROM DA.DC_PAYMENT S2
		    WHERE S1.PAY_SEQ_NUM = S2.PAY_SEQ_NUM
		      AND S1.PAY_COMP_CODE = S2.PAY_COMP_CODE
		      AND S1.ROWID != S2.ROWID );
BEGIN
 NULL;

--IPAYMENT1
 FOR row_dc IN cur_IPAYMENT1
 LOOP
 	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,
		'IPAYMENT1',
 		'IPAYMENT1',
                'Record with '||'PAY_SEQ_NUM '||TO_CHAR(row_dc.PAY_SEQ_NUM) ||
		', '||'PAY_COMP_CODE '||row_dc.PAY_COMP_CODE ||
		' already exists in DA.DC_PAYMENT table.');
END LOOP;
END IDX_DUPL;

--======================================================================
--COMP_CODE
--======================================================================
PROCEDURE COMP_CODE AS
  CURSOR cur_COMP_CODE IS
    SELECT dc_rownum,
           PAY_COMP_CODE
      FROM DA.DC_PAYMENT;

 t_result        da.Apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 FOR row_dc IN cur_COMP_CODE
 LOOP
   t_result := da.Apk_Gl_Company.chk(da.Apk_Util.context(DA.Apkc.IS_ON_FILE,DA.Apkc.IS_NOT_NULL),
              row_dc.PAY_COMP_CODE,t_comp_name);
   IF ('0' != t_result) THEN
         da.Dbk_Dc.error('DC_PAYMENT',
         	row_dc.dc_rownum,
                'PAY_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   END IF;
 END LOOP;
END COMP_CODE;

--======================================================================
--PAY_SEQ_NUM
--======================================================================
PROCEDURE PAY_SEQ_NUM AS
  CURSOR cur_PAY_SEQ_NUM_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_SEQ_NUM IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_SEQ_NUM_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_SEQ_NUM',
        'PAY_SEQ_NUM',
        'PAY_SEQ_NUM can not be null.');
  END LOOP;
END PAY_SEQ_NUM;

--======================================================================
--PAY_BCH_NUM
--======================================================================
PROCEDURE PAY_BCH_NUM AS
  CURSOR cur_PAY_BCH_NUM_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_BCH_NUM IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_BCH_NUM_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_BCH_NUM',
        'PAY_BCH_NUM',
        'PAY_BCH_NUM can not be null.');
  END LOOP;
END PAY_BCH_NUM;

--======================================================================
--PAY_BCH_NUM_2
--======================================================================
PROCEDURE PAY_BCH_NUM_2 AS
  CURSOR cur_PAY_BCH_NUM_2 IS
    SELECT dc_rownum,
	   PAY_BCH_NUM
	FROM DA.DC_PAYMENT T1
	  WHERE PAY_BCH_NUM IS NOT NULL
            AND EXISTS (SELECT '1'
 		    FROM DA.ARBATCH  T2
		      WHERE T1.PAY_BCH_NUM = T2.ARBCH_NUM
                        AND T2.ARBCH_TYPE_CODE != 'T' );

BEGIN
  FOR row_dc IN cur_PAY_BCH_NUM_2
  LOOP
    IF ( row_dc.PAY_BCH_NUM IS NOT NULL ) THEN

        da.Dbk_Dc.error('DC_PAYMENT',
                row_dc.dc_rownum,
                'PAY_BCH_NUM',
                'ARBATCH',
                'Record with'||
		' ARBCH_NUM '||TO_CHAR(row_dc.PAY_BCH_NUM) ||
                ' and ARBCH_TYPE_CODE != ''T'' '||
		' exists in DA.ARBATCH table.');
    END IF;
 END LOOP;

END PAY_BCH_NUM_2;

--======================================================================
--PAY_CHQ_NUM
--======================================================================
PROCEDURE PAY_CHQ_NUM AS
  CURSOR cur_PAY_CHQ_NUM_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_CHQ_NUM IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_CHQ_NUM_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_CHQ_NUM',
        'PAY_CHQ_NUM',
        'PAY_CHQ_NUM can not be null.');
  END LOOP;
END PAY_CHQ_NUM;

--======================================================================
--PAY_CUST_CODE
--======================================================================
PROCEDURE PAY_CUST_CODE AS
  CURSOR cur_PAY_CUST_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_CUST_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_CUST_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_CUST_CODE',
        'PAY_CUST_CODE',
        'PAY_CUST_CODE can not be null.');
  END LOOP;
END PAY_CUST_CODE;

--======================================================================
--PAY_DATE
--======================================================================
PROCEDURE PAY_DATE AS
  CURSOR cur_PAY_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_DATE IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_DATE_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_DATE',
        'PAY_DATE',
        'PAY_DATE can not be null.');
  END LOOP;
END PAY_DATE;

--======================================================================
--PAY_ACTUAL_DATE
--======================================================================
PROCEDURE PAY_ACTUAL_DATE AS
  CURSOR cur_PAY_ACTUAL_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_ACTUAL_DATE IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_ACTUAL_DATE_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_ACTUAL_DATE',
        'PAY_ACTUAL_DATE',
        'PAY_ACTUAL_DATE can not be null.');
  END LOOP;
END PAY_ACTUAL_DATE;

--======================================================================
--PAY_POST_DATE
--======================================================================
PROCEDURE PAY_POST_DATE AS
  CURSOR cur_PAY_POST_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_POST_DATE IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_POST_DATE_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_POST_DATE',
        'PAY_POST_DATE',
        'PAY_POST_DATE can not be null.');
  END LOOP;
END PAY_POST_DATE;

--======================================================================
--DEPT_CODE
--======================================================================
PROCEDURE DEPT_CODE AS

 t_result        da.Apkc.t_result_type%TYPE;
 t_dept_name     da.dept.dept_name%TYPE;

CURSOR cur_dept_code IS
  SELECT dc_rownum,
         PAY_COMP_CODE,
         PAY_DEPT_CODE
   FROM  DA.DC_PAYMENT ;

BEGIN
 FOR row_dc IN cur_dept_code
 LOOP
  t_result := da.Apk_Gl_Dept.chk(da.Apk_Util.context(DA.Apkc.IS_ON_FILE,DA.Apkc.IS_NOT_NULL),
                row_dc.PAY_COMP_CODE,
                row_dc.PAY_DEPT_CODE,
                t_dept_name);
 IF (t_result != '0')
 THEN
    da.Dbk_Dc.error('DC_PAYMENT',
    		row_dc.dc_rownum,
                'PAY_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 END IF;

END LOOP;
END DEPT_CODE;

--======================================================================
--ACC_CODE
--======================================================================
PROCEDURE ACC_CODE AS
 t_result        da.Apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

CURSOR cur_acc_code IS
  SELECT dc_rownum,
         PAY_COMP_CODE,
         PAY_DEPT_CODE,
         PAY_ACC_CODE
   FROM  DA.DC_PAYMENT ;

BEGIN

 FOR row_dc IN cur_acc_code
 LOOP
    t_result := da.Apk_Gl_Account.chk_by_company_dept(
   			da.Apk_Util.context(DA.Apkc.IS_ON_FILE,DA.Apkc.IS_NOT_NULL,DA.Apkc.ACCOUNT_ALLOWS_TRANSACTIONS),
		row_dc.PAY_COMP_CODE,
		row_dc.PAY_DEPT_CODE,
		row_dc.PAY_ACC_CODE,
		t_acc_name);
    IF ('0' != t_result)
    THEN
      da.Dbk_Dc.error('DC_PAYMENT',
    		row_dc.dc_rownum,
                'PAY_ACC_CODE',
                'ACC_CODE',
                t_result);
    END IF;
 END LOOP;
END ACC_CODE;

--======================================================================
--PAY_AMT
--======================================================================
PROCEDURE PAY_AMT AS
  CURSOR cur_PAY_AMT_null IS
    SELECT dc_rownum
      FROM DA.DC_PAYMENT
        WHERE PAY_AMT IS NULL;
BEGIN
  FOR row_dc IN cur_PAY_AMT_null
  LOOP
	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_AMT',
        'PAY_AMT',
        'PAY_AMT can not be null.');
  END LOOP;
END PAY_AMT;

--======================================================================
--CURR_AMT
--======================================================================
PROCEDURE CURR_AMT AS
 CURSOR cur_CURR_AMT IS
   SELECT dc_rownum
     FROM DA.DC_PAYMENT
       WHERE NVL(PAY_CURR_AMT,0) != NVL(PAY_AMT,0);
BEGIN
 FOR row_dc IN cur_CURR_AMT
 LOOP
        da.Dbk_Dc.error('DC_PAYMENT',
                row_dc.dc_rownum,
                'PAY_CURR_AMT',
                'PAY_AMT',
                'Column PAY_CURR_AMT does not equal column PAY_AMT.');
 END LOOP;
END CURR_AMT;

--======================================================================
--REV_CODE
--======================================================================
PROCEDURE REV_CODE AS
  CURSOR cur_REV_CODE IS
    SELECT dc_rownum,
           PAY_REV_CODE
      FROM DA.DC_PAYMENT
        WHERE NVL(PAY_REV_CODE,'xxxx') NOT IN ('OTH');
BEGIN
  FOR row_dc IN cur_REV_CODE
  LOOP
    IF ( row_dc.PAY_REV_CODE IS NOT NULL ) THEN

	da.Dbk_Dc.error('DC_PAYMENT',row_dc.dc_rownum,'PAY_REV_CODE',
        'PAY_REV_CODE',
        'PAY_REV_CODE must be set to ''OTH'' or NULL.');
    END IF;
  END LOOP;
END REV_CODE;

--======================================================================
--PAY_CURR_CODE
--======================================================================
PROCEDURE PAY_CURR_CODE AS
  CURSOR cur_PAY_CURR_CODE IS
   SELECT dc_rownum,
          PAY_CURR_CODE
     FROM DA.DC_PAYMENT ;

 t_result  	da.Apkc.t_result_type%TYPE;
 t_curr_name    da.bacurrency.bacurr_name%TYPE;

BEGIN
 FOR row_dc IN cur_PAY_CURR_CODE
 LOOP
       t_result := da.Apk_Sys_Currency.chk(da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE),
                                  row_dc.PAY_CURR_CODE,
                                  t_curr_name);

        IF ('0' != t_result) THEN
             da.Dbk_Dc.error('DC_PAYMENT',
                     row_dc.dc_rownum,
                     'PAY_CURR_CODE',
                     'CURR_CODE',
                     t_result);
      END IF;

 END LOOP;
END PAY_CURR_CODE;

--======================================================================
--PAY_TYPE_CODE
--======================================================================
PROCEDURE PAY_TYPE_CODE AS
  CURSOR cur_PAY_TYPE_CODE IS
    SELECT dc_rownum,
	   PAY_TYPE_CODE
	FROM DA.DC_PAYMENT T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PAYTYPE  T2
                          WHERE T1.PAY_TYPE_CODE = T2.PAYTYP_CODE );

BEGIN
  FOR row_dc IN cur_PAY_TYPE_CODE
  LOOP
    IF ( row_dc.PAY_TYPE_CODE IS NOT NULL ) THEN
	 	da.Dbk_Dc.error('DC_PAYMENT',
                row_dc.dc_rownum,
                'PAY_TYPE_CODE',
                'PAYTYPE',
                'Record with'||
		' PAYTYP_CODE '||row_dc.PAY_TYPE_CODE||
		' does not exist in DA.PAYTYPE table.');
    END IF;
 END LOOP;

END PAY_TYPE_CODE;

--======================================================================
--PAY_BCH_NUM_3
--======================================================================
PROCEDURE PAY_BCH_NUM_3 AS
  CURSOR cur_PAY_BCH_NUM_3 IS
    SELECT dc_rownum,
           PAY_BCH_NUM
      FROM DA.DC_PAYMENT
        WHERE PAY_BCH_NUM IN (SELECT PAY_BCH_NUM FROM DA.DC_PAYMENT GROUP BY PAY_BCH_NUM HAVING COUNT(DISTINCT(PAY_COMP_CODE)) > 1) ;
BEGIN
 FOR row_dc IN cur_PAY_BCH_NUM_3
 LOOP
        da.Dbk_Dc.error('DC_PAYMENT',
                row_dc.dc_rownum,
                'PAY_BCH_NUM',
                'PAY_BCH_NUM',
                'THERE ARE 2 OR MORE COMPANIES IN BATCH '||TO_CHAR(row_dc.PAY_BCH_NUM)||'.');
 END LOOP;
END PAY_BCH_NUM_3;
/*
--======================================================================
--PAY_BCH_NUM_4
--======================================================================
PROCEDURE PAY_BCH_NUM_4 AS
  CURSOR cur_PAY_BCH_NUM_4 IS
    SELECT dc_rownum,
           PAY_BCH_NUM
      FROM DA.DC_PAYMENT
        WHERE PAY_BCH_NUM IN (SELECT PAY_BCH_NUM FROM DA.DC_PAYMENT GROUP BY PAY_BCH_NUM HAVING COUNT(DISTINCT(PAY_POST_DATE)) > 1) ;
BEGIN
 FOR row_dc IN cur_PAY_BCH_NUM_4
 LOOP
        da.Dbk_Dc.error('DC_PAYMENT',
                row_dc.dc_rownum,
                'PAY_BCH_NUM',
                'PAY_BCH_NUM',
                'THERE ARE 2 OR MORE DIFFERENT POST DATES IN BATCH '||TO_CHAR(row_dc.PAY_BCH_NUM)||'.');
 END LOOP;
END PAY_BCH_NUM_4;
*/
--======================================================================
--CREATE_BATCHES - create batches in da.batch file
--      post date will be taken as max post date for apropriate batch
--      the calling of procedure has to be added into process_temp_data
--	procedure to appropriate place
--      Only batches which don't exists in ARBATCH table will be created.
--======================================================================

PROCEDURE create_batches AS
  CURSOR cur_batches IS
    SELECT pay_bch_num "PAY_BCH_NUM",
           MAX(pay_post_date) "PAY_POST_DATE",
           MAX(pay_comp_code) "PAY_COMP_CODE"
      FROM da.dc_payment T1
        WHERE NOT EXISTS ( SELECT '1'
                             FROM da.arbatch T2
                                WHERE T1.pay_bch_num = T2.ARBCH_NUM
                                  AND T2.ARBCH_TYPE_CODE = 'T' )
      GROUP BY pay_bch_num;

BEGIN
 FOR row_batch IN cur_batches
 LOOP
     INSERT INTO da.arbatch
        (ARBCH_NUM,             --1
        ARBCH_COMP_CODE,        --2
        ARBCH_NAME,             --3
        ARBCH_USER,             --4
        ARBCH_AMT,              --5
        ARBCH_DATE,             --6
        ARBCH_POST_DATE,        --7
        ARBCH_TYPE_CODE)        --8
     VALUES
        (row_batch.pay_bch_num,                         --1
         row_batch.pay_comp_code,                       --2
         'DC - '||TO_CHAR(SYSDATE,'YYYYMMDD HH:MI:SS'), --3
         USER,                                          --4
         0,                                             --5
         SYSDATE,                                       --6
         row_batch.pay_post_date,                       --7
         'T');                                          --8
 END LOOP;

EXCEPTION WHEN OTHERS THEN
        display_status('Can not insert into DA.ARBATCH table.');
        dbms_output.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END create_batches;

--======================================================================
--VERIFY_DATA - run all verify procedures define for PAYMENT table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
	display_status(' Delete rows DC_PAYMENT from DA.DC_ERROR.');
	DELETE FROM da.dc_error
	  WHERE UPPER(dcerr_table_name) = 'DC_PAYMENT' ;
/*
        IF NOT da.Dbk_Dc_Verify.verify('DC_PAYMENT') THEN
          RETURN;
        END IF;
*/
        COMMIT;

      	display_status(' INDEX checking in DA.PAYMENT');
        idx_check;

        COMMIT;

	display_status(' INDEX  checking in DA.DC_PAYMENT');
        idx_dupl;

        COMMIT;

        display_status(' FOREIGN KEYS checking in DA.DC_PAYMENT');
        Fk_con;

        COMMIT;

        display_status(' CHECK constraints checking in DA.DC_PAYMENT');
        check_con;

        COMMIT;


        display_status(' PAY_COMP_CODE - checking');
        COMP_CODE;

        COMMIT;

        display_status(' PAY_PAY_SEQ_NUM - checking');
        PAY_SEQ_NUM;

        COMMIT;

        display_status(' PAY_PAY_BCH_NUM - checking');
        PAY_BCH_NUM;

        COMMIT;

        display_status(' PAY_BCH_NUM_2 - checking');
        PAY_BCH_NUM_2;

        COMMIT;

        display_status(' PAY_PAY_CHQ_NUM - checking');
        PAY_CHQ_NUM;

        COMMIT;

        display_status(' PAY_PAY_CUST_CODE - checking');
        PAY_CUST_CODE;

        COMMIT;

        display_status(' PAY_PAY_DATE - checking');
        PAY_DATE;

        COMMIT;

        display_status(' PAY_PAY_ACTUAL_DATE - checking');
        PAY_ACTUAL_DATE;

        COMMIT;

        display_status(' PAY_PAY_POST_DATE - checking');
        PAY_POST_DATE;

        COMMIT;

        display_status(' PAY_DEPT_CODE - checking');
        DEPT_CODE;

        COMMIT;

        display_status(' PAY_ACC_CODE - checking');
        ACC_CODE;

        COMMIT;

        display_status(' PAY_PAY_AMT - checking');
        PAY_AMT;

        COMMIT;

        display_status(' PAY_CURR_AMT - checking');
        CURR_AMT;

        COMMIT;

        display_status(' PAY_REV_CODE - checking');
        REV_CODE;

        COMMIT;

        display_status(' Y_PAY_CURR_CODE - checking');
        PAY_CURR_CODE;

        COMMIT;

        display_status(' PAY_TYPE_CODE - checking');
        PAY_TYPE_CODE;

        COMMIT;

        display_status(' PAY_BCH_NUM_3 - checking');
        PAY_BCH_NUM_3;

        COMMIT;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.PAYMENT table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_PAYMENT table
   CURSOR cur_err_PAYMENT IS
     SELECT COUNT(1)
       FROM da.dc_error
        WHERE UPPER(dcerr_table_name) = 'DC_PAYMENT' ;

   t_num_errors_PAYMENT         NUMBER;

BEGIN
 OPEN  cur_err_PAYMENT;
 FETCH cur_err_PAYMENT INTO t_num_errors_PAYMENT;
 CLOSE cur_err_PAYMENT;

 display_status('Number of errors in DC_ERROR table for DC_PAYMENT table :'||
                TO_CHAR(t_num_errors_PAYMENT));

 IF ( t_num_errors_PAYMENT = 0 )
 THEN
   display_status('Create batches in DA.ARBATCH table');
   create_batches;

   display_status('Insert into DA.PAYMENT');

     INSERT INTO DA.PAYMENT
        (PAY_COMP_CODE		--1
	,PAY_SEQ_NUM		--2
	,PAY_BCH_NUM		--3
	,PAY_ORD_NUM		--4
	,PAY_CHQ_NUM		--5
	,PAY_CUST_CODE		--6
	,PAY_DATE		--7
	,PAY_ACTUAL_DATE		--8
	,PAY_POST_DATE		--9
	,PAY_DEPT_CODE		--10
	,PAY_ACC_CODE		--11
	,PAY_AMT		--12
	,PAY_CURR_AMT		--13
	,PAY_DISP_AMT		--14
	,PAY_REC_DATE		--15
	,PAY_REV_CODE		--16
	,PAY_REV_DATE		--17
	,PAY_CURR_CODE		--18
	,PAY_CURC_FACTOR_NUM		--19
	,PAY_TYPE_CODE		--20
	,PAY_JOB_CODE		--21
	,PAY_DPST_CODE		--22
	,PAY_CASH_CODE		--23
	,PAY_NXT_SEQ_NUM		--24
	,PAY_DESC		--25
	,PAY_TEMP_AMT		--26
	,PAY_INV_NUM		--27
	,PAY_INV_DATE		--28
	,PAY_OE_PRT_CODE		--29
	,PAY_IMAGE_FILENAME		--30
	,PAY_BANK_COMP_CODE		--31

) SELECT
	PAY_COMP_CODE		--1
	,PAY_SEQ_NUM		--2
	,PAY_BCH_NUM		--3
	,PAY_ORD_NUM		--4
	,PAY_CHQ_NUM		--5
	,PAY_CUST_CODE		--6
	,PAY_DATE		--7
	,PAY_ACTUAL_DATE		--8
	,PAY_POST_DATE		--9
	,PAY_DEPT_CODE		--10
	,PAY_ACC_CODE		--11
	,PAY_AMT		--12
	,PAY_CURR_AMT		--13
	,PAY_DISP_AMT		--14
	,PAY_REC_DATE		--15
	,PAY_REV_CODE		--16
	,PAY_REV_DATE		--17
	,PAY_CURR_CODE		--18
	,PAY_CURC_FACTOR_NUM		--19
	,PAY_TYPE_CODE		--20
	,PAY_JOB_CODE		--21
	,PAY_DPST_CODE		--22
	,PAY_CASH_CODE		--23
	,PAY_NXT_SEQ_NUM		--24
	,PAY_DESC		--25
	,PAY_TEMP_AMT		--26
	,PAY_INV_NUM		--27
	,PAY_INV_DATE		--28
	,PAY_OE_PRT_CODE		--29
	,PAY_IMAGE_FILENAME		--30
	,PAY_BANK_COMP_CODE		--31
   FROM DA.DC_PAYMENT;

  --delete everything from DA.DC_PAYMENT
    display_status('Delete rows from DA.DC_PAYMENT table.');
    DELETE FROM DA.DC_PAYMENT;
    display_status('Number of records deleted from DA.DC_PAYMENT table:'||TO_CHAR(SQL%rowcount));

     display_status('PAYMENT moving from temp table was successful.');
--     commit;

 END IF; /*    if nvl(t_num_errors_PAYMENT,0) = 0 */

EXCEPTION WHEN OTHERS
     THEN
       display_status('Can not move data from DA.DC_PAYMENT into DA.PAYMENT.');
       dbms_output.put_line(SQLERRM);
       ROLLBACK;
       RAISE;

END Process_temp_data ;

END CC_Dbk_Dc_Payment;
/
