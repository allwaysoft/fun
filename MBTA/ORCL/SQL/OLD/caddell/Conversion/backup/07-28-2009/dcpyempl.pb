--Thu Mar 25 16:48:07 1999 
-- Revised 1 Sep 2004 by L.Vanek to fix datatype mismatch in filing status fields. 
-- Revised 24 May 2005 by L. Vanek to make non-null validation of emp_wcb_code
--                                 conditional on the value of con_wc_flag, and
--                                 to add a similar validation for emp_pl_code.
-- Revised 04 Aug 2005 by L. Vanek to set all columns when inserting into PYEMPHIST.
-- Revised 21 Sep 2005 by L. Vanek to add validation of EMP_EXP_APRV_GRP_CODE
-- Revised 21 Nov 2005 by B. Muller and L. Vanek to make validation of job, phase,
--                                  and category use master tables, not JCJOBCAT.
-- Revised 27 Nov 2005 by L. Vanek to improve validation of salary vs. hourly rate
--                                 and add records to PYACCESSCODE.
-- Revised 31 May 2006 by L. Vanek (06.80414) add an LDAP user for each new access code.
-- Revised 26 Jul 2006 by A. Tjin to include validation for EMP_INCL_CERT_PY_REP_FLAG
-- Revised 18 Apr 2008 by A. Tjin to include the ethnic codes 'P' and 'M'.
-- Revised 25 Aug 2008 by A. Tjin to include validation for EMP_REHIRE_ELIBLE.
PROMPT =======================================
PROMPT   CREATE Dbk_Dc_Pyemployee_Table PACKAGE BODY
PROMPT =======================================

CREATE OR REPLACE PACKAGE BODY DA.Dbk_Dc_Pyemployee_Table AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.Dbk_Dc.display_status('DC_PYEMPLOYEE_TABLE',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS

CURSOR cur_EMPLOYEE_WORKLOC_FK IS
  SELECT dc_rownum,
	 EMP_WRL_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYWORKLOC T2
		WHERE NVL(T1.EMP_WRL_CODE,T2.WRL_CODE) = T2.WRL_CODE );

CURSOR cur_EMPLOYEE_STATE_FK IS
  SELECT dc_rownum,
	 EMP_COUNTRY_CODE,
	 EMP_STATE_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYSTATE T2
		WHERE NVL(T1.EMP_COUNTRY_CODE,T2.STA_COUNTRY_CODE) = T2.STA_COUNTRY_CODE
		  AND NVL(T1.EMP_STATE_CODE,T2.STA_STATE_CODE) = T2.STA_STATE_CODE );

CURSOR cur_EMPLOYEE_CONTROL_FK IS
  SELECT dc_rownum,
	 EMP_COMP_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYCONTROL T2
		WHERE NVL(T1.EMP_COMP_CODE,T2.CON_COMP_CODE) = T2.CON_COMP_CODE );

CURSOR cur_EMPLOYEE_COUNTY_FK IS
  SELECT dc_rownum,
	 EMP_COUNTRY_CODE,
	 EMP_STATE_CODE,
	 EMP_COUNTY_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYCOUNTY T2
		WHERE NVL(T1.EMP_COUNTRY_CODE,T2.CNT_COUNTRY_CODE) = T2.CNT_COUNTRY_CODE
		  AND NVL(T1.EMP_STATE_CODE,T2.CNT_STATE_CODE) = T2.CNT_STATE_CODE
		  AND NVL(T1.EMP_COUNTY_CODE,T2.CNT_COUNTY_CODE) = T2.CNT_COUNTY_CODE );

CURSOR cur_EMPLOYEE_COMPAYGRP_FK IS
  SELECT dc_rownum,
	 EMP_COMP_CODE,
	 EMP_PYG_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYCOMPAYGRP T2
		WHERE NVL(T1.EMP_COMP_CODE,T2.PYG_COMP_CODE) = T2.PYG_COMP_CODE
		  AND NVL(T1.EMP_PYG_CODE,T2.PYG_CODE) = T2.PYG_CODE );

CURSOR cur_EMPLOYEE_TRADES_FK IS
  SELECT dc_rownum,
	 EMP_TRD_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYTRADES T2
		WHERE NVL(T1.EMP_TRD_CODE,T2.TRD_CODE) = T2.TRD_CODE );

CURSOR cur_EMPLOYEE_PAYRCD_FK IS
  SELECT dc_rownum,
	 EMP_RATE_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYPAYRCD T2
		WHERE NVL(T1.EMP_RATE_CODE,T2.RCD_CODE) = T2.RCD_CODE );

CURSOR cur_EMPLOYEE_LANGUAGE_FK IS
  SELECT dc_rownum,
	 LANGUAGE_LANG_NAME
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.HRLANGUAGES T2
		WHERE NVL(T1.LANGUAGE_LANG_NAME,T2.LANG_NAME) = T2.LANG_NAME );

CURSOR cur_EMPLOYEE_COUNTRY_FK IS
  SELECT dc_rownum,
	 EMP_COUNTRY_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYCOUNTRY T2
		WHERE NVL(T1.EMP_COUNTRY_CODE,T2.CTR_COUNTRY_CODE) = T2.CTR_COUNTRY_CODE );

/*cursor cur_EMPLOYEE_RES_LOC_FK is
  select dc_rownum,
	 EMP_RES_LOC
	from DA.DC_PYEMPLOYEE_TABLE  T1
	where not exists
	   (select '1'
	      from DA.PYWORKLOC T2
		where nvl(T1.EMP_RES_LOC,T2.WRL_CODE) = T2.WRL_CODE );
*/

CURSOR cur_EMPLOYEE_CITY_FK IS
  SELECT dc_rownum,
	 EMP_COUNTRY_CODE,
	 EMP_STATE_CODE,
	 EMP_COUNTY_CODE,
	 EMP_CITY_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYCITY T2
		WHERE NVL(T1.EMP_COUNTRY_CODE,T2.CTY_COUNTRY_CODE) = T2.CTY_COUNTRY_CODE
		  AND NVL(T1.EMP_STATE_CODE,T2.CTY_STATE_CODE) = T2.CTY_STATE_CODE
		  AND NVL(T1.EMP_COUNTY_CODE,T2.CTY_COUNTY_CODE) = T2.CTY_COUNTY_CODE
		  AND NVL(T1.EMP_CITY_CODE,T2.CTY_CITY_CODE) = T2.CTY_CITY_CODE );

CURSOR cur_EMPLOYEE_UNIONS_FK IS
  SELECT dc_rownum,
	 EMP_UNI_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYUNIONS T2
		WHERE NVL(T1.EMP_UNI_CODE,T2.UNI_CODE) = T2.UNI_CODE );

CURSOR cur_EMPLOYEE_BANK_FK IS
  SELECT dc_rownum,
	 EMP_BANK_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.BABANK T2
		WHERE NVL(T1.EMP_BANK_CODE,T2.BNK_BANK_CODE) = T2.BNK_BANK_CODE );

CURSOR cur_EMPLOYEE_DEPT_FK IS
  SELECT dc_rownum,
	 EMP_COMP_CODE,
	 EMP_DEPT_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.DEPT_TABLE T2
		WHERE NVL(T1.EMP_COMP_CODE,T2.DEPT_COMP_CODE) = T2.DEPT_COMP_CODE
		  AND NVL(T1.EMP_DEPT_CODE,T2.DEPT_CODE) = T2.DEPT_CODE );

CURSOR cur_EMPLOYEE_DISABILITY_FK IS
  SELECT dc_rownum,
	 DISABILITY_DIS_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.HRDISABILITY T2
		WHERE NVL(T1.DISABILITY_DIS_CODE,T2.DIS_CODE) = T2.DIS_CODE );

CURSOR cur_EMPLOYEE_BRANCH_FK IS
  SELECT dc_rownum,
	 EMP_BANK_CODE,
	 EMP_BRANCH_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.BABRANCH T2
		WHERE NVL(T1.EMP_BANK_CODE,T2.BRN_BANK_CODE) = T2.BRN_BANK_CODE
		  AND NVL(T1.EMP_BRANCH_CODE,T2.BRN_BRANCH_CODE) = T2.BRN_BRANCH_CODE );

CURSOR cur_EMPLOYEE_PAYRUN_FK IS
  SELECT dc_rownum,
	 EMP_PRN_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYPAYRUN T2
		WHERE NVL(T1.EMP_PRN_CODE,T2.PRN_CODE) = T2.PRN_CODE );

CURSOR cur_EMPLOYEE_JCJOBCAT_FK IS
  SELECT dc_rownum,
	 EMP_COMP_CODE,
	 EMP_JOB_CODE,
	 EMP_PHS_CODE,
	 EMP_CAT_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.JCJOBCAT T2
		WHERE NVL(T1.EMP_COMP_CODE,T2.JCAT_COMP_CODE) = T2.JCAT_COMP_CODE
		  AND NVL(T1.EMP_JOB_CODE,T2.JCAT_JOB_CODE) = T2.JCAT_JOB_CODE
		  AND NVL(T1.EMP_PHS_CODE,T2.JCAT_PHS_CODE) = T2.JCAT_PHS_CODE
		  AND NVL(T1.EMP_CAT_CODE,T2.JCAT_CODE) = T2.JCAT_CODE );

CURSOR cur_EMP_EXP_APRV_GRP_CODE_FK IS
  SELECT dc_rownum,
         EMP_EXP_APRV_GRP_CODE
    FROM DA.DC_PYEMPLOYEE_TABLE  T1
	WHERE NOT EXISTS
	   (SELECT '1'
	      FROM DA.PYEXPAPGRP T2
		WHERE NVL(T1.EMP_EXP_APRV_GRP_CODE,T2.EAG_GROUP_CODE) = T2.EAG_GROUP_CODE );

BEGIN
NULL;
--EMPLOYEE_WORKLOC_FK
 FOR row_dc IN cur_EMPLOYEE_WORKLOC_FK
LOOP
  IF ( row_dc.EMP_WRL_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_WORKLOC_FK',
                                 'PYWORKLOC',
		'Record with '|| ' WRL_CODE '||row_dc.EMP_WRL_CODE||
		' does not exist in DA.PYWORKLOC table.');
 END IF;
END LOOP;
--EMPLOYEE_STATE_FK
 FOR row_dc IN cur_EMPLOYEE_STATE_FK
LOOP
  IF ( row_dc.EMP_COUNTRY_CODE IS NOT NULL 
	 AND  row_dc.EMP_STATE_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_STATE_FK',
                                 'PYSTATE',
		'Record with '|| ' STA_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		','||' STA_STATE_CODE '||row_dc.EMP_STATE_CODE||
		' does not exist in DA.PYSTATE table.');
 END IF;
END LOOP;
--EMPLOYEE_CONTROL_FK
 FOR row_dc IN cur_EMPLOYEE_CONTROL_FK
LOOP
  IF ( row_dc.EMP_COMP_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_CONTROL_FK',
                                 'PYCONTROL',
		'Record with '|| ' CON_COMP_CODE '||row_dc.EMP_COMP_CODE||
		' does not exist in DA.PYCONTROL table.');
 END IF;
END LOOP;
--EMPLOYEE_COUNTY_FK
 FOR row_dc IN cur_EMPLOYEE_COUNTY_FK
LOOP
  IF ( row_dc.EMP_COUNTRY_CODE IS NOT NULL
	 AND  row_dc.EMP_STATE_CODE IS NOT NULL 
	 AND  row_dc.EMP_COUNTY_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_COUNTY_FK',
                                 'PYCOUNTY',
		'Record with '|| ' CNT_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		','||' CNT_STATE_CODE '||row_dc.EMP_STATE_CODE||
		','||' CNT_COUNTY_CODE '||row_dc.EMP_COUNTY_CODE||
		' does not exist in DA.PYCOUNTY table.');
 END IF;
END LOOP;
--EMPLOYEE_COMPAYGRP_FK
 FOR row_dc IN cur_EMPLOYEE_COMPAYGRP_FK
LOOP
  IF ( row_dc.EMP_COMP_CODE IS NOT NULL
	 AND  row_dc.EMP_PYG_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_COMPAYGRP_FK',
                                 'PYCOMPAYGRP',
		'Record with '|| ' PYG_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' PYG_CODE '||row_dc.EMP_PYG_CODE||
		' does not exist in DA.PYCOMPAYGRP table.');
 END IF;
END LOOP;
--EMPLOYEE_TRADES_FK
 FOR row_dc IN cur_EMPLOYEE_TRADES_FK
LOOP
  IF ( row_dc.EMP_TRD_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_TRADES_FK',
                                 'PYTRADES',
		'Record with '|| ' TRD_CODE '||row_dc.EMP_TRD_CODE||
		' does not exist in DA.PYTRADES table.');
 END IF;
END LOOP;
--EMPLOYEE_PAYRCD_FK
 FOR row_dc IN cur_EMPLOYEE_PAYRCD_FK
LOOP
  IF ( row_dc.EMP_RATE_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_PAYRCD_FK',
                                 'PYPAYRCD',
		'Record with '|| ' RCD_CODE '||row_dc.EMP_RATE_CODE||
		' does not exist in DA.PYPAYRCD table.');
 END IF;
END LOOP;
--EMPLOYEE_LANGUAGE_FK
 FOR row_dc IN cur_EMPLOYEE_LANGUAGE_FK
LOOP
  IF ( row_dc.LANGUAGE_LANG_NAME IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_LANGUAGE_FK',
                                 'HRLANGUAGES',
		'Record with '|| ' LANG_NAME '||row_dc.LANGUAGE_LANG_NAME||
		' does not exist in DA.HRLANGUAGES table.');
 END IF;
END LOOP;
--EMPLOYEE_COUNTRY_FK
 FOR row_dc IN cur_EMPLOYEE_COUNTRY_FK
LOOP
  IF ( row_dc.EMP_COUNTRY_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_COUNTRY_FK',
                                 'PYCOUNTRY',
		'Record with '|| ' CTR_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		' does not exist in DA.PYCOUNTRY table.');
 END IF;
END LOOP;

--EMPLOYEE_RES_LOC_FK

/* for row_dc in cur_EMPLOYEE_RES_LOC_FK
loop
  if ( row_dc.EMP_RES_LOC is not null  ) then
	 da.dbk_dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_RES_LOC_FK',
                                 'PYWORKLOC',
		'Record with '|| ' WRL_CODE '||row_dc.EMP_RES_LOC||
		' does not exist in DA.PYWORKLOC table.');
 end if;
end loop;
*/

--EMPLOYEE_CITY_FK
 FOR row_dc IN cur_EMPLOYEE_CITY_FK
LOOP
  IF ( row_dc.EMP_COUNTRY_CODE IS NOT NULL
	 AND  row_dc.EMP_STATE_CODE IS NOT NULL
	 AND  row_dc.EMP_COUNTY_CODE IS NOT NULL
	 AND  row_dc.EMP_CITY_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_CITY_FK',
                                 'PYCITY',
		'Record with '|| ' CTY_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		','||' CTY_STATE_CODE '||row_dc.EMP_STATE_CODE||
		','||' CTY_COUNTY_CODE '||row_dc.EMP_COUNTY_CODE||
		','||' CTY_CITY_CODE '||row_dc.EMP_CITY_CODE||
		' does not exist in DA.PYCITY table.');
 END IF;
END LOOP;
--EMPLOYEE_UNIONS_FK
 FOR row_dc IN cur_EMPLOYEE_UNIONS_FK
LOOP
  IF ( row_dc.EMP_UNI_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_UNIONS_FK',
                                 'PYUNIONS',
		'Record with '|| ' UNI_CODE '||row_dc.EMP_UNI_CODE||
		' does not exist in DA.PYUNIONS table.');
 END IF;
END LOOP;
--EMPLOYEE_BANK_FK
 FOR row_dc IN cur_EMPLOYEE_BANK_FK
LOOP
  IF ( row_dc.EMP_BANK_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_BANK_FK',
                                 'BABANK',
		'Record with '|| ' BNK_BANK_CODE '||row_dc.EMP_BANK_CODE||
		' does not exist in DA.BABANK table.');
 END IF;
END LOOP;
--EMPLOYEE_DEPT_FK
 FOR row_dc IN cur_EMPLOYEE_DEPT_FK
LOOP
  IF ( row_dc.EMP_COMP_CODE IS NOT NULL 
	 AND  row_dc.EMP_DEPT_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_DEPT_FK',
                                 'DEPT',
		'Record with '|| ' DEPT_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' DEPT_CODE '||row_dc.EMP_DEPT_CODE||
		' does not exist in DA.DEPT_TABLE table.');
 END IF;
END LOOP;
--EMPLOYEE_DISABILITY_FK
 FOR row_dc IN cur_EMPLOYEE_DISABILITY_FK
LOOP
  IF ( row_dc.DISABILITY_DIS_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_DISABILITY_FK',
                                 'HRDISABILITY',
		'Record with '|| ' DIS_CODE '||row_dc.DISABILITY_DIS_CODE||
		' does not exist in DA.HRDISABILITY table.');
 END IF;
END LOOP;
--EMPLOYEE_BRANCH_FK
 FOR row_dc IN cur_EMPLOYEE_BRANCH_FK
LOOP
  IF ( row_dc.EMP_BANK_CODE IS NOT NULL 
	 AND  row_dc.EMP_BRANCH_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_BRANCH_FK',
                                 'BABRANCH',
		'Record with '|| ' BRN_BANK_CODE '||row_dc.EMP_BANK_CODE||
		','||' BRN_BRANCH_CODE '||row_dc.EMP_BRANCH_CODE||
		' does not exist in DA.BABRANCH table.');
 END IF;
END LOOP;
--EMPLOYEE_PAYRUN_FK
 FOR row_dc IN cur_EMPLOYEE_PAYRUN_FK
LOOP
  IF ( row_dc.EMP_PRN_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_PAYRUN_FK',
                                 'PYPAYRUN',
		'Record with '|| ' PRN_CODE '||row_dc.EMP_PRN_CODE||
		' does not exist in DA.PYPAYRUN table.');
 END IF;
END LOOP;

--EMPLOYEE_JCJOBCAT_FK
 FOR row_dc IN cur_EMPLOYEE_JCJOBCAT_FK
LOOP
  IF ( row_dc.EMP_COMP_CODE IS NOT NULL 
	 AND  row_dc.EMP_JOB_CODE IS NOT NULL 
	 AND  row_dc.EMP_PHS_CODE IS NOT NULL 
	 AND  row_dc.EMP_CAT_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMPLOYEE_JCJOBCAT_FK',
                                 'JCJOBCAT',
		'Record with '|| ' JCAT_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' JCAT_JOB_CODE '||row_dc.EMP_JOB_CODE||
		','||' JCAT_PHS_CODE '||row_dc.EMP_PHS_CODE||
		','||' JCAT_CODE '||row_dc.EMP_CAT_CODE||
		' does not exist in DA.JCJOBCAT table.');
 END IF;
END LOOP;

--EMP_EXP_APRV_GRP_CODE_FK
 FOR row_dc IN cur_EMP_EXP_APRV_GRP_CODE_FK
LOOP
  IF ( row_dc.EMP_EXP_APRV_GRP_CODE IS NOT NULL  ) THEN
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                                 row_dc.dc_rownum,
                                 'EMP_EXP_APRV_GRP_CODE_FK',
                                 'PYEXPAPGRP',
		'Record with '|| ' EMP_EXP_APRV_GRP_CODE '||row_dc.EMP_EXP_APRV_GRP_CODE||
		' does not exist in DA.PYEXPAPGRP table.');
 END IF;
END LOOP;

END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--SYS_C0022490 - EMP_PRN_CODE IS NOT NULL
 CURSOR cur_SYS_C0022490 IS
        SELECT dc_rownum
          FROM DA.DC_PYEMPLOYEE_TABLE
            WHERE NOT EMP_PRN_CODE IS NOT NULL ;

--SYS_C0022489 - EMP_NO IS NOT NULL
 CURSOR cur_SYS_C0022489 IS
        SELECT dc_rownum
          FROM DA.DC_PYEMPLOYEE_TABLE
            WHERE NOT EMP_NO IS NOT NULL ;

--SYS_C0022491 - EMP_USER IS NOT NULL
 CURSOR cur_SYS_C0022491 IS
        SELECT dc_rownum
          FROM DA.DC_PYEMPLOYEE_TABLE
            WHERE NOT EMP_USER IS NOT NULL ;

--SYS_C0022492 - EMP_LAST_UPD_DATE IS NOT NULL
 CURSOR cur_SYS_C0022492 IS
        SELECT dc_rownum
          FROM DA.DC_PYEMPLOYEE_TABLE
            WHERE NOT EMP_LAST_UPD_DATE IS NOT NULL ;

BEGIN
NULL;

 FOR row_dc IN cur_SYS_C0022490
 LOOP
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C0022490',
                    'SYS_C0022490',
                    'Condition EMP_PRN_CODE IS NOT NULL failed.');
 END LOOP;

 FOR row_dc IN cur_SYS_C0022489
 LOOP
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C0022489',
                    'SYS_C0022489',
                    'Condition EMP_NO IS NOT NULL failed.');
 END LOOP;

 FOR row_dc IN cur_SYS_C0022491
 LOOP
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C0022491',
                    'SYS_C0022491',
                    'Condition EMP_USER IS NOT NULL failed.');
 END LOOP;

 FOR row_dc IN cur_SYS_C0022492
 LOOP
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                    row_dc.dc_rownum,
                    'SYS_C0022492',
                    'SYS_C0022492',
                    'Condition EMP_LAST_UPD_DATE IS NOT NULL failed.');
 END LOOP;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.PYEMPLOYEE_TABLE table
--======================================================================
PROCEDURE IDX_CHECK AS

--EMPLOYEE_PK
CURSOR cur_EMPLOYEE_PK IS
  SELECT dc_rownum,
	 EMP_NO
    FROM DA.DC_PYEMPLOYEE_TABLE S1
      WHERE EXISTS (SELECT '1'
      		      FROM DA.PYEMPLOYEE_TABLE S2
			WHERE S1.EMP_NO = S2.EMP_NO );
BEGIN
 NULL; 

--EMPLOYEE_PK
 FOR row_dc IN cur_EMPLOYEE_PK
 LOOP
 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,
		'EMPLOYEE_PK',
		'EMPLOYEE_PK',
                'Record with '||'EMP_NO '||row_dc.EMP_NO ||
		' already exists in DA.PYEMPLOYEE_TABLE table.');

 END LOOP;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_PYEMPLOYEE_TABLE table
--======================================================================
PROCEDURE IDX_DUPL AS

--EMPLOYEE_PK
CURSOR cur_EMPLOYEE_PK IS
  SELECT dc_rownum,
	 EMP_NO
    FROM DA.DC_PYEMPLOYEE_TABLE S1
      WHERE
	EXISTS (SELECT '1'
		  FROM DA.DC_PYEMPLOYEE_TABLE S2
		    WHERE S1.EMP_NO = S2.EMP_NO
		      AND S1.ROWID != S2.ROWID );
BEGIN
 NULL; 

--EMPLOYEE_PK
 FOR row_dc IN cur_EMPLOYEE_PK
 LOOP
 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,
		'EMPLOYEE_PK',
 		'EMPLOYEE_PK',
                'Record with '||'EMP_NO '||row_dc.EMP_NO ||
		' already exists in DA.DC_PYEMPLOYEE_TABLE table.');
END LOOP;
END IDX_DUPL;

--=====================================================================
--modify - update flags if
--         need to move to very fisrt place in the package
--=====================================================================
PROCEDURE MODIFY AS
BEGIN
 --emp_payment_mode
  UPDATE da.dc_pyemployee_table
    SET emp_payment_mode = 'C'
     WHERE emp_payment_mode = 'D';

  UPDATE da.dc_pyemployee_table
    SET EMP_OT_ELIGIBILITY = 'N';

EXCEPTION WHEN OTHERS THEN
    display_status('MODIFY: Can not modify DA.DC_EMPLOYEE table.');
    da.Dbk_Dc.output(SQLERRM);
END MODIFY;

--======================================================================
--EMP_NO
--======================================================================
PROCEDURE EMP_NO AS
  CURSOR cur_EMP_NO_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_NO IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_NO_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_NO',
        'EMP_NO',
        'EMP_NO can not be null.');
  END LOOP;
END EMP_NO;

--======================================================================
--EMP_FIRST_NAME
--======================================================================
PROCEDURE EMP_FIRST_NAME AS
  CURSOR cur_EMP_FIRST_NAME_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_FIRST_NAME IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_FIRST_NAME_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_FIRST_NAME',
        'EMP_FIRST_NAME',
        'EMP_FIRST_NAME can not be null.');
  END LOOP;
END EMP_FIRST_NAME;

--======================================================================
--EMP_LAST_NAME
--======================================================================
PROCEDURE EMP_LAST_NAME AS
  CURSOR cur_EMP_LAST_NAME_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_LAST_NAME IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_LAST_NAME_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_LAST_NAME',
        'EMP_LAST_NAME',
        'EMP_LAST_NAME can not be null.');
  END LOOP;
END EMP_LAST_NAME;

--======================================================================
--EMP_SIN_NO
--======================================================================
PROCEDURE EMP_SIN_NO AS
  CURSOR cur_EMP_SIN_NO_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_SIN_NO IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_SIN_NO_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_SIN_NO',
        'EMP_SIN_NO',
        'EMP_SIN_NO can not be null.');
  END LOOP;
END EMP_SIN_NO;

--======================================================================
--TYPE
--======================================================================
PROCEDURE TYPE AS
  CURSOR cur_TYPE IS
    SELECT dc_rownum,
           EMP_TYPE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_TYPE,'xxxx') NOT IN ('H','S');
BEGIN
  FOR row_dc IN cur_TYPE
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_TYPE',
        'EMP_TYPE',
        'EMP_TYPE must be set to ''H'',''S''.');

  END LOOP;
END TYPE;

--======================================================================
--UNIONIZED
--======================================================================
PROCEDURE UNIONIZED AS
  CURSOR cur_UNIONIZED IS
    SELECT dc_rownum,
           EMP_UNIONIZED
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_UNIONIZED,'xxxx') NOT IN ('N','Y');
BEGIN
  FOR row_dc IN cur_UNIONIZED
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_UNIONIZED',
        'EMP_UNIONIZED',
        'EMP_UNIONIZED must be set to ''N'',''Y''.');

  END LOOP;
END UNIONIZED;

--======================================================================
--EMP_ZIP_CODE
--======================================================================
PROCEDURE EMP_ZIP_CODE AS
  CURSOR cur_EMP_ZIP_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_ZIP_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_ZIP_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_ZIP_CODE',
        'EMP_ZIP_CODE',
        'EMP_ZIP_CODE can not be null.');
  END LOOP;
END EMP_ZIP_CODE;

--======================================================================
--EMP_COUNTRY_CODE
--======================================================================
PROCEDURE EMP_COUNTRY_CODE AS
  CURSOR cur_EMP_COUNTRY_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_COUNTRY_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_COUNTRY_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_COUNTRY_CODE',
        'EMP_COUNTRY_CODE',
        'EMP_COUNTRY_CODE can not be null.');
  END LOOP;
END EMP_COUNTRY_CODE;

--======================================================================
--EMP_COUNTRY_CODE_2
--======================================================================
PROCEDURE EMP_COUNTRY_CODE_2 AS
  CURSOR cur_EMP_COUNTRY_CODE_2 IS
    SELECT dc_rownum,
	   EMP_COUNTRY_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYCOUNTRY  T2
                          WHERE T1.EMP_COUNTRY_CODE = T2.CTR_COUNTRY_CODE );

BEGIN
  FOR row_dc IN cur_EMP_COUNTRY_CODE_2
  LOOP
    IF ( row_dc.EMP_COUNTRY_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_COUNTRY_CODE',
                'PYCOUNTRY',
                'Record with'||
		' CTR_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		' does not exist in DA.PYCOUNTRY table.'); 
    END IF;
 END LOOP;

END EMP_COUNTRY_CODE_2;

--======================================================================
--EMP_STATE_CODE
--======================================================================
PROCEDURE EMP_STATE_CODE AS
  CURSOR cur_EMP_STATE_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_STATE_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_STATE_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_STATE_CODE',
        'EMP_STATE_CODE',
        'EMP_STATE_CODE can not be null.');
  END LOOP;
END EMP_STATE_CODE;

--======================================================================
--EMP_STATE_CODE_2
--======================================================================
PROCEDURE EMP_STATE_CODE_2 AS
  CURSOR cur_EMP_STATE_CODE_2 IS
    SELECT dc_rownum,
	   EMP_COUNTRY_CODE,
	   EMP_STATE_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYSTATE  T2
                          WHERE T1.EMP_COUNTRY_CODE = T2.STA_COUNTRY_CODE
			    AND T1.EMP_STATE_CODE = T2.STA_STATE_CODE );

BEGIN
  FOR row_dc IN cur_EMP_STATE_CODE_2
  LOOP
    IF ( row_dc.EMP_STATE_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_STATE_CODE',
                'PYSTATE',
                'Record with'||
		' STA_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		','||' STA_STATE_CODE '||row_dc.EMP_STATE_CODE||
		' does not exist in DA.PYSTATE table.');
    END IF;
 END LOOP;

END EMP_STATE_CODE_2;

--======================================================================
--EMP_COUNTY_CODE
--======================================================================
PROCEDURE EMP_COUNTY_CODE AS
  CURSOR cur_EMP_COUNTY_CODE IS
    SELECT dc_rownum,
	   EMP_COUNTRY_CODE,
	   EMP_STATE_CODE,
	   EMP_COUNTY_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYCOUNTY  T2
                          WHERE T1.EMP_COUNTRY_CODE = T2.CNT_COUNTRY_CODE
			    AND T1.EMP_STATE_CODE = T2.CNT_STATE_CODE
			    AND T1.EMP_COUNTY_CODE = T2.CNT_COUNTY_CODE );

BEGIN
  FOR row_dc IN cur_EMP_COUNTY_CODE
  LOOP
    IF ( row_dc.EMP_COUNTY_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_COUNTY_CODE',
                'PYCOUNTY',
                'Record with'||
		' CNT_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		','||' CNT_STATE_CODE '||row_dc.EMP_STATE_CODE||
		','||' CNT_COUNTY_CODE '||row_dc.EMP_COUNTY_CODE||
		' does not exist in DA.PYCOUNTY table.'); 
    END IF;
 END LOOP;

END EMP_COUNTY_CODE;

--======================================================================
--EMP_CITY_CODE
--======================================================================
PROCEDURE EMP_CITY_CODE AS
  CURSOR cur_EMP_CITY_CODE IS
    SELECT dc_rownum,
	   EMP_COUNTRY_CODE,
	   EMP_STATE_CODE,
	   EMP_COUNTY_CODE,
	   EMP_CITY_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYCITY  T2
                          WHERE T1.EMP_COUNTRY_CODE = T2.CTY_COUNTRY_CODE
			    AND T1.EMP_STATE_CODE = T2.CTY_STATE_CODE
			    AND T1.EMP_COUNTY_CODE = T2.CTY_COUNTY_CODE
			    AND T1.EMP_CITY_CODE = T2.CTY_CITY_CODE );

BEGIN
  FOR row_dc IN cur_EMP_CITY_CODE
  LOOP
    IF ( row_dc.EMP_CITY_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_CITY_CODE',
                'PYCITY',
                'Record with'||
		' CTY_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		','||' CTY_STATE_CODE '||row_dc.EMP_STATE_CODE||
		','||' CTY_COUNTY_CODE '||row_dc.EMP_COUNTY_CODE||
		','||' CTY_CITY_CODE '||row_dc.EMP_CITY_CODE||
		' does not exist in DA.PYCITY table.'); 
    END IF;
 END LOOP;

END EMP_CITY_CODE;

--======================================================================
--EMP_VERTEX_GEOCODE
--======================================================================
PROCEDURE EMP_VERTEX_GEOCODE AS
  CURSOR cur_EMP_VERTEX_GEOCODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_VERTEX_GEOCODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_VERTEX_GEOCODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_VERTEX_GEOCODE',
        'EMP_VERTEX_GEOCODE',
        'EMP_VERTEX_GEOCODE can not be null.');
  END LOOP;
END EMP_VERTEX_GEOCODE;

--======================================================================
--FILING_STATUS
--======================================================================
PROCEDURE FILING_STATUS AS
  CURSOR cur_FILING_STATUS IS
    SELECT dc_rownum,
           EMP_FILING_STATUS
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_FILING_STATUS,'xxxx') NOT IN ('01','02','03','04');
BEGIN
  FOR row_dc IN cur_FILING_STATUS
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_FILING_STATUS',
        'EMP_FILING_STATUS',
        'EMP_FILING_STATUS must be set to ''01'',''02'',''03'',''04''.');

  END LOOP;
END FILING_STATUS;

--======================================================================
--NR_CERTIFICATE
--======================================================================
PROCEDURE NR_CERTIFICATE AS
  CURSOR cur_NR_CERTIFICATE IS
    SELECT dc_rownum,
           EMP_NR_CERTIFICATE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_NR_CERTIFICATE,'xxxx') NOT IN ('Y','N');
BEGIN
  FOR row_dc IN cur_NR_CERTIFICATE
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_NR_CERTIFICATE',
        'EMP_NR_CERTIFICATE',
        'EMP_NR_CERTIFICATE must be set to ''Y'',''N''.');

  END LOOP;
END NR_CERTIFICATE;

--======================================================================
--EMP_COMP_CODE
--======================================================================
PROCEDURE EMP_COMP_CODE AS
  CURSOR cur_EMP_COMP_CODE IS
    SELECT dc_rownum,
           EMP_COMP_CODE
      FROM DA.DC_PYEMPLOYEE_TABLE  ;

 t_result        da.Apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 FOR row_dc IN cur_EMP_COMP_CODE
 LOOP
   t_result := da.Apk_Gl_Company.chk(da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE),
              row_dc.EMP_COMP_CODE,t_comp_name);
   IF ('0' != t_result) THEN
         da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
         	row_dc.dc_rownum,
                'EMP_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   END IF;
 END LOOP;
END EMP_COMP_CODE;

--======================================================================
--DEPT_CODE
--======================================================================
PROCEDURE DEPT_CODE AS

 t_result        da.Apkc.t_result_type%TYPE;
 t_dept_name     da.dept_table.dept_name%TYPE;

CURSOR cur_dept_code IS
  SELECT dc_rownum,
         EMP_COMP_CODE,
         EMP_DEPT_CODE
   FROM  DA.DC_PYEMPLOYEE_TABLE ;

BEGIN
 FOR row_dc IN cur_dept_code
 LOOP
  t_result := da.Apk_Gl_Dept.chk(da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE),
                row_dc.EMP_COMP_CODE,
                row_dc.EMP_DEPT_CODE,
                t_dept_name);
 IF (t_result != '0')
 THEN
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
    		row_dc.dc_rownum,
                'EMP_DEPT_CODE',
                'DEPT_CODE',
                t_result);
 END IF;

END LOOP;
END DEPT_CODE;

--======================================================================
--EMP_WRL_CODE
--======================================================================
PROCEDURE EMP_WRL_CODE AS
  CURSOR cur_EMP_WRL_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_WRL_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_WRL_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_WRL_CODE',
        'EMP_WRL_CODE',
        'EMP_WRL_CODE can not be null.');
  END LOOP;
END EMP_WRL_CODE;

--======================================================================
--EMP_WRL_CODE_2
--======================================================================
PROCEDURE EMP_WRL_CODE_2 AS
  CURSOR cur_EMP_WRL_CODE_2 IS
    SELECT dc_rownum,
	   EMP_WRL_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYWORKLOC  T2
                          WHERE T1.EMP_WRL_CODE = T2.WRL_CODE );

BEGIN
  FOR row_dc IN cur_EMP_WRL_CODE_2
  LOOP
    IF ( row_dc.EMP_WRL_CODE IS NOT NULL ) THEN
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_WRL_CODE',
                'PYWORKLOC',
                'Record with'||
		' WRL_CODE '||row_dc.EMP_WRL_CODE||
		' does not exist in DA.PYWORKLOC table.');
    END IF;
 END LOOP;

END EMP_WRL_CODE_2;

--======================================================================
--EMP_RES_LOC
--======================================================================
PROCEDURE EMP_RES_LOC AS
  CURSOR cur_EMP_RES_LOC IS
    SELECT dc_rownum,
	   EMP_RES_LOC
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYWORKLOC  T2
                          WHERE T1.EMP_RES_LOC = T2.WRL_CODE );

BEGIN
  FOR row_dc IN cur_EMP_RES_LOC
  LOOP
    IF ( row_dc.EMP_RES_LOC IS NOT NULL ) THEN
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_RES_LOC',
                'PYWORKLOC',
                'Record with'||
		' WRL_CODE '||row_dc.EMP_RES_LOC||
		' does not exist in DA.PYWORKLOC table.');
    END IF;
 END LOOP;

END EMP_RES_LOC;

--======================================================================
--EMP_JOB_CODE
--======================================================================
PROCEDURE EMP_JOB_CODE AS
  CURSOR cur_EMP_JOB_CODE IS
    SELECT dc_rownum,
	   EMP_COMP_CODE,
	   EMP_JOB_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE REPLACE(emp_job_code,'0','') IS NOT NULL
	    AND NOT EXISTS (SELECT '1'
                        FROM DA.JCJOB_TABLE  T2
                          WHERE T1.EMP_COMP_CODE = T2.JOB_COMP_CODE
                            AND T1.EMP_JOB_CODE = T2.JOB_CODE );

BEGIN
  FOR row_dc IN cur_EMP_JOB_CODE
  LOOP
 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
               row_dc.dc_rownum,
               'EMP_JOB_CODE',
               'JCJOB',
               'Record with'||
	' JOB_COMP_CODE '||row_dc.EMP_COMP_CODE||
	','||' JOB_CODE '||row_dc.EMP_JOB_CODE||
	' does not exist in DA.JCJOB table.'); 
 END LOOP;

END EMP_JOB_CODE;

--======================================================================
--EMP_PHS_CODE
--======================================================================
PROCEDURE EMP_PHS_CODE AS
  CURSOR cur_EMP_PHS_CODE IS
    SELECT dc_rownum,
	   EMP_COMP_CODE,
	   EMP_PHS_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.JCMPHS  T2
                          WHERE T1.EMP_COMP_CODE = T2.PHS_COMP_CODE
			    AND T1.EMP_PHS_CODE = T2.PHS_CODE );

BEGIN
  FOR row_dc IN cur_EMP_PHS_CODE
  LOOP
    IF ( row_dc.EMP_PHS_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_PHS_CODE',
                'JCMPHS',
                'Record with'||
		' PHS_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' PHS_CODE '||row_dc.EMP_PHS_CODE||
		' does not exist in DA.JCMPHS table.'); 
    END IF;
 END LOOP;

END EMP_PHS_CODE;

--======================================================================
--EMP_CAT_CODE
--======================================================================
PROCEDURE EMP_CAT_CODE AS
  CURSOR cur_EMP_CAT_CODE IS
    SELECT dc_rownum,
	   EMP_COMP_CODE,
	   EMP_CAT_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.JCCAT  T2
                          WHERE T1.EMP_COMP_CODE = T2.CAT_COMP_CODE
			    AND T1.EMP_CAT_CODE = T2.CAT_CODE );

BEGIN
  FOR row_dc IN cur_EMP_CAT_CODE
  LOOP
    IF ( row_dc.EMP_CAT_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_CAT_CODE',
                'JCCAT',
                'Record with'||
		' CAT_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' CAT_CODE '||row_dc.EMP_CAT_CODE||
		' does not exist in DA.JCCAT table.');
    END IF;
 END LOOP;

END EMP_CAT_CODE;

--======================================================================
--EMP_UNI_CODE
--======================================================================
PROCEDURE EMP_UNI_CODE AS
  CURSOR cur_EMP_UNI_CODE IS
    SELECT dc_rownum,
	   EMP_UNI_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYUNIONS  T2
                          WHERE T1.EMP_UNI_CODE = T2.UNI_CODE );

BEGIN
  FOR row_dc IN cur_EMP_UNI_CODE
  LOOP
    IF ( row_dc.EMP_UNI_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_UNI_CODE',
                'PYUNIONS',
                'Record with'||
		' UNI_CODE '||row_dc.EMP_UNI_CODE||
		' does not exist in DA.PYUNIONS table.');
    END IF;
 END LOOP;

END EMP_UNI_CODE;

--======================================================================
--EMP_TRD_CODE
--======================================================================
PROCEDURE EMP_TRD_CODE AS
  CURSOR cur_EMP_TRD_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_TRD_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_TRD_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_TRD_CODE',
        'EMP_TRD_CODE',
        'EMP_TRD_CODE can not be null.');
  END LOOP;
END EMP_TRD_CODE;

--======================================================================
--EMP_TRD_CODE_2
--======================================================================
PROCEDURE EMP_TRD_CODE_2 AS
  CURSOR cur_EMP_TRD_CODE_2 IS
    SELECT dc_rownum,
	   EMP_TRD_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYTRADES  T2
                          WHERE T1.EMP_TRD_CODE = T2.TRD_CODE );

BEGIN
  FOR row_dc IN cur_EMP_TRD_CODE_2
  LOOP
    IF ( row_dc.EMP_TRD_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_TRD_CODE',
                'PYTRADES',
                'Record with'||
		' TRD_CODE '||row_dc.EMP_TRD_CODE||
		' does not exist in DA.PYTRADES table.'); 
    END IF;
 END LOOP;

END EMP_TRD_CODE_2;

--======================================================================
--EMP_PYG_CODE
--======================================================================
PROCEDURE EMP_PYG_CODE AS
  CURSOR cur_EMP_PYG_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_PYG_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_PYG_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PYG_CODE',
        'EMP_PYG_CODE',
        'EMP_PYG_CODE can not be null.');
  END LOOP;
END EMP_PYG_CODE;

--======================================================================
--EMP_PYG_CODE_2
--======================================================================
PROCEDURE EMP_PYG_CODE_2 AS
  CURSOR cur_EMP_PYG_CODE_2 IS
    SELECT dc_rownum,
	   EMP_COMP_CODE,
	   EMP_PYG_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYCOMPAYGRP  T2
                          WHERE T1.EMP_COMP_CODE = T2.PYG_COMP_CODE
			    AND T1.EMP_PYG_CODE = T2.PYG_CODE );

BEGIN
  FOR row_dc IN cur_EMP_PYG_CODE_2
  LOOP
    IF ( row_dc.EMP_PYG_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_PYG_CODE',
                'PYCOMPAYGRP',
                'Record with'||
		' PYG_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' PYG_CODE '||row_dc.EMP_PYG_CODE||
		' does not exist in DA.PYCOMPAYGRP table.');
    END IF;
 END LOOP;

END EMP_PYG_CODE_2;

--======================================================================
--EMP_HIRE_DATE
--======================================================================
PROCEDURE EMP_HIRE_DATE AS
  CURSOR cur_EMP_HIRE_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_HIRE_DATE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_HIRE_DATE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_HIRE_DATE',
        'EMP_HIRE_DATE',
        'EMP_HIRE_DATE can not be null.');
  END LOOP;
END EMP_HIRE_DATE;

--======================================================================
--ETHNIC_CODE
--======================================================================
PROCEDURE ETHNIC_CODE AS
  CURSOR cur_ETHNIC_CODE IS
    SELECT dc_rownum,
           EMP_ETHNIC_CODE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_ETHNIC_CODE,'xxxx') NOT IN ('W','B','H','A','I','X','P','M');
BEGIN
  FOR row_dc IN cur_ETHNIC_CODE
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_ETHNIC_CODE',
        'EMP_ETHNIC_CODE',
        'EMP_ETHNIC_CODE must be set to ''W'',''B'',''H'',''A'',''P'',''M'',''I'', or ''X''.');

  END LOOP;
END ETHNIC_CODE;

--======================================================================
--SEX
--======================================================================
PROCEDURE SEX AS
  CURSOR cur_SEX IS
    SELECT dc_rownum,
           EMP_SEX
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_SEX,'xxxx') NOT IN ('M','F');
BEGIN
  FOR row_dc IN cur_SEX
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_SEX',
        'EMP_SEX',
        'EMP_SEX must be set to ''M'',''F''.');

  END LOOP;
END SEX;

--======================================================================
--MARITAL_STATUS
--======================================================================
PROCEDURE MARITAL_STATUS AS
  CURSOR cur_MARITAL_STATUS IS
    SELECT dc_rownum,
           EMP_MARITAL_STATUS
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_MARITAL_STATUS,'xxxx') NOT IN ('S','M','W','D','C');
BEGIN
  FOR row_dc IN cur_MARITAL_STATUS
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_MARITAL_STATUS',
        'EMP_MARITAL_STATUS',
        'EMP_MARITAL_STATUS must be set to ''S'',''M'',''W'',''D'',''C''.');

  END LOOP;
END MARITAL_STATUS;

--======================================================================
--RESIDENT_STATUS
--======================================================================
PROCEDURE RESIDENT_STATUS AS
  CURSOR cur_RESIDENT_STATUS IS
    SELECT dc_rownum,
           EMP_RESIDENT_STATUS
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_RESIDENT_STATUS,'xxxx') NOT IN ('C','I','R','W');
BEGIN
  FOR row_dc IN cur_RESIDENT_STATUS
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_RESIDENT_STATUS',
        'EMP_RESIDENT_STATUS',
        'EMP_RESIDENT_STATUS must be set to ''C'',''I'',''R'',''W''.');

  END LOOP;
END RESIDENT_STATUS;

--======================================================================
--OT_ELIGIBILITY
--======================================================================
PROCEDURE OT_ELIGIBILITY AS
  CURSOR cur_OT_ELIGIBILITY IS
    SELECT dc_rownum,
           EMP_OT_ELIGIBILITY
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_OT_ELIGIBILITY,'xxxx') NOT IN ('N','Y');
BEGIN
  FOR row_dc IN cur_OT_ELIGIBILITY
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_OT_ELIGIBILITY',
        'EMP_OT_ELIGIBILITY',
        'EMP_OT_ELIGIBILITY must be set to ''N'',''Y''.');

  END LOOP;
END OT_ELIGIBILITY;

--======================================================================
--PAYMENT_MODE
--======================================================================
PROCEDURE PAYMENT_MODE AS
  CURSOR cur_PAYMENT_MODE IS
    SELECT dc_rownum,
           EMP_PAYMENT_MODE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_PAYMENT_MODE,'xxxx') NOT IN ('C');
BEGIN
  FOR row_dc IN cur_PAYMENT_MODE
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PAYMENT_MODE',
        'EMP_PAYMENT_MODE',
        'EMP_PAYMENT_MODE must be set to ''C''.');

  END LOOP;
END PAYMENT_MODE;

--======================================================================
--EMP_BANK_CODE
--======================================================================
PROCEDURE EMP_BANK_CODE AS
  CURSOR cur_EMP_BANK_CODE IS
    SELECT dc_rownum,
	   EMP_BANK_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.BABANK  T2
                          WHERE T1.EMP_BANK_CODE = T2.BNK_BANK_CODE );

BEGIN
  FOR row_dc IN cur_EMP_BANK_CODE
  LOOP
    IF ( row_dc.EMP_BANK_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_BANK_CODE',
                'BABANK',
                'Record with'||
		' BNK_BANK_CODE '||row_dc.EMP_BANK_CODE||
		' does not exist in DA.BABANK table.'); 
    END IF;
 END LOOP;

END EMP_BANK_CODE;

--======================================================================
--EMP_BRANCH_CODE
--======================================================================
PROCEDURE EMP_BRANCH_CODE AS
  CURSOR cur_EMP_BRANCH_CODE IS
    SELECT dc_rownum,
	   EMP_BANK_CODE,
	   EMP_BRANCH_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.BABRANCH  T2
                          WHERE T1.EMP_BANK_CODE = T2.BRN_BANK_CODE
			    AND T1.EMP_BRANCH_CODE = T2.BRN_BRANCH_CODE );

BEGIN
  FOR row_dc IN cur_EMP_BRANCH_CODE
  LOOP
    IF ( row_dc.EMP_BRANCH_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_BRANCH_CODE',
                'BABRANCH',
                'Record with'||
		' BRN_BANK_CODE '||row_dc.EMP_BANK_CODE||
		','||' BRN_BRANCH_CODE '||row_dc.EMP_BRANCH_CODE||
		' does not exist in DA.BABRANCH table.');
    END IF;
 END LOOP;

END EMP_BRANCH_CODE;

--======================================================================
--EMP_BANK_AC_NO
--======================================================================
PROCEDURE EMP_BANK_AC_NO AS
  CURSOR cur_EMP_BANK_AC_NO IS
    SELECT dc_rownum,
	   EMP_BANK_CODE,
	   EMP_BRANCH_CODE,
	   EMP_BANK_AC_NO
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.BABANKACC  T2
                          WHERE T1.EMP_BANK_CODE = T2.BAB_BANK_CODE
			    AND T1.EMP_BRANCH_CODE = T2.BAB_BRANCH_CODE
			    AND T1.EMP_BANK_AC_NO = T2.BAB_BANK_ACC_NUM );

BEGIN
  FOR row_dc IN cur_EMP_BANK_AC_NO
  LOOP
    IF ( row_dc.EMP_BANK_AC_NO IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_BANK_AC_NO',
                'BABANKACC',
                'Record with'||
		' BAB_BANK_CODE '||row_dc.EMP_BANK_CODE||
		','||' BAB_BRANCH_CODE '||row_dc.EMP_BRANCH_CODE||
		','||' BAB_BANK_ACC_NUM '||row_dc.EMP_BANK_AC_NO||
		' does not exist in DA.BABANKACC table.'); 
    END IF;
 END LOOP;

END EMP_BANK_AC_NO;

--======================================================================
--EMP_PRN_CODE
--======================================================================
PROCEDURE EMP_PRN_CODE AS
  CURSOR cur_EMP_PRN_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_PRN_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_PRN_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PRN_CODE',
        'EMP_PRN_CODE',
        'EMP_PRN_CODE can not be null.');
  END LOOP;
END EMP_PRN_CODE;

--======================================================================
--EMP_PRN_CODE_2
--======================================================================
PROCEDURE EMP_PRN_CODE_2 AS
  CURSOR cur_EMP_PRN_CODE_2 IS
    SELECT dc_rownum,
	   EMP_PRN_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYPAYRUN  T2
                          WHERE T1.EMP_PRN_CODE = T2.PRN_CODE );

BEGIN
  FOR row_dc IN cur_EMP_PRN_CODE_2
  LOOP
    IF ( row_dc.EMP_PRN_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_PRN_CODE',
                'PYPAYRUN',
                'Record with'||
		' PRN_CODE '||row_dc.EMP_PRN_CODE||
		' does not exist in DA.PYPAYRUN table.'); 
    END IF;
 END LOOP;

END EMP_PRN_CODE_2;

--======================================================================
--EMP_WCB_CODE
--======================================================================
PROCEDURE EMP_WCB_CODE AS
  CURSOR cur_EMP_WCB_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE, DA.PYCONTROL
        WHERE EMP_WCB_CODE IS NULL
		  AND emp_comp_code = con_comp_code(+)
		  AND NVL(con_wc_flag,'N') = 'Y';
BEGIN
  FOR row_dc IN cur_EMP_WCB_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_WCB_CODE',
        'EMP_WCB_CODE',
        'EMP_WCB_CODE cannot be null if Workers Compensation is being calculated.');
  END LOOP;
END EMP_WCB_CODE;

--======================================================================
--EMP_WCB_CODE_2
--======================================================================
PROCEDURE EMP_WCB_CODE_2 AS
  CURSOR cur_EMP_WCB_CODE_2 IS
    SELECT dc_rownum,
	   EMP_COMP_CODE,
           EMP_WRL_CODE,
	   EMP_WCB_CODE
      FROM DA.DC_PYEMPLOYEE_TABLE T1
      WHERE EMP_WCB_CODE IS NOT NULL
  MINUS
     SELECT dc_rownum
     	,EMP_COMP_CODE
        ,EMP_WRL_CODE
	,EMP_WCB_CODE
     FROM DA.DC_PYEMPLOYEE_TABLE T1
         ,DA.PYWCBCODE WCB
         ,DA.PYWORKLOC WL
    WHERE T1.EMP_WCB_CODE IS NOT NULL
          -- Get Employee's default Work Location
      AND T1.EMP_WRL_CODE  = WL.WRL_CODE
          -- Get WCB for Employee's default Work Location
      AND T1.EMP_COMP_CODE    = WCB.WCC_COMP_CODE
      AND WL.WRL_COUNTRY_CODE = WCB.WCC_COUNTRY_CODE
      AND WL.WRL_STATE_CODE   = WCB.WCC_STATE_CODE
      AND T1.EMP_WCB_CODE     = WCB.WCC_WCB_CODE;

  CURSOR cur_pyworkloc (cp_wrl_code  DA.PYWORKLOC.WRL_CODE%TYPE) IS
    SELECT wrl_country_code,
           wrl_state_code
      FROM da.pyworkloc
        WHERE wrl_code = cp_wrl_code;


  t_wrl_code    	DA.PYWORKLOC.WRL_CODE%TYPE;
  t_wrl_country_code    DA.PYWORKLOC.WRL_COUNTRY_CODE%TYPE;
  t_wrl_state_code      DA.PYWORKLOC.WRL_STATE_CODE%TYPE;

BEGIN
  FOR row_dc IN cur_EMP_WCB_CODE_2
  LOOP
     IF NVL(row_dc.emp_wrl_code,'xxxxxx') !=
     	NVL(t_wrl_code,'yyyyyy')
     THEN
         OPEN  cur_pyworkloc(row_dc.emp_wrl_code);
         FETCH cur_pyworkloc INTO t_wrl_country_code, t_wrl_state_code;
         CLOSE cur_pyworkloc;
     END IF;

 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_WCB_CODE',
                'PYWCBCODE',
                'Record with'||
		' WCC_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' WCC_COUNTRY_CODE '||T_WRL_COUNTRY_CODE||
		','||' WCC_STATE_CODE '||T_WRL_STATE_CODE||
		','||' WCC_WCB_CODE '||row_dc.EMP_WCB_CODE||
		' does not exist in DA.PYWCBCODE table.');
 END LOOP;

END EMP_WCB_CODE_2;

--======================================================================
--WCB_BY_JOB
--======================================================================
PROCEDURE WCB_BY_JOB AS
  CURSOR cur_WCB_BY_JOB IS
    SELECT dc_rownum,
           EMP_WCB_BY_JOB
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_WCB_BY_JOB,'xxxx') NOT IN ('Y','N');
BEGIN
  FOR row_dc IN cur_WCB_BY_JOB
  LOOP

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_WCB_BY_JOB',
        'EMP_WCB_BY_JOB',
        'EMP_WCB_BY_JOB must be set to ''Y'',''N''.');

  END LOOP;
END WCB_BY_JOB;

--======================================================================
--EMP_PL_CODE
--======================================================================
PROCEDURE EMP_PL_CODE AS
  CURSOR cur_EMP_PL_CODE IS
    SELECT dc_rownum,
	   EMP_COMP_CODE,
	   EMP_COUNTRY_CODE,
	   EMP_STATE_CODE,
	   EMP_PL_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYPLCODE  T2
                          WHERE T1.EMP_COMP_CODE = T2.PLC_COMP_CODE
			    AND T1.EMP_COUNTRY_CODE = T2.PLC_COUNTRY_CODE
			    AND T1.EMP_STATE_CODE = T2.PLC_STATE_CODE
			    AND T1.EMP_PL_CODE = T2.PLC_CODE );

BEGIN
  FOR row_dc IN cur_EMP_PL_CODE
  LOOP
    IF ( row_dc.EMP_PL_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_PL_CODE',
                'PYPLCODE',
                'Record with'||
		' PLC_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' PLC_COUNTRY_CODE '||row_dc.EMP_COUNTRY_CODE||
		','||' PLC_STATE_CODE '||row_dc.EMP_STATE_CODE||
		','||' PLC_CODE '||row_dc.EMP_PL_CODE||
		' does not exist in DA.PYPLCODE table.'); 
    END IF;
 END LOOP;

END EMP_PL_CODE;

--======================================================================
--EMP_PL_CODE_2
--======================================================================
PROCEDURE EMP_PL_CODE_2 AS
  CURSOR cur_EMP_PL_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE, DA.PYCONTROL
        WHERE EMP_PL_CODE IS NULL
		  AND emp_comp_code = con_comp_code(+)
		  AND NVL(con_pl_flag,'N') = 'Y';
BEGIN
  FOR row_dc IN cur_EMP_PL_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PL_CODE',
        'EMP_PL_CODE',
        'EMP_PL_CODE cannot be null if Public Liability is being calculated.');
  END LOOP;
END EMP_PL_CODE_2;

--======================================================================
--EMP_CITY_FILING_STATUS
--======================================================================
PROCEDURE EMP_CITY_FILING_STATUS AS
  CURSOR city_filing_cur IS
    SELECT dc_rownum
         , emp_city_filing_status
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                              FROM DA.vertex_valfilstats  T2
                             WHERE T1.EMP_CITY_FILING_STATUS = TO_CHAR(T2.FILSTAT));

BEGIN
   FOR row_dc IN city_filing_cur LOOP
      IF row_dc.emp_city_filing_status IS NOT NULL THEN 
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                         row_dc.dc_rownum,
                         'EMP_CITY_FILING_STATUS',
                         'VERTEX_VALFILSTATS',
                         'Record with'||
		         ' FILSTAT '||row_dc.emp_city_filing_status||
		         ' does not exist in DA.vertex_valfilstats table.'); 
      END IF;
   END LOOP;
END EMP_CITY_FILING_STATUS;

--======================================================================
--EMP_STATE_FILING_STATUS
--======================================================================
PROCEDURE EMP_STATE_FILING_STATUS AS
  CURSOR state_filing_cur IS
    SELECT dc_rownum
         , emp_state_filing_status
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                              FROM DA.vertex_valfilstats  T2
                             WHERE T1.EMP_STATE_FILING_STATUS = TO_CHAR(T2.FILSTAT));

BEGIN
   FOR row_dc IN state_filing_cur LOOP
      IF row_dc.emp_state_filing_status IS NOT NULL THEN 
	 da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                         row_dc.dc_rownum,
                         'EMP_STATE_FILING_STATUS',
                         'VERTEX_VALFILSTATS',
                         'Record with'||
		         ' FILSTAT '||row_dc.emp_state_filing_status||
		         ' does not exist in DA.vertex_valfilstats table.'); 
      END IF;
   END LOOP;
END EMP_STATE_FILING_STATUS;

--======================================================================
--PL_BY_JOB
--======================================================================
PROCEDURE PL_BY_JOB AS
  CURSOR cur_PL_BY_JOB IS
    SELECT dc_rownum,
           EMP_PL_BY_JOB
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_PL_BY_JOB,'xxxx') NOT IN ('Y','N');
BEGIN
  FOR row_dc IN cur_PL_BY_JOB
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PL_BY_JOB',
        'EMP_PL_BY_JOB',
        'EMP_PL_BY_JOB must be set to ''Y'',''N''.');

  END LOOP;
END PL_BY_JOB;

--======================================================================
--PREFER_PAY_RATE
--======================================================================
PROCEDURE PREFER_PAY_RATE AS
  CURSOR cur_PREFER_PAY_RATE IS
    SELECT dc_rownum,
           EMP_PREFER_PAY_RATE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_PREFER_PAY_RATE,'xxxx') NOT IN ('C','E','J','T','U','B');
BEGIN
  FOR row_dc IN cur_PREFER_PAY_RATE
  LOOP

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PREFER_PAY_RATE',
        'EMP_PREFER_PAY_RATE',
        'EMP_PREFER_PAY_RATE must be set to ''C'',''E'',''J'',''T'',''U'',''B''.');

  END LOOP;
END PREFER_PAY_RATE;

--======================================================================
--PREFER_CHARGE_RATE
--======================================================================
PROCEDURE PREFER_CHARGE_RATE AS
  CURSOR cur_PREFER_CHARGE_RATE IS
    SELECT dc_rownum,
           EMP_PREFER_CHARGE_RATE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_PREFER_CHARGE_RATE,'xxxx') NOT IN ('C','E','J','T','U','B');
BEGIN
  FOR row_dc IN cur_PREFER_CHARGE_RATE
  LOOP

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PREFER_CHARGE_RATE',
        'EMP_PREFER_CHARGE_RATE',
        'EMP_PREFER_CHARGE_RATE must be set to ''C'',''E'',''J'',''T'',''U'',''B''.');

  END LOOP;
END PREFER_CHARGE_RATE;

--======================================================================
--PREFER_BILL_RATE
--======================================================================
PROCEDURE PREFER_BILL_RATE AS
  CURSOR cur_PREFER_BILL_RATE IS
    SELECT dc_rownum,
           EMP_PREFER_BILL_RATE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_PREFER_BILL_RATE,'xxxx') NOT IN ('C','E','J','T','U','B');
BEGIN
  FOR row_dc IN cur_PREFER_BILL_RATE
  LOOP

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_PREFER_BILL_RATE',
        'EMP_PREFER_BILL_RATE',
        'EMP_PREFER_BILL_RATE must be set to ''C'',''E'',''J'',''T'',''U'',''B''.');

  END LOOP;
END PREFER_BILL_RATE;

--======================================================================
--EMP_RATE_CODE
--======================================================================
PROCEDURE EMP_RATE_CODE AS
  CURSOR cur_EMP_RATE_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_RATE_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_RATE_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_RATE_CODE',
        'EMP_RATE_CODE',
        'EMP_RATE_CODE can not be null.');
  END LOOP;
END EMP_RATE_CODE;

--======================================================================
--EMP_RATE_CODE_2
--======================================================================
PROCEDURE EMP_RATE_CODE_2 AS
  CURSOR cur_EMP_RATE_CODE_2 IS
    SELECT dc_rownum,
	   EMP_RATE_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYPAYRCD  T2
                          WHERE T1.EMP_RATE_CODE = T2.RCD_CODE );

BEGIN
  FOR row_dc IN cur_EMP_RATE_CODE_2
  LOOP
    IF ( row_dc.EMP_RATE_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_RATE_CODE',
                'PYPAYRCD',
                'Record with'||
		' RCD_CODE '||row_dc.EMP_RATE_CODE||
		' does not exist in DA.PYPAYRCD table.'); 
    END IF;
 END LOOP;

END EMP_RATE_CODE_2;

--======================================================================
--EMP_OT_RATE_CODE
--======================================================================
PROCEDURE EMP_OT_RATE_CODE AS
  CURSOR cur_EMP_OT_RATE_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_OT_RATE_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_OT_RATE_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_OT_RATE_CODE',
        'EMP_OT_RATE_CODE',
        'EMP_OT_RATE_CODE can not be null.');
  END LOOP;
END EMP_OT_RATE_CODE;

--======================================================================
--EMP_OT_RATE_CODE_2
--======================================================================
PROCEDURE EMP_OT_RATE_CODE_2 AS
  CURSOR cur_EMP_OT_RATE_CODE_2 IS
    SELECT dc_rownum,
	   EMP_OT_RATE_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYPAYRCD  T2
                          WHERE T1.EMP_OT_RATE_CODE = T2.RCD_CODE );

BEGIN
  FOR row_dc IN cur_EMP_OT_RATE_CODE_2
  LOOP
    IF ( row_dc.EMP_OT_RATE_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_OT_RATE_CODE',
                'PYPAYRCD',
                'Record with'||
		' RCD_CODE '||row_dc.EMP_OT_RATE_CODE||
		' does not exist in DA.PYPAYRCD table.'); 
    END IF;
 END LOOP;

END EMP_OT_RATE_CODE_2;

--======================================================================
--EMP_DOT_RATE_CODE
--======================================================================
PROCEDURE EMP_DOT_RATE_CODE AS
  CURSOR cur_EMP_DOT_RATE_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_DOT_RATE_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_DOT_RATE_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_DOT_RATE_CODE',
        'EMP_DOT_RATE_CODE',
        'EMP_DOT_RATE_CODE can not be null.');
  END LOOP;
END EMP_DOT_RATE_CODE;

--======================================================================
--EMP_DOT_RATE_CODE_2
--======================================================================
PROCEDURE EMP_DOT_RATE_CODE_2 AS
  CURSOR cur_EMP_DOT_RATE_CODE_2 IS
    SELECT dc_rownum,
	   EMP_DOT_RATE_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYPAYRCD  T2
                          WHERE T1.EMP_DOT_RATE_CODE = T2.RCD_CODE );

BEGIN
  FOR row_dc IN cur_EMP_DOT_RATE_CODE_2
  LOOP
    IF ( row_dc.EMP_DOT_RATE_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_DOT_RATE_CODE',
                'PYPAYRCD',
                'Record with'||
		' RCD_CODE '||row_dc.EMP_DOT_RATE_CODE||
		' does not exist in DA.PYPAYRCD table.'); 
    END IF;
 END LOOP;

END EMP_DOT_RATE_CODE_2;

--======================================================================
--EMP_OTH_RATE_CODE
--======================================================================
PROCEDURE EMP_OTH_RATE_CODE AS
  CURSOR cur_EMP_OTH_RATE_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_OTH_RATE_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_OTH_RATE_CODE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_OTH_RATE_CODE',
        'EMP_OTH_RATE_CODE',
        'EMP_OTH_RATE_CODE can not be null.');
  END LOOP;
END EMP_OTH_RATE_CODE;

--======================================================================
--EMP_OTH_RATE_CODE_2
--======================================================================
PROCEDURE EMP_OTH_RATE_CODE_2 AS
  CURSOR cur_EMP_OTH_RATE_CODE_2 IS
    SELECT dc_rownum,
	   EMP_OTH_RATE_CODE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYPAYRCD  T2
                          WHERE T1.EMP_OTH_RATE_CODE = T2.RCD_CODE );

BEGIN
  FOR row_dc IN cur_EMP_OTH_RATE_CODE_2
  LOOP
    IF ( row_dc.EMP_OTH_RATE_CODE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_OTH_RATE_CODE',
                'PYPAYRCD',
                'Record with'||
		' RCD_CODE '||row_dc.EMP_OTH_RATE_CODE||
		' does not exist in DA.PYPAYRCD table.'); 
    END IF;
 END LOOP;

END EMP_OTH_RATE_CODE_2;

--======================================================================
--GL_ACC_CODE
--======================================================================
PROCEDURE GL_ACC_CODE AS

 CURSOR cur_acc_code IS
   SELECT dc_rownum,
          EMP_COMP_CODE,
          EMP_GL_ACC_CODE
     FROM DA.DC_PYEMPLOYEE_TABLE ;

 t_result        da.Apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

 CURSOR cur_get_conschart (cp_comp_code	da.company.comp_code%TYPE) IS
   SELECT comp_conschart_code
     FROM da.company
       WHERE comp_code = cp_comp_code;

 TYPE conschart_rec IS RECORD (
        comp_code              	da.company.comp_code%TYPE,
        conschart_code          da.company.comp_conschart_code%TYPE );

 conschart      conschart_rec;

BEGIN
  FOR row_dc IN cur_acc_code
  LOOP
     IF (   NVL(conschart.comp_code,'xxx') != row_dc.EMP_COMP_CODE
         OR conschart.conschart_code IS NULL )
     THEN
          OPEN  cur_get_conschart(row_dc.EMP_COMP_CODE);
          FETCH cur_get_conschart INTO conschart.conschart_code;
          CLOSE cur_get_conschart;
     END IF;

     t_result := da.Apk_Gl_Account.chk(
                          da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE,DA.Apkc.ACCOUNT_ALLOWS_TRANSACTIONS),
                  conschart.conschart_code,
                  row_dc.EMP_GL_ACC_CODE,
                  t_acc_name);
  IF ('0' != t_result)
  THEN
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
    		row_dc.dc_rownum,
                'EMP_GL_ACC_CODE',
                'ACC_CODE',
                t_result);
  END IF; 
 END LOOP;
END GL_ACC_CODE;

--======================================================================
--PAYROLL_CLEAR_ACC_CODE
--======================================================================
PROCEDURE PAYROLL_CLEAR_ACC_CODE AS

 CURSOR cur_acc_code IS
   SELECT dc_rownum,
          EMP_COMP_CODE,
          EMP_PAYROLL_CLEAR_ACC_CODE
     FROM DA.DC_PYEMPLOYEE_TABLE ;

 t_result        da.Apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

 CURSOR cur_get_conschart (cp_comp_code	da.company.comp_code%TYPE) IS
   SELECT comp_conschart_code
     FROM da.company
       WHERE comp_code = cp_comp_code;

 TYPE conschart_rec IS RECORD (
        comp_code              	da.company.comp_code%TYPE,
        conschart_code          da.company.comp_conschart_code%TYPE );

 conschart      conschart_rec;

BEGIN
  FOR row_dc IN cur_acc_code
  LOOP
     IF (   NVL(conschart.comp_code,'xxx') != row_dc.EMP_COMP_CODE
         OR conschart.conschart_code IS NULL )
     THEN
          OPEN  cur_get_conschart(row_dc.EMP_COMP_CODE);
          FETCH cur_get_conschart INTO conschart.conschart_code;
          CLOSE cur_get_conschart;
     END IF;

     t_result := da.Apk_Gl_Account.chk(
                          da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE,DA.Apkc.ACCOUNT_ALLOWS_TRANSACTIONS),
                  conschart.conschart_code,
                  row_dc.EMP_PAYROLL_CLEAR_ACC_CODE,
                  t_acc_name);
  IF ('0' != t_result)
  THEN
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
    		row_dc.dc_rownum,
                'EMP_PAYROLL_CLEAR_ACC_CODE',
                'ACC_CODE',
                t_result);
  END IF; 
 END LOOP;
END PAYROLL_CLEAR_ACC_CODE;

--======================================================================
--DR_CLEAR_ACC_CODE
--======================================================================
PROCEDURE DR_CLEAR_ACC_CODE AS

 CURSOR cur_acc_code IS
   SELECT dc_rownum,
          EMP_COMP_CODE,
          EMP_DR_CLEAR_ACC_CODE
     FROM DA.DC_PYEMPLOYEE_TABLE ;

 t_result        da.Apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

 CURSOR cur_get_conschart (cp_comp_code	da.company.comp_code%TYPE) IS
   SELECT comp_conschart_code
     FROM da.company
       WHERE comp_code = cp_comp_code;

 TYPE conschart_rec IS RECORD (
        comp_code              	da.company.comp_code%TYPE,
        conschart_code          da.company.comp_conschart_code%TYPE );

 conschart      conschart_rec;

BEGIN
  FOR row_dc IN cur_acc_code
  LOOP
     IF (   NVL(conschart.comp_code,'xxx') != row_dc.EMP_COMP_CODE
         OR conschart.conschart_code IS NULL )
     THEN
          OPEN  cur_get_conschart(row_dc.EMP_COMP_CODE);
          FETCH cur_get_conschart INTO conschart.conschart_code;
          CLOSE cur_get_conschart;
     END IF;

     t_result := da.Apk_Gl_Account.chk(
                          da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE,DA.Apkc.ACCOUNT_ALLOWS_TRANSACTIONS),
                  conschart.conschart_code,
                  row_dc.EMP_DR_CLEAR_ACC_CODE,
                  t_acc_name);
  IF ('0' != t_result)
  THEN
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
    		row_dc.dc_rownum,
                'EMP_DR_CLEAR_ACC_CODE',
                'ACC_CODE',
                t_result);
  END IF; 
 END LOOP;
END DR_CLEAR_ACC_CODE;

--======================================================================
--LEV_CLEAR_ACC_CODE
--======================================================================
PROCEDURE LEV_CLEAR_ACC_CODE AS

 CURSOR cur_acc_code IS
   SELECT dc_rownum,
          EMP_COMP_CODE,
          EMP_LEV_CLEAR_ACC_CODE
     FROM DA.DC_PYEMPLOYEE_TABLE ;

 t_result        da.Apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

 CURSOR cur_get_conschart (cp_comp_code	da.company.comp_code%TYPE) IS
   SELECT comp_conschart_code
     FROM da.company
       WHERE comp_code = cp_comp_code;

 TYPE conschart_rec IS RECORD (
        comp_code              	da.company.comp_code%TYPE,
        conschart_code          da.company.comp_conschart_code%TYPE );

 conschart      conschart_rec;

BEGIN
  FOR row_dc IN cur_acc_code
  LOOP
     IF (   NVL(conschart.comp_code,'xxx') != row_dc.EMP_COMP_CODE
         OR conschart.conschart_code IS NULL )
     THEN
          OPEN  cur_get_conschart(row_dc.EMP_COMP_CODE);
          FETCH cur_get_conschart INTO conschart.conschart_code;
          CLOSE cur_get_conschart;
     END IF;

     t_result := da.Apk_Gl_Account.chk(
                          da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE,DA.Apkc.ACCOUNT_ALLOWS_TRANSACTIONS),
                  conschart.conschart_code,
                  row_dc.EMP_LEV_CLEAR_ACC_CODE,
                  t_acc_name);
  IF ('0' != t_result)
  THEN
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
    		row_dc.dc_rownum,
                'EMP_LEV_CLEAR_ACC_CODE',
                'ACC_CODE',
                t_result);
  END IF; 
 END LOOP;
END LEV_CLEAR_ACC_CODE;

--======================================================================
--LEV_ACRU_GL_ACC_CODE
--======================================================================
PROCEDURE LEV_ACRU_GL_ACC_CODE AS

 CURSOR cur_acc_code IS
   SELECT dc_rownum,
          EMP_COMP_CODE,
          EMP_LEV_ACRU_GL_ACC_CODE
     FROM DA.DC_PYEMPLOYEE_TABLE ;

 t_result        da.Apkc.t_result_type%TYPE;
 t_acc_name      da.account.acc_name%TYPE;

 CURSOR cur_get_conschart (cp_comp_code	da.company.comp_code%TYPE) IS
   SELECT comp_conschart_code
     FROM da.company
       WHERE comp_code = cp_comp_code;

 TYPE conschart_rec IS RECORD (
        comp_code              	da.company.comp_code%TYPE,
        conschart_code          da.company.comp_conschart_code%TYPE );

 conschart      conschart_rec;

BEGIN
  FOR row_dc IN cur_acc_code
  LOOP
     IF (   NVL(conschart.comp_code,'xxx') != row_dc.EMP_COMP_CODE
         OR conschart.conschart_code IS NULL )
     THEN
          OPEN  cur_get_conschart(row_dc.EMP_COMP_CODE);
          FETCH cur_get_conschart INTO conschart.conschart_code;
          CLOSE cur_get_conschart;
     END IF;

     t_result := da.Apk_Gl_Account.chk(
                          da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE,DA.Apkc.ACCOUNT_ALLOWS_TRANSACTIONS),
                  conschart.conschart_code,
                  row_dc.EMP_LEV_ACRU_GL_ACC_CODE,
                  t_acc_name);
  IF ('0' != t_result)
  THEN
    da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
    		row_dc.dc_rownum,
                'EMP_LEV_ACRU_GL_ACC_CODE',
                'ACC_CODE',
                t_result);
  END IF; 
 END LOOP;
END LEV_ACRU_GL_ACC_CODE;

--======================================================================
--EMP_SUI_STATE
--======================================================================
PROCEDURE EMP_SUI_STATE AS
  CURSOR cur_EMP_SUI_STATE IS
    SELECT dc_rownum,
	   EMP_SUI_STATE
	FROM DA.DC_PYEMPLOYEE_TABLE T1
	  WHERE NOT EXISTS (SELECT '1'
                        FROM DA.PYWORKLOC  T2
                          WHERE T1.EMP_SUI_STATE = T2.WRL_CODE );

BEGIN
  FOR row_dc IN cur_EMP_SUI_STATE
  LOOP
    IF ( row_dc.EMP_SUI_STATE IS NOT NULL ) THEN 
	 	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_SUI_STATE',
                'PYWORKLOC',
                'Record with'||
		' WRL_CODE '||row_dc.EMP_SUI_STATE||
		' does not exist in DA.PYWORKLOC table.'); 
    END IF;
 END LOOP;

END EMP_SUI_STATE;

--======================================================================
--EMP_USER
--======================================================================
PROCEDURE EMP_USER AS
  CURSOR cur_EMP_USER_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_USER IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_USER_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_USER',
        'EMP_USER',
        'EMP_USER can not be null.');
  END LOOP;
END EMP_USER;

--======================================================================
--EMP_LAST_UPD_DATE
--======================================================================
PROCEDURE EMP_LAST_UPD_DATE AS
  CURSOR cur_EMP_LAST_UPD_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_LAST_UPD_DATE IS NULL;
BEGIN
  FOR row_dc IN cur_EMP_LAST_UPD_DATE_null
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_LAST_UPD_DATE',
        'EMP_LAST_UPD_DATE',
        'EMP_LAST_UPD_DATE can not be null.');
  END LOOP;
END EMP_LAST_UPD_DATE;

--======================================================================
--STATUS
--======================================================================
PROCEDURE STATUS AS
  CURSOR cur_STATUS IS
    SELECT dc_rownum,
           EMP_STATUS
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_STATUS,'xxxx') NOT IN ('A','T','D');
BEGIN
  FOR row_dc IN cur_STATUS
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_STATUS',
        'EMP_STATUS',
        'EMP_STATUS must be set to ''A'',''T'',''D''.');

  END LOOP;
END STATUS;

--======================================================================
--DOMINANT_HAND
--======================================================================
PROCEDURE DOMINANT_HAND AS
  CURSOR cur_DOMINANT_HAND IS
    SELECT dc_rownum,
           EMP_DOMINANT_HAND
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_DOMINANT_HAND,'xxxx') NOT IN ('R','L','A','N');
BEGIN
  FOR row_dc IN cur_DOMINANT_HAND
  LOOP 
    IF ( row_dc.EMP_DOMINANT_HAND IS NOT NULL ) THEN 
	 
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_DOMINANT_HAND',
        'EMP_DOMINANT_HAND',
        'EMP_DOMINANT_HAND must be set to ''R'',''L'',''A'', or ''N''.');
    END IF; 
  END LOOP;
END DOMINANT_HAND;

--======================================================================
--MILITARY_STATUS
--======================================================================
PROCEDURE MILITARY_STATUS AS
  CURSOR cur_MILITARY_STATUS IS
    SELECT dc_rownum,
           EMP_MILITARY_STATUS
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_MILITARY_STATUS,'xxxx') NOT IN ('NV','VE','DV','SV','VV','MV','OV','PV','IR','RR','HV');
BEGIN
  FOR row_dc IN cur_MILITARY_STATUS
  LOOP
    IF ( row_dc.EMP_MILITARY_STATUS IS NOT NULL ) THEN

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_MILITARY_STATUS',
        'EMP_MILITARY_STATUS',
        'EMP_MILITARY_STATUS must be set to ''NV'',''VE'',''DV'',''SV'',''MV'',''OV'',''PV'',''IR'',''RR'',''HV'', or ''VV''.');
    END IF;
  END LOOP;
END MILITARY_STATUS;

--======================================================================
--ANNUAL_SALARY
--======================================================================

PROCEDURE EMP_ANNUAL_SALARY AS
  CURSOR cur_EMP_ANNUAL_SALARY_NULL IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_TYPE = 'S'
          AND EMp_ANNUAL_SALARY IS NULL;
		  
  CURSOR cur_EMP_ANNUAL_SALARY IS
    SELECT dc_rownum,
           EMP_ANNUAL_SALARY
      FROM DA.DC_PYEMPLOYEE_TABLE
      WHERE emp_annual_salary IS NOT NULL
	    AND emp_type = 'H';
BEGIN
  FOR row_dc IN cur_EMP_ANNUAL_SALARY_NULL
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_ANNUAL_SALARY',
        'EMP_ANNUAL_SALARY',
        'EMP_ANNUAL_SALARY cannot be null for salaried employee - EMP_TYPE = ''S''.');
  END LOOP;
  
  FOR row_dc IN cur_EMP_ANNUAL_SALARY
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_ANNUAL_SALARY',
        'EMP_ANNUAL_SALARY',
        'EMP_ANNUAL_SALARY must be NULL for hourly employee - EMP_TYPE = ''H''.');
  END LOOP;
END;

--======================================================================
--HOURLY_RATE
--======================================================================

PROCEDURE EMP_HOURLY_RATE AS
  CURSOR cur_EMP_HOURLY_RATE_NULL IS
    SELECT dc_rownum
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE EMP_TYPE = 'H'
          AND EMp_HOURLY_RATE IS NULL;
		  
  CURSOR cur_EMP_HOURLY_RATE IS
    SELECT dc_rownum,
           EMP_HOURLY_RATE
      FROM DA.DC_PYEMPLOYEE_TABLE
      WHERE emp_HOURLY_RATE IS NOT NULL
	    AND emp_type = 'S';
BEGIN
  FOR row_dc IN cur_EMP_HOURLY_RATE_NULL
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_HOURLY_RATE',
        'EMP_HOURLY_RATE',
        'EMP_HOURLY_RATE cannot be null for hourly employee - EMP_TYPE = ''H''.');
  END LOOP;
  
  FOR row_dc IN cur_EMP_HOURLY_RATE
  LOOP
	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_HOURLY_RATE',
        'EMP_HOURLY_RATE',
        'EMP_HOURLY_RATE must be NULL for salaried employee - EMP_TYPE = ''S''.');
  END LOOP;
END;


--======================================================================
-- EMP_CALC_PREF
-- S/H/R/A
--======================================================================
PROCEDURE EMP_CALC_PREF AS
   CURSOR calc_ref_cur IS
      SELECT dc_rownum
        FROM da.dc_pyemployee_table
       WHERE NVL(emp_calc_pref,'xxxx') NOT IN ('S','H','R','A');
BEGIN
   FOR row_dc IN calc_ref_cur LOOP
      da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE'
                     ,row_dc.dc_rownum
                     ,'EMP_CALC_PREF'
                     ,'EMP_CALC_PREF'
                     ,'Value must be S - Senority Date, H - Hire Date, R - Rehire date, or A - Adjusted Service Date.');
   END LOOP;
END EMP_CALC_PREF;

--======================================================================
-- EMP_LEAVE_CALC_PREF
-- S/H/R/A
--======================================================================
PROCEDURE EMP_LEAVE_CALC_PREF AS
   CURSOR LEAVE_calc_ref_cur IS
      SELECT dc_rownum
        FROM da.dc_pyemployee_table
       WHERE NVL(emp_LEAVE_calc_pref,'xxxx') NOT IN ('S','H','R','A');
BEGIN
   FOR row_dc IN LEAVE_calc_ref_cur LOOP
      da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE'
                     ,row_dc.dc_rownum
                     ,'EMP_LEAVE_CALC_PREF'
                     ,'EMP_LEAVE_CALC_PREF'
                     ,'Value must be S - Senority Date, H - Hire Date, R - Rehire date, or A - Adjusted Service Date.');
   END LOOP;
END EMP_LEAVE_CALC_PREF;


--======================================================================
--EMP_INCL_CERT_PY_REP_FLAG
--======================================================================
PROCEDURE EMP_INCL_CERT_PY_REP_FLAG AS
  CURSOR cur_EMP_INCL_CERT_PY_REP_FLAG IS
    SELECT dc_rownum,
           EMP_INCL_CERT_PY_REP_FLAG
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_INCL_CERT_PY_REP_FLAG,'xxxx') NOT IN ('N','Y');
BEGIN
  FOR row_dc IN cur_EMP_INCL_CERT_PY_REP_FLAG
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_INCL_CERT_PY_REP_FLAG',
        'EMP_INCL_CERT_PY_REP_FLAG',
        'EMP_INCL_CERT_PY_REP_FLAG must be set to ''N'',''Y''.');

  END LOOP;
END EMP_INCL_CERT_PY_REP_FLAG;

--======================================================================
--EMP_REHIRE_ELIGIBLE
--======================================================================
PROCEDURE EMP_REHIRE_ELIGIBLE AS
  CURSOR cur_EMP_REHIRE_ELIGIBLE IS
    SELECT dc_rownum,
           EMP_REHIRE_ELIGIBLE
      FROM DA.DC_PYEMPLOYEE_TABLE
        WHERE NVL(EMP_REHIRE_ELIGIBLE,'xxxx') NOT IN ('N','Y');
BEGIN
  FOR row_dc IN cur_EMP_REHIRE_ELIGIBLE
  LOOP 

	da.Dbk_Dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_REHIRE_ELIGIBLE',
        'EMP_REHIRE_ELIGIBLE',
        'EMP_REHIRE_ELIGIBLE must be set to ''N'',''Y''.');

  END LOOP;
END EMP_REHIRE_ELIGIBLE;


--======================================================================
--emp_primary_emp_no
--======================================================================
PROCEDURE emp_primary_emp_no AS
  cursor cur_dc_null is
    select dc_rownum
      from DA.DC_PYEMPLOYEE_TABLE
        where emp_primary_emp_no is null;
BEGIN
  for row_dc in cur_dc_null
  loop
        da.dbk_dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'emp_primary_emp_no',
        'emp_primary_emp_no',
        'Emp_primary_emp_no can not be null.');
  end loop;
END emp_primary_emp_no;


--======================================================================
--EMP_TSH_CODE
--======================================================================
PROCEDURE EMP_TSH_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   EMP_TSH_CODE
	from DA.DC_PYEMPLOYEE_TABLE T1
	  where not exists (select '1'
                        from DA.PYPAYRUN  T2
                          where T1.EMP_TSH_CODE = T2.PRN_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.EMP_TSH_CODE is not null ) then 
	 	da.dbk_dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_TSH_CODE',
                'PYPAYRUN',
                'Record with'||
		' PRN_CODE '||row_dc.EMP_TSH_CODE||
		' does not exist in DA.PYPAYRUN table.'); 
    end if;
 end loop;

END EMP_TSH_CODE;


--======================================================================
--AUTOGENERATE_TIMESHEET
--======================================================================
PROCEDURE AUTOGENERATE_TIMESHEET AS
  cursor cur_dc is
    select dc_rownum,
           EMP_AUTOGENERATE_TIMESHEET
      from DA.DC_PYEMPLOYEE_TABLE
        where nvl(EMP_AUTOGENERATE_TIMESHEET,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 
    if ( row_dc.EMP_AUTOGENERATE_TIMESHEET is not null ) then 
                 
        da.dbk_dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_AUTOGENERATE_TIMESHEET',
        'EMP_AUTOGENERATE_TIMESHEET',
        'EMP_AUTOGENERATE_TIMESHEET must be set to ''Y'',''N'' or NULL.');
    end if; 
  end loop;
END AUTOGENERATE_TIMESHEET;

--======================================================================
--EMP_CKLOC_CODE
--======================================================================
PROCEDURE EMP_CKLOC_CODE AS
  cursor cur_dc is
    select dc_rownum,
	   EMP_COMP_CODE,
	   EMP_CKLOC_CODE
	from DA.DC_PYEMPLOYEE_TABLE T1
	  where not exists (select '1'
                        from DA.PYCHKLOC  T2
                          where T1.EMP_COMP_CODE = T2.CKLOC_COMP_CODE
			    and T1.EMP_CKLOC_CODE = T2.CKLOC_CODE );

BEGIN
  for row_dc in cur_dc
  loop
    if ( row_dc.EMP_CKLOC_CODE is not null ) then 
	 	da.dbk_dc.error('DC_PYEMPLOYEE_TABLE',
                row_dc.dc_rownum,
                'EMP_CKLOC_CODE',
                'PYCKLOC',
                'Record with'||
		' CKLOC_COMP_CODE '||row_dc.EMP_COMP_CODE||
		','||' CKLOC_CODE '||row_dc.EMP_CKLOC_CODE||
		' does not exist in DA.PYCKLOC table.'); 
    end if;
 end loop;

END EMP_CKLOC_CODE;


/*
--======================================================================
--DISPATCH_FLAG
--======================================================================
PROCEDURE DISPATCH_FLAG AS
  cursor cur_dc is
    select dc_rownum,
           EMP_DISPATCH_FLAG
      from DA.DC_PYEMPLOYEE_TABLE
        where nvl(EMP_DISPATCH_FLAG,'xxxx') not in ('Y','N');
BEGIN
  for row_dc in cur_dc
  loop 
    if ( row_dc.EMP_DISPATCH_FLAG is not null ) then 
	 
        da.dbk_dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_DISPATCH_FLAG',
        'EMP_DISPATCH_FLAG',
        'EMP_DISPATCH_FLAG must be set to ''Y'',''N'' or NULL.');
    end if; 
  end loop;
END DISPATCH_FLAG;

--======================================================================
--FULL_PART_TIME
--======================================================================
PROCEDURE FULL_PART_TIME AS
  cursor cur_dc is
    select dc_rownum,
           EMP_FULL_PART_TIME
      from DA.DC_PYEMPLOYEE_TABLE
        where nvl(EMP_FULL_PART_TIME,'xxxx') not in ('F','P');
BEGIN
  for row_dc in cur_dc
  loop 
    if ( row_dc.EMP_FULL_PART_TIME is not null ) then 
	 
        da.dbk_dc.error('DC_PYEMPLOYEE_TABLE',row_dc.dc_rownum,'EMP_FULL_PART_TIME',
        'EMP_FULL_PART_TIME',
        'EMP_FULL_PART_TIME must be set to ''F'',''P'' or NULL.');
    end if; 
  end loop;
END FULL_PART_TIME;


*/

--======================================================================
--VERIFY_DATA - run all verify procedures define for PYEMPLOYEE_TABLE table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
	display_status(' Delete rows DC_PYEMPLOYEE_TABLE from DA.DC_ERROR.');
	DELETE FROM da.dc_error
	  WHERE UPPER(dcerr_table_name) = 'DC_PYEMPLOYEE_TABLE' ;

        COMMIT;

        display_status(' MODIFY - checking');
        MODIFY;

        COMMIT;

      	display_status(' INDEX checking in DA.PYEMPLOYEE_TABLE');
        idx_check;

        COMMIT;

	display_status(' INDEX  checking in DA.DC_PYEMPLOYEE_TABLE');
        idx_dupl;

        COMMIT;

        display_status(' FOREIGN KEYS checking in DA.DC_PYEMPLOYEE_TABLE');
        Fk_con;

        COMMIT;

        display_status(' CHECK constraints checking in DA.DC_PYEMPLOYEE_TABLE');
        check_con;

        COMMIT;

        display_status(' EMP_EMP_NO - checking');
        EMP_NO;

        COMMIT;

        display_status(' EMP_EMP_FIRST_NAME - checking');
        EMP_FIRST_NAME;

        COMMIT;

        display_status(' EMP_EMP_LAST_NAME - checking');
        EMP_LAST_NAME;

        COMMIT;

        display_status(' EMP_EMP_SIN_NO - checking');
        EMP_SIN_NO;

        COMMIT;

        display_status(' EMP_TYPE - checking');
        TYPE;

        COMMIT;

        display_status(' EMP_UNIONIZED - checking');
        UNIONIZED;

        COMMIT;

        display_status(' EMP_EMP_ZIP_CODE - checking');
        EMP_ZIP_CODE;

        COMMIT;

        display_status(' EMP_EMP_COUNTRY_CODE - checking');
        EMP_COUNTRY_CODE;

        COMMIT;

        display_status(' EMP_COUNTRY_CODE_2 - checking');
        EMP_COUNTRY_CODE_2;

        COMMIT;

        display_status(' EMP_EMP_STATE_CODE - checking');
        EMP_STATE_CODE;

        COMMIT;

        display_status(' EMP_STATE_CODE_2 - checking');
        EMP_STATE_CODE_2;

        COMMIT;

        display_status(' EMP_COUNTY_CODE - checking');
        EMP_COUNTY_CODE;

        COMMIT;

        display_status(' EMP_CITY_CODE - checking');
        EMP_CITY_CODE;

        COMMIT;

        display_status(' EMP_EMP_VERTEX_GEOCODE - checking');
        EMP_VERTEX_GEOCODE;

        COMMIT;

        display_status(' EMP_FILING_STATUS - checking');
        FILING_STATUS;

        COMMIT;

        display_status(' EMP_NR_CERTIFICATE - checking');
        NR_CERTIFICATE;

        COMMIT;

        display_status(' EMP_EMP_COMP_CODE - checking');
        EMP_COMP_CODE;

        COMMIT;

        display_status(' EMP_DEPT_CODE - checking');
        DEPT_CODE;

        COMMIT;

        display_status(' EMP_EMP_WRL_CODE - checking');
        EMP_WRL_CODE;

        COMMIT;

        display_status(' EMP_WRL_CODE_2 - checking');
        EMP_WRL_CODE_2;

        COMMIT;

--        display_status(' EMP_RES_LOC - checking');
--        EMP_RES_LOC;
--        commit;

        display_status(' EMP_JOB_CODE - checking');
        EMP_JOB_CODE;

        COMMIT;

        display_status(' EMP_PHS_CODE - checking');
        EMP_PHS_CODE;

        COMMIT;

        display_status(' EMP_CAT_CODE - checking');
        EMP_CAT_CODE;

        COMMIT;

        display_status(' EMP_UNI_CODE - checking');
        EMP_UNI_CODE;

        COMMIT;

        display_status(' EMP_EMP_TRD_CODE - checking');
        EMP_TRD_CODE;

        COMMIT;

        display_status(' EMP_TRD_CODE_2 - checking');
        EMP_TRD_CODE_2;

        COMMIT;

        display_status(' EMP_EMP_PYG_CODE - checking');
        EMP_PYG_CODE;

        COMMIT;

        display_status(' EMP_PYG_CODE_2 - checking');
        EMP_PYG_CODE_2;

        COMMIT;

        display_status(' EMP_EMP_HIRE_DATE - checking');
        EMP_HIRE_DATE;

        COMMIT;

        display_status(' EMP_ETHNIC_CODE - checking');
        ETHNIC_CODE;

        COMMIT;

        display_status(' EMP_SEX - checking');
        SEX;

        COMMIT;

        display_status(' EMP_MARITAL_STATUS - checking');
        MARITAL_STATUS;

        COMMIT;

        display_status(' EMP_RESIDENT_STATUS - checking');
        RESIDENT_STATUS;

        COMMIT;

        display_status(' EMP_OT_ELIGIBILITY - checking');
        OT_ELIGIBILITY;

        COMMIT;

        display_status(' EMP_PAYMENT_MODE - checking');
        PAYMENT_MODE;

        COMMIT;

        display_status(' EMP_BANK_CODE - checking');
        EMP_BANK_CODE;

        COMMIT;

        display_status(' EMP_BRANCH_CODE - checking');
        EMP_BRANCH_CODE;

        COMMIT;

        display_status(' EMP_BANK_AC_NO - checking');
        EMP_BANK_AC_NO;

        COMMIT;

        display_status(' EMP_EMP_PRN_CODE - checking');
        EMP_PRN_CODE;

        COMMIT;

        display_status(' EMP_PRN_CODE_2 - checking');
        EMP_PRN_CODE_2;

        COMMIT;

        display_status(' EMP_EMP_WCB_CODE - checking');
        EMP_WCB_CODE;

        COMMIT;

        display_status(' EMP_WCB_CODE_2 - checking');
        EMP_WCB_CODE_2;

        COMMIT;

        display_status(' EMP_WCB_BY_JOB - checking');
        WCB_BY_JOB;

        COMMIT;

        display_status(' EMP_PL_CODE_2 - checking');
        EMP_PL_CODE;

        COMMIT;

        display_status(' EMP_PL_CODE - checking');
        EMP_PL_CODE;

        COMMIT;

        display_status(' EMP_PL_BY_JOB - checking');
        PL_BY_JOB;

        COMMIT;

        display_status(' EMP_PREFER_PAY_RATE - checking');
        PREFER_PAY_RATE;

        COMMIT;

        display_status(' EMP_PREFER_CHARGE_RATE - checking');
        PREFER_CHARGE_RATE;

        COMMIT;

        display_status(' EMP_PREFER_BILL_RATE - checking');
        PREFER_BILL_RATE;

        COMMIT;

        display_status(' EMP_EMP_RATE_CODE - checking');
        EMP_RATE_CODE;

        COMMIT;

        display_status(' EMP_RATE_CODE_2 - checking');
        EMP_RATE_CODE_2;

        COMMIT;

        display_status(' EMP_EMP_OT_RATE_CODE - checking');
        EMP_OT_RATE_CODE;

        COMMIT;

        display_status(' EMP_OT_RATE_CODE_2 - checking');
        EMP_OT_RATE_CODE_2;

        COMMIT;

        display_status(' EMP_EMP_DOT_RATE_CODE - checking');
        EMP_DOT_RATE_CODE;

        COMMIT;

        display_status(' EMP_DOT_RATE_CODE_2 - checking');
        EMP_DOT_RATE_CODE_2;

        COMMIT;

        display_status(' EMP_EMP_OTH_RATE_CODE - checking');
        EMP_OTH_RATE_CODE;

        COMMIT;

        display_status(' EMP_OTH_RATE_CODE_2 - checking');
        EMP_OTH_RATE_CODE_2;

        COMMIT;

        display_status(' EMP_GL_ACC_CODE - checking');
        GL_ACC_CODE;

        COMMIT;

        display_status(' EMP_PAYROLL_CLEAR_ACC_CODE - checking');
        PAYROLL_CLEAR_ACC_CODE;

        COMMIT;

        display_status(' EMP_DR_CLEAR_ACC_CODE - checking');
        DR_CLEAR_ACC_CODE;

        COMMIT;

        display_status(' EMP_SUI_STATE - checking');
        EMP_SUI_STATE;

        COMMIT;

        display_status(' EMP_EMP_USER - checking');
        EMP_USER;

        COMMIT;

        display_status(' EMP_EMP_LAST_UPD_DATE - checking');
        EMP_LAST_UPD_DATE;

        COMMIT;

        display_status(' EMP_STATUS - checking');
        STATUS;

        COMMIT;

        display_status(' EMP_DOMINANT_HAND - checking');
        DOMINANT_HAND;

        COMMIT;

        display_status(' EMP_MILITARY_STATUS - checking');
        MILITARY_STATUS;

        COMMIT;

        display_status(' EMP_ANNUAL_SALARY - checking');
        emp_annual_salary;

        COMMIT;

        display_status(' EMP_HOURLY_RATE - checking');
        EMP_HOURLY_RATE;

        COMMIT;

        display_status(' EMP_CALC_PREF - checking');
        emp_calc_pref;
        
        COMMIT;

        display_status(' EMP_LEAVE_CALC_PREF - checking');
        emp_calc_pref;
        
        COMMIT;
        
        display_status(' EMP_LEV_CLEAR_ACC_CODE - checking');
	lev_clear_acc_code;
	        
        COMMIT;
        
        display_status(' EMP_LEV_ACRU_GL_ACC_CODE - checking');
        lev_acru_gl_acc_code;
	        
        COMMIT;
        
        display_status(' EMP_STATE_FILING_STATUS - checking');
        emp_state_filing_status;
	        
        COMMIT;
        
        display_status(' EMP_CITY_FILING_STATUS - checking');
        emp_city_filing_status;
	        
        COMMIT;

	display_status(' EMP_INCL_CERT_PY_REP_FLAG - checking');
        EMP_INCL_CERT_PY_REP_FLAG;

	display_status(' EMP_REHIRE_ELIGIBLE - checking');
        EMP_REHIRE_ELIGIBLE;

	display_status(' EMP_PRIMARY_EMP_NO - checking');
	EMP_PRIMARY_EMP_NO;

	display_status(' EMP_TSH_CODE - Checking');
	EMP_TSH_CODE;
	       
        COMMIT;

 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATA - move data into DA.PYEMPLOYEE_TABLE table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_PYEMPLOYEE_TABLE table
   CURSOR cur_err_PYEMPLOYEE_TABLE IS
     SELECT COUNT(1)
       FROM da.dc_error
        WHERE UPPER(dcerr_table_name) = 'DC_PYEMPLOYEE_TABLE' ;
   CURSOR cur_mode IS
     SELECT COUNT(*) 
	 FROM da.DC_PYEMPLOYEE_TABLE;
	 -- WHERE dc_valid_flag = '?';

   t_num_errors_PYEMPLOYEE_TABLE         NUMBER;
   t_mode	NUMBER; -- 0 for ADP import, > 0 for Data Conversion


 cursor cInsert is 
   select
	EMP_NO		--1
	,EMP_FIRST_NAME		--2
	,EMP_MIDDLE_NAME		--3
	,EMP_LAST_NAME		--4
	,EMP_PREFIX_NAME		--5
	,EMP_SUFFIX_NAME		--6
	,EMP_NICK_NAME		--7
	,EMP_SIN_NO		--8
	,EMP_TYPE		--9
	,EMP_UNIONIZED		--10
	,EMP_JOB_TITLE		--11
	,EMP_ADDRESS1		--12
	,EMP_ADDRESS2		--13
	,EMP_ADDRESS3		--14
	,EMP_ZIP_CODE		--15
	,EMP_PHONE		--16
	,EMP_FAX		--17
	,EMP_RES_LOC		--18
	,EMP_COUNTRY_CODE		--19
	,EMP_STATE_CODE		--20
	,EMP_COUNTY_CODE		--21
	,EMP_CITY_CODE		--22
	,EMP_VERTEX_GEOCODE		--23
	,EMP_VERTEX_SCHDIST		--24
	,EMP_FILING_STATUS		--25
	,EMP_NR_CERTIFICATE		--26
	,EMP_PRIM_EXEMP		--27
	,EMP_SECN_EXEMP		--28
	,EMP_TERT_EXEMP		--29
	,EMP_PRIM_EXEMP_AMT		--30
	,EMP_SUPL_EXEMP_AMT		--31
	,EMP_COMP_CODE		--32
	,EMP_DEPT_CODE		--33
	,EMP_WRL_CODE		--34
	,EMP_JOB_CODE		--35
	,EMP_PHS_CODE		--36
	,EMP_CAT_CODE		--37
	,EMP_EQUIPMENT_NO		--38
	,EMP_EQUIP_TRAN_CODE		--39
	,EMP_EQUIP_CATEGORY		--40
	,EMP_UNI_CODE		--41
	,EMP_UNION_MEM_NO		--42
	,EMP_MEMBERSHIP_DATE		--43
	,EMP_TRD_CODE		--44
	,EMP_PYG_CODE		--45
	,EMP_HIRE_DATE		--46
	,EMP_RE_HIRE_DATE		--47
	,EMP_TERMINATION_DATE		--48
	,EMP_DATE_DECEASED		--49
	,EMP_DATE_OF_BIRTH		--50
	,EMP_PLACE_OF_BIRTH		--51
	,EMP_GRD_CODE		--52
	,EMP_ETHNIC_CODE		--53
	,EMP_SEX		--54
	,EMP_MARITAL_STATUS		--55
	,EMP_RESIDENT_STATUS		--56
	,EMP_OT_ELIGIBILITY		--57
	,EMP_PAYMENT_MODE		--58
	,EMP_BANK_CODE		--59
	,EMP_BRANCH_CODE		--60
	,EMP_BANK_AC_NO		--61
	,EMP_LAST_INCR_DATE		--62
	,EMP_LAST_PROM_DATE		--63
	,EMP_LAST_TRAN_DATE		--64
	,EMP_ANNUAL_SALARY		--65
	,EMP_HOURLY_RATE		--66
	,EMP_CHARGE_OUT_RATE		--67
	,EMP_BILLING_RATE		--68
	,EMP_PRN_CODE		--69
	,EMP_WCB_CODE		--70
	,EMP_WCB_BY_JOB		--71
	,EMP_PL_CODE		--72
	,EMP_PL_BY_JOB		--73
	,EMP_PREFER_PAY_RATE		--74
	,EMP_PREFER_CHARGE_RATE		--75
	,EMP_PREFER_BILL_RATE		--76
	,EMP_RATE_CODE		--77
	,EMP_OT_RATE_CODE		--78
	,EMP_DOT_RATE_CODE		--79
	,EMP_OTH_RATE_CODE		--80
	,EMP_GL_ACC_CODE		--81
	,EMP_PAYROLL_CLEAR_ACC_CODE		--82
	,EMP_DR_CLEAR_ACC_CODE		--83
	,EMP_SUI_STATE		--84
	,EMP_USER		--85
	,EMP_LAST_UPD_DATE		--86
	,EMP_STATUS		--87
	,EMP_PENSION_FLAG		--88
	,EMP_LOGIN_USER		--89
	,EMP_DEF_COMP_FLAG		--90
	,EMP_TD1_EXEMP_AMT		--91
	,EMP_EI_CODE		--92
	,EMP_YEAR_WORKING_DAYS		--93
	,EMP_YEAR_WORKING_HOURS		--94
	,EMP_SERVICE_YEARS		--95
	,EMP_PH_ADDRESS1		--96
	,EMP_PH_ADDRESS2		--97
	,EMP_PH_ADDRESS3		--98
	,APPLICANT_APL_NO		--99
	,DISABILITY_DIS_CODE		--100
	,LANGUAGE_LANG_NAME		--101
	,EMP_WORK_PHONE		--102
	,EMP_WORK_FAX		--103
	,EMP_CELL_PHONE		--104
	,EMP_PAGER		--105
	,EMP_EMAIL_ADDRESS		--106
	,EMP_RES_LATITUDE		--107
	,EMP_RES_LONGITUDE		--108
	,EMP_DOMINANT_HAND		--109
	,EMP_COMMENT		--110
	,EMP_MILITARY_STATUS		--111
	,EMP_PH_ZIP_CODE		--112
	,EMP_NEXT_REVIEW_DATE		--113
	,EMP_EXCP_INCL_FLAG		--114
	,EMP_WRL_FLAG		--115
	,EMP_TRAVEL_FLAG		--116
	,EMP_TRAVEL_DISTANCE		--117
	,EMP_ADDR_CODE		--118
	,EMP_ADDR_COMP_CODE		--119
	,EMP_REGION_CODE		--120
	,EMP_REG_COMP_CODE		--121
	,EMP_POS_CODE		--122
	,EMP_SUB_STATUS		--123
	,EMP_HARDSHIP_SUSP_FLAG		--124
	,EMP_ELIGIBILITY_FLAG		--125
	,EMP_PLAN_NUM1		--126
	,EMP_PLAN_NUM2		--127
	,EMP_CHECK_PREF_FLAG		--128
	,EMP_HIST_LAST_APPLIED_DATE		--129
	,EMP_PENSION_NUMBER		--130
	,EMP_HOME_COMP_CODE		--131
	,EMP_WORK_PROVINCE		--132
	,EMP_HOME_DEPT_CODE		--133
	,EMP_DISABLED_FLAG		--134
	,EMP_ABORIGINAL_FLAG		--135
	,EMP_VISIBLE_MINORITY_FLAG		--136
	,EMP_TSH_CODE		--137
	,EMP_USER_ENTERED_OT		--138
	,EMP_USER_ENTERED_DT		--139
	,EMP_SENIORITY_DATE		--140
	,EMP_TD1_PROV_EXEMP_AMT		--141
	,EMP_EXP_APRV_GRP_CODE		--142
	,EMP_TD1_EXEMP_FLAG		--143
	,EMP_LEAVE_CALC_PREF		--144
	,EMP_CALC_ACCRUED_LEAVE		--145
	,EMP_LAST_TSH_JOB_CODE		--146
	,EMP_ADP_FILING_STATUS		--147
	,EMP_STATE_FILING_STATUS		--148
	,EMP_CITY_FILING_STATUS		--149
	,EMP_LEV_ACRU_GL_ACC_CODE		--150
	,EMP_LEV_CLEAR_ACC_CODE		--151
	,EMP_ADJUSTED_SERIVICE_DATE		--152
	,EMP_CALC_PREF		--153
	,EMP_EQUIP_PHS_CODE		--154
	,EMP_INCL_CERT_PY_REP_FLAG		--155
	,EMP_CREATE_DATE		--156
	,EMP_UE_VALID_FLAG		--157
	,EMP_PRIMARY_EMP_NO		--158
	,EMP_HRSS_FLAG		--159
	,EMP_MIN_HOUR_CODE		--160
	,EMP__IU__CREATE_DATE		--161
	,EMP__IU__CREATE_USER		--162
	,EMP__IU__UPDATE_DATE		--163
	,EMP__IU__UPDATE_USER		--164
	,EMP_PREF_CONTACT_MTH		--165
	,EMP_BP_CODE		--166
	,EMP_MILITARY_SEPARATION_DATE		--167
	,EMP_CKLOC_CODE		--168
	,EMP_LAST_TSH_JOB_COMP_CODE		--169
	,EMP_AUTOGENERATE_TIMESHEET		--170
	,EMP_SSE_FLAG		--171
	,EMP_REHIRE_ELIGIBLE		--172
	--,EMP_DISPATCH_FLAG		--173
	--,EMP_FULL_PART_TIME		--174
   from DA.DC_PYEMPLOYEE_TABLE;


cursor cInsertTM is 
   select
	EMP_NO		--1
	,EMP_FIRST_NAME		--2
	,EMP_MIDDLE_NAME		--3
	,EMP_LAST_NAME		--4
	,EMP_PREFIX_NAME		--5
	,EMP_SUFFIX_NAME		--6
	,EMP_NICK_NAME		--7
	,EMP_SIN_NO		--8
	,EMP_TYPE		--9
	,EMP_UNIONIZED		--10
	,EMP_JOB_TITLE		--11
	,EMP_ADDRESS1		--12
	,EMP_ADDRESS2		--13
	,EMP_ADDRESS3		--14
	,EMP_ZIP_CODE		--15
	,EMP_PHONE		--16
	,EMP_FAX		--17
	,EMP_RES_LOC		--18
	,EMP_COUNTRY_CODE		--19
	,EMP_STATE_CODE		--20
	,EMP_COUNTY_CODE		--21
	,EMP_CITY_CODE		--22
	,EMP_VERTEX_GEOCODE		--23
	,EMP_VERTEX_SCHDIST		--24
	,EMP_FILING_STATUS		--25
	,EMP_NR_CERTIFICATE		--26
	,EMP_PRIM_EXEMP		--27
	,EMP_SECN_EXEMP		--28
	,EMP_TERT_EXEMP		--29
	,EMP_PRIM_EXEMP_AMT		--30
	,EMP_SUPL_EXEMP_AMT		--31
	,EMP_COMP_CODE		--32
	,EMP_DEPT_CODE		--33
	,EMP_WRL_CODE		--34
	,EMP_JOB_CODE		--35
	,EMP_PHS_CODE		--36
	,EMP_CAT_CODE		--37
	,EMP_EQUIPMENT_NO		--38
	,EMP_EQUIP_TRAN_CODE		--39
	,EMP_EQUIP_CATEGORY		--40
	,EMP_UNI_CODE		--41
	,EMP_UNION_MEM_NO		--42
	,EMP_MEMBERSHIP_DATE		--43
	,EMP_TRD_CODE		--44
	,EMP_PYG_CODE		--45
	,EMP_HIRE_DATE		--46
	,EMP_RE_HIRE_DATE		--47
	,EMP_TERMINATION_DATE		--48
	,EMP_DATE_DECEASED		--49
	,EMP_DATE_OF_BIRTH		--50
	,EMP_PLACE_OF_BIRTH		--51
	,EMP_GRD_CODE		--52
	,EMP_ETHNIC_CODE		--53
	,EMP_SEX		--54
	,EMP_MARITAL_STATUS		--55
	,EMP_RESIDENT_STATUS		--56
	,EMP_OT_ELIGIBILITY		--57
	,EMP_PAYMENT_MODE		--58
	,EMP_BANK_CODE		--59
	,EMP_BRANCH_CODE		--60
	,EMP_BANK_AC_NO		--61
	,EMP_LAST_INCR_DATE		--62
	,EMP_LAST_PROM_DATE		--63
	,EMP_LAST_TRAN_DATE		--64
	,EMP_ANNUAL_SALARY		--65
	,EMP_HOURLY_RATE		--66
	,EMP_CHARGE_OUT_RATE		--67
	,EMP_BILLING_RATE		--68
	,EMP_PRN_CODE		--69
	,EMP_WCB_CODE		--70
	,EMP_WCB_BY_JOB		--71
	,EMP_PL_CODE		--72
	,EMP_PL_BY_JOB		--73
	,EMP_PREFER_PAY_RATE		--74
	,EMP_PREFER_CHARGE_RATE		--75
	,EMP_PREFER_BILL_RATE		--76
	,EMP_RATE_CODE		--77
	,EMP_OT_RATE_CODE		--78
	,EMP_DOT_RATE_CODE		--79
	,EMP_OTH_RATE_CODE		--80
	,EMP_GL_ACC_CODE		--81
	,EMP_PAYROLL_CLEAR_ACC_CODE		--82
	,EMP_DR_CLEAR_ACC_CODE		--83
	,EMP_SUI_STATE		--84
	,EMP_USER		--85
	,EMP_LAST_UPD_DATE		--86
	,EMP_STATUS		--87
	,EMP_PENSION_FLAG		--88
	,EMP_LOGIN_USER		--89
	,EMP_DEF_COMP_FLAG		--90
	,EMP_TD1_EXEMP_AMT		--91
	,EMP_EI_CODE		--92
	,EMP_YEAR_WORKING_DAYS		--93
	,EMP_YEAR_WORKING_HOURS		--94
	,EMP_SERVICE_YEARS		--95
	,EMP_PH_ADDRESS1		--96
	,EMP_PH_ADDRESS2		--97
	,EMP_PH_ADDRESS3		--98
	,APPLICANT_APL_NO		--99
	,DISABILITY_DIS_CODE		--100
	,LANGUAGE_LANG_NAME		--101
	,EMP_WORK_PHONE		--102
	,EMP_WORK_FAX		--103
	,EMP_CELL_PHONE		--104
	,EMP_PAGER		--105
	,EMP_EMAIL_ADDRESS		--106
	,EMP_RES_LATITUDE		--107
	,EMP_RES_LONGITUDE		--108
	,EMP_DOMINANT_HAND		--109
	,EMP_COMMENT		--110
	,EMP_MILITARY_STATUS		--111
	,EMP_PH_ZIP_CODE		--112
	,EMP_NEXT_REVIEW_DATE		--113
	,EMP_EXCP_INCL_FLAG		--114
	,EMP_WRL_FLAG		--115
	,EMP_TRAVEL_FLAG		--116
	,EMP_TRAVEL_DISTANCE		--117
	,EMP_ADDR_CODE		--118
	,EMP_ADDR_COMP_CODE		--119
	,EMP_REGION_CODE		--120
	,EMP_REG_COMP_CODE		--121
	,EMP_POS_CODE		--122
	,EMP_SUB_STATUS		--123
	,EMP_HARDSHIP_SUSP_FLAG		--124
	,EMP_ELIGIBILITY_FLAG		--125
	,EMP_PLAN_NUM1		--126
	,EMP_PLAN_NUM2		--127
	,EMP_CHECK_PREF_FLAG		--128
	,EMP_HIST_LAST_APPLIED_DATE		--129
	,EMP_PENSION_NUMBER		--130
	,EMP_HOME_COMP_CODE		--131
	,EMP_WORK_PROVINCE		--132
	,EMP_HOME_DEPT_CODE		--133
	,EMP_DISABLED_FLAG		--134
	,EMP_ABORIGINAL_FLAG		--135
	,EMP_VISIBLE_MINORITY_FLAG		--136
	,EMP_TSH_CODE		--137
	,EMP_USER_ENTERED_OT		--138
	,EMP_USER_ENTERED_DT		--139
	,EMP_SENIORITY_DATE		--140
	,EMP_TD1_PROV_EXEMP_AMT		--141
	,EMP_EXP_APRV_GRP_CODE		--142
	,EMP_TD1_EXEMP_FLAG		--143
	,EMP_LEAVE_CALC_PREF		--144
	,EMP_CALC_ACCRUED_LEAVE		--145
	,EMP_LAST_TSH_JOB_CODE		--146
	,EMP_ADP_FILING_STATUS		--147
	,EMP_STATE_FILING_STATUS		--148
	,EMP_CITY_FILING_STATUS		--149
	,EMP_LEV_ACRU_GL_ACC_CODE		--150
	,EMP_LEV_CLEAR_ACC_CODE		--151
	,EMP_ADJUSTED_SERIVICE_DATE		--152
	,EMP_CALC_PREF		--153
	,EMP_EQUIP_PHS_CODE		--154
	,EMP_INCL_CERT_PY_REP_FLAG		--155
	,EMP_CREATE_DATE		--156
	,EMP_UE_VALID_FLAG		--157
	,EMP_PRIMARY_EMP_NO		--158
	,EMP_HRSS_FLAG		--159
	,EMP_MIN_HOUR_CODE		--160
	,EMP__IU__CREATE_DATE		--161
	,EMP__IU__CREATE_USER		--162
	,EMP__IU__UPDATE_DATE		--163
	,EMP__IU__UPDATE_USER		--164
	,EMP_PREF_CONTACT_MTH		--165
	,EMP_BP_CODE		--166
	,EMP_MILITARY_SEPARATION_DATE		--167
	,EMP_CKLOC_CODE		--168
	,EMP_LAST_TSH_JOB_COMP_CODE		--169
	,EMP_AUTOGENERATE_TIMESHEET		--170
	,EMP_SSE_FLAG		--171
	,EMP_REHIRE_ELIGIBLE		--172
	--,EMP_DISPATCH_FLAG		--173
	--,EMP_FULL_PART_TIME		--174
   from DA.DC_PYEMPLOYEE_TABLE
   WHERE emp_termination_date IS NOT NULL;


cursor cInsertRR is 
   select
	EMP_NO		--1
	,EMP_FIRST_NAME		--2
	,EMP_MIDDLE_NAME		--3
	,EMP_LAST_NAME		--4
	,EMP_PREFIX_NAME		--5
	,EMP_SUFFIX_NAME		--6
	,EMP_NICK_NAME		--7
	,EMP_SIN_NO		--8
	,EMP_TYPE		--9
	,EMP_UNIONIZED		--10
	,EMP_JOB_TITLE		--11
	,EMP_ADDRESS1		--12
	,EMP_ADDRESS2		--13
	,EMP_ADDRESS3		--14
	,EMP_ZIP_CODE		--15
	,EMP_PHONE		--16
	,EMP_FAX		--17
	,EMP_RES_LOC		--18
	,EMP_COUNTRY_CODE		--19
	,EMP_STATE_CODE		--20
	,EMP_COUNTY_CODE		--21
	,EMP_CITY_CODE		--22
	,EMP_VERTEX_GEOCODE		--23
	,EMP_VERTEX_SCHDIST		--24
	,EMP_FILING_STATUS		--25
	,EMP_NR_CERTIFICATE		--26
	,EMP_PRIM_EXEMP		--27
	,EMP_SECN_EXEMP		--28
	,EMP_TERT_EXEMP		--29
	,EMP_PRIM_EXEMP_AMT		--30
	,EMP_SUPL_EXEMP_AMT		--31
	,EMP_COMP_CODE		--32
	,EMP_DEPT_CODE		--33
	,EMP_WRL_CODE		--34
	,EMP_JOB_CODE		--35
	,EMP_PHS_CODE		--36
	,EMP_CAT_CODE		--37
	,EMP_EQUIPMENT_NO		--38
	,EMP_EQUIP_TRAN_CODE		--39
	,EMP_EQUIP_CATEGORY		--40
	,EMP_UNI_CODE		--41
	,EMP_UNION_MEM_NO		--42
	,EMP_MEMBERSHIP_DATE		--43
	,EMP_TRD_CODE		--44
	,EMP_PYG_CODE		--45
	,EMP_HIRE_DATE		--46
	,EMP_RE_HIRE_DATE		--47
	,EMP_TERMINATION_DATE		--48
	,EMP_DATE_DECEASED		--49
	,EMP_DATE_OF_BIRTH		--50
	,EMP_PLACE_OF_BIRTH		--51
	,EMP_GRD_CODE		--52
	,EMP_ETHNIC_CODE		--53
	,EMP_SEX		--54
	,EMP_MARITAL_STATUS		--55
	,EMP_RESIDENT_STATUS		--56
	,EMP_OT_ELIGIBILITY		--57
	,EMP_PAYMENT_MODE		--58
	,EMP_BANK_CODE		--59
	,EMP_BRANCH_CODE		--60
	,EMP_BANK_AC_NO		--61
	,EMP_LAST_INCR_DATE		--62
	,EMP_LAST_PROM_DATE		--63
	,EMP_LAST_TRAN_DATE		--64
	,EMP_ANNUAL_SALARY		--65
	,EMP_HOURLY_RATE		--66
	,EMP_CHARGE_OUT_RATE		--67
	,EMP_BILLING_RATE		--68
	,EMP_PRN_CODE		--69
	,EMP_WCB_CODE		--70
	,EMP_WCB_BY_JOB		--71
	,EMP_PL_CODE		--72
	,EMP_PL_BY_JOB		--73
	,EMP_PREFER_PAY_RATE		--74
	,EMP_PREFER_CHARGE_RATE		--75
	,EMP_PREFER_BILL_RATE		--76
	,EMP_RATE_CODE		--77
	,EMP_OT_RATE_CODE		--78
	,EMP_DOT_RATE_CODE		--79
	,EMP_OTH_RATE_CODE		--80
	,EMP_GL_ACC_CODE		--81
	,EMP_PAYROLL_CLEAR_ACC_CODE		--82
	,EMP_DR_CLEAR_ACC_CODE		--83
	,EMP_SUI_STATE		--84
	,EMP_USER		--85
	,EMP_LAST_UPD_DATE		--86
	,EMP_STATUS		--87
	,EMP_PENSION_FLAG		--88
	,EMP_LOGIN_USER		--89
	,EMP_DEF_COMP_FLAG		--90
	,EMP_TD1_EXEMP_AMT		--91
	,EMP_EI_CODE		--92
	,EMP_YEAR_WORKING_DAYS		--93
	,EMP_YEAR_WORKING_HOURS		--94
	,EMP_SERVICE_YEARS		--95
	,EMP_PH_ADDRESS1		--96
	,EMP_PH_ADDRESS2		--97
	,EMP_PH_ADDRESS3		--98
	,APPLICANT_APL_NO		--99
	,DISABILITY_DIS_CODE		--100
	,LANGUAGE_LANG_NAME		--101
	,EMP_WORK_PHONE		--102
	,EMP_WORK_FAX		--103
	,EMP_CELL_PHONE		--104
	,EMP_PAGER		--105
	,EMP_EMAIL_ADDRESS		--106
	,EMP_RES_LATITUDE		--107
	,EMP_RES_LONGITUDE		--108
	,EMP_DOMINANT_HAND		--109
	,EMP_COMMENT		--110
	,EMP_MILITARY_STATUS		--111
	,EMP_PH_ZIP_CODE		--112
	,EMP_NEXT_REVIEW_DATE		--113
	,EMP_EXCP_INCL_FLAG		--114
	,EMP_WRL_FLAG		--115
	,EMP_TRAVEL_FLAG		--116
	,EMP_TRAVEL_DISTANCE		--117
	,EMP_ADDR_CODE		--118
	,EMP_ADDR_COMP_CODE		--119
	,EMP_REGION_CODE		--120
	,EMP_REG_COMP_CODE		--121
	,EMP_POS_CODE		--122
	,EMP_SUB_STATUS		--123
	,EMP_HARDSHIP_SUSP_FLAG		--124
	,EMP_ELIGIBILITY_FLAG		--125
	,EMP_PLAN_NUM1		--126
	,EMP_PLAN_NUM2		--127
	,EMP_CHECK_PREF_FLAG		--128
	,EMP_HIST_LAST_APPLIED_DATE		--129
	,EMP_PENSION_NUMBER		--130
	,EMP_HOME_COMP_CODE		--131
	,EMP_WORK_PROVINCE		--132
	,EMP_HOME_DEPT_CODE		--133
	,EMP_DISABLED_FLAG		--134
	,EMP_ABORIGINAL_FLAG		--135
	,EMP_VISIBLE_MINORITY_FLAG		--136
	,EMP_TSH_CODE		--137
	,EMP_USER_ENTERED_OT		--138
	,EMP_USER_ENTERED_DT		--139
	,EMP_SENIORITY_DATE		--140
	,EMP_TD1_PROV_EXEMP_AMT		--141
	,EMP_EXP_APRV_GRP_CODE		--142
	,EMP_TD1_EXEMP_FLAG		--143
	,EMP_LEAVE_CALC_PREF		--144
	,EMP_CALC_ACCRUED_LEAVE		--145
	,EMP_LAST_TSH_JOB_CODE		--146
	,EMP_ADP_FILING_STATUS		--147
	,EMP_STATE_FILING_STATUS		--148
	,EMP_CITY_FILING_STATUS		--149
	,EMP_LEV_ACRU_GL_ACC_CODE		--150
	,EMP_LEV_CLEAR_ACC_CODE		--151
	,EMP_ADJUSTED_SERIVICE_DATE		--152
	,EMP_CALC_PREF		--153
	,EMP_EQUIP_PHS_CODE		--154
	,EMP_INCL_CERT_PY_REP_FLAG		--155
	,EMP_CREATE_DATE		--156
	,EMP_UE_VALID_FLAG		--157
	,EMP_PRIMARY_EMP_NO		--158
	,EMP_HRSS_FLAG		--159
	,EMP_MIN_HOUR_CODE		--160
	,EMP__IU__CREATE_DATE		--161
	,EMP__IU__CREATE_USER		--162
	,EMP__IU__UPDATE_DATE		--163
	,EMP__IU__UPDATE_USER		--164
	,EMP_PREF_CONTACT_MTH		--165
	,EMP_BP_CODE		--166
	,EMP_MILITARY_SEPARATION_DATE		--167
	,EMP_CKLOC_CODE		--168
	,EMP_LAST_TSH_JOB_COMP_CODE		--169
	,EMP_AUTOGENERATE_TIMESHEET		--170
	,EMP_SSE_FLAG		--171
	,EMP_REHIRE_ELIGIBLE		--172
	--,EMP_DISPATCH_FLAG		--173
	--,EMP_FULL_PART_TIME		--174
   from DA.DC_PYEMPLOYEE_TABLE
   WHERE EMP_RE_HIRE_DATE IS NOT NULL;




BEGIN
 OPEN  cur_err_PYEMPLOYEE_TABLE;
 FETCH cur_err_PYEMPLOYEE_TABLE INTO t_num_errors_PYEMPLOYEE_TABLE;
 CLOSE cur_err_PYEMPLOYEE_TABLE;
 
 OPEN cur_mode;
 FETCH cur_mode INTO t_mode;
 CLOSE cur_mode;

 display_status('Number of errors in DC_ERROR table for DC_PYEMPLOYEE_TABLE table :'||
                TO_CHAR(t_num_errors_PYEMPLOYEE_TABLE));

 IF ( t_num_errors_PYEMPLOYEE_TABLE = 0 OR t_mode = 0)
 THEN

   display_status('Insert into DA.PYEMPLOYEE_TABLE');

--Insert select section 
-- use this statement if speed is the problem and there are no triggers
-- causing mutating problem

/*      INSERT INTO DA.PYEMPLOYEE_TABLE
        (EMP_PH_ZIP_CODE		--1
	,LANGUAGE_LANG_NAME		--2
	,EMP_PHS_CODE		--3
	,EMP_RATE_CODE		--4
	,EMP_RES_LOC		--5
	,EMP_EI_CODE		--6
	,EMP_BRANCH_CODE		--7
	,EMP_FIRST_NAME		--8
	,EMP_DATE_DECEASED		--9
	,EMP_CHARGE_OUT_RATE		--10
	,EMP_COUNTRY_CODE		--11
	,EMP_MIDDLE_NAME		--12
	,EMP_SEX		--13
	,EMP_SUI_STATE		--14
	,EMP_EQUIP_TRAN_CODE		--15
	,EMP_GL_ACC_CODE		--16
	,EMP_CITY_CODE		--17
	,EMP_SUFFIX_NAME		--18
	,EMP_UNIONIZED		--19
	,EMP_PRIM_EXEMP		--20
	,EMP_LOGIN_USER		--21
	,EMP_RE_HIRE_DATE		--22
	,EMP_DR_CLEAR_ACC_CODE		--23
	,EMP_JOB_TITLE		--24
	,EMP_YEAR_WORKING_HOURS		--25
	,EMP_RESIDENT_STATUS		--26
	,EMP_EQUIP_CATEGORY		--27
	,EMP_UNION_MEM_NO		--28
	,EMP_SUPL_EXEMP_AMT		--29
	,EMP_TRD_CODE		--30
	,EMP_UNI_CODE		--31
	,EMP_SIN_NO		--32
	,EMP_BILLING_RATE		--33
	,EMP_MARITAL_STATUS		--34
	,EMP_ZIP_CODE		--35
	,EMP_PAGER		--36
	,EMP_OTH_RATE_CODE		--37
	,EMP_DOMINANT_HAND		--38
	,EMP_RES_LONGITUDE		--39
	,EMP_SERVICE_YEARS		--40
	,EMP_EQUIPMENT_NO		--41
	,EMP_PENSION_FLAG		--42
	,EMP_PL_CODE		--43
	,EMP_WCB_CODE		--44
	,EMP_BANK_CODE		--45
	,EMP_GRD_CODE		--46
	,EMP_PREFER_PAY_RATE		--47
	,EMP_LAST_UPD_DATE		--48
	,EMP_FILING_STATUS		--49
	,EMP_TERT_EXEMP		--50
	,EMP_FAX		--51
	,EMP_WORK_FAX		--52
	,EMP_NICK_NAME		--53
	,DISABILITY_DIS_CODE		--54
	,EMP_TERMINATION_DATE		--55
	,EMP_PAYROLL_CLEAR_ACC_CODE		--56
	,EMP_MEMBERSHIP_DATE		--57
	,EMP_PYG_CODE		--58
	,EMP_DATE_OF_BIRTH		--59
	,EMP_DOT_RATE_CODE		--60
	,EMP_NEXT_REVIEW_DATE		--61
	,EMP_EMAIL_ADDRESS		--62
	,EMP_MILITARY_STATUS		--63
	,EMP_PH_ADDRESS1		--64
	,EMP_LAST_PROM_DATE		--65
	,EMP_PH_ADDRESS2		--66
	,EMP_WRL_CODE		--67
	,EMP_PH_ADDRESS3		--68
	,EMP_PL_BY_JOB		--69
	,EMP_WCB_BY_JOB		--70
	,EMP_COMMENT		--71
	,APPLICANT_APL_NO		--72
	,EMP_VERTEX_GEOCODE		--73
	,EMP_JOB_CODE		--74
	,EMP_DEF_COMP_FLAG		--75
	,EMP_PRIM_EXEMP_AMT		--76
	,EMP_CELL_PHONE		--77
	,EMP_STATE_CODE		--78
	,EMP_BANK_AC_NO		--79
	,EMP_LAST_INCR_DATE		--80
	,EMP_USER		--81
	,EMP_YEAR_WORKING_DAYS		--82
	,EMP_NR_CERTIFICATE		--83
	,EMP_TYPE		--84
	,EMP_PAYMENT_MODE		--85
	,EMP_STATUS		--86
	,EMP_RES_LATITUDE		--87
	,EMP_HIRE_DATE		--88
	,EMP_LAST_TRAN_DATE		--89
	,EMP_SECN_EXEMP		--90
	,EMP_DEPT_CODE		--91
	,EMP_TD1_EXEMP_AMT		--92
	,EMP_OT_RATE_CODE		--93
	,EMP_COMP_CODE		--94
	,EMP_PRN_CODE		--95
	,EMP_ANNUAL_SALARY		--96
	,EMP_HOURLY_RATE		--97
	,EMP_PREFIX_NAME		--98
	,EMP_VERTEX_SCHDIST		--99
	,EMP_PREFER_BILL_RATE		--100
	,EMP_PLACE_OF_BIRTH		--101
	,EMP_CAT_CODE		--102
	,EMP_LAST_NAME		--103
	,EMP_ETHNIC_CODE		--104
	,EMP_ADDRESS1		--105
	,EMP_PREFER_CHARGE_RATE		--106
	,EMP_ADDRESS2		--107
	,EMP_ADDRESS3		--108
	,EMP_OT_ELIGIBILITY		--109
	,EMP_PHONE		--110
	,EMP_WORK_PHONE		--111
	,EMP_COUNTY_CODE		--112
	,EMP_NO		--113
        ,EMP_STATE_FILING_STATUS   --114
        ,EMP_CITY_FILING_STATUS    --115
        ,EMP_LEV_ACRU_GL_ACC_CODE  --116
        ,EMP_LEV_CLEAR_ACC_CODE    --117
        ,EMP_TD1_PROV_EXEMP_AMT    --118
        ,EMP_TD1_EXEMP_FLAG        --119
        ,EMP_WRL_FLAG              --120
	,EMP_TRAVEL_FLAG           --121
        ,EMP_TRAVEL_DISTANCE       --122
        ,EMP_POS_CODE              --123
        ,EMP_SUB_STATUS            --124
        ,EMP_HOME_COMP_CODE        --125
	,EMP_HOME_DEPT_CODE        --126
        ,EMP_USER_ENTERED_OT       --127
        ,EMP_USER_ENTERED_DT       --128
        ,EMP_SENIORITY_DATE        --129
        ,EMP_EXP_APRV_GRP_CODE     --130
        ,EMP_CALC_ACCRUED_LEAVE    --131
        ,EMP_CALC_PREF              --132
        ,EMP_LEAVE_CALC_PREF        --133
        ,EMP_TSH_CODE        -- Used only by ADP employee import  --134
        ,EMP_INCL_CERT_PY_REP_FLAG   -- 135
	,EMP_PRIMARY_EMP_NO		--136
	,EMP_REHIRE_ELIGIBLE		--137
	,EMP_CKLOC_CODE			-- 138
	,EMP_AUTOGENERATE_TIMESHEET	-- 139
) SELECT
	EMP_PH_ZIP_CODE		--1
	,LANGUAGE_LANG_NAME		--2
	,EMP_PHS_CODE		--3
	,EMP_RATE_CODE		--4
	,EMP_RES_LOC		--5
	,EMP_EI_CODE		--6
	,EMP_BRANCH_CODE		--7
	,EMP_FIRST_NAME		--8
	,EMP_DATE_DECEASED		--9
	,EMP_CHARGE_OUT_RATE		--10
	,EMP_COUNTRY_CODE		--11
	,EMP_MIDDLE_NAME		--12
	,EMP_SEX		--13
	,EMP_SUI_STATE		--14
	,EMP_EQUIP_TRAN_CODE		--15
	,EMP_GL_ACC_CODE		--16
	,EMP_CITY_CODE		--17
	,EMP_SUFFIX_NAME		--18
	,EMP_UNIONIZED		--19
	,EMP_PRIM_EXEMP		--20
	,EMP_LOGIN_USER		--21
	,EMP_RE_HIRE_DATE		--22
	,EMP_DR_CLEAR_ACC_CODE		--23
	,EMP_JOB_TITLE		--24
	,EMP_YEAR_WORKING_HOURS		--25
	,EMP_RESIDENT_STATUS		--26
	,EMP_EQUIP_CATEGORY		--27
	,EMP_UNION_MEM_NO		--28
	,EMP_SUPL_EXEMP_AMT		--29
	,EMP_TRD_CODE		--30
	,EMP_UNI_CODE		--31
	,EMP_SIN_NO		--32
	,EMP_BILLING_RATE		--33
	,EMP_MARITAL_STATUS		--34
	,EMP_ZIP_CODE		--35
	,EMP_PAGER		--36
	,EMP_OTH_RATE_CODE		--37
	,EMP_DOMINANT_HAND		--38
	,EMP_RES_LONGITUDE		--39
	,EMP_SERVICE_YEARS		--40
	,EMP_EQUIPMENT_NO		--41
	,EMP_PENSION_FLAG		--42
	,EMP_PL_CODE		--43
	,EMP_WCB_CODE		--44
	,EMP_BANK_CODE		--45
	,EMP_GRD_CODE		--46
	,EMP_PREFER_PAY_RATE		--47
	,EMP_LAST_UPD_DATE		--48
	,EMP_FILING_STATUS		--49
	,EMP_TERT_EXEMP		--50
	,EMP_FAX		--51
	,EMP_WORK_FAX		--52
	,EMP_NICK_NAME		--53
	,DISABILITY_DIS_CODE		--54
	,EMP_TERMINATION_DATE		--55
	,EMP_PAYROLL_CLEAR_ACC_CODE		--56
	,EMP_MEMBERSHIP_DATE		--57
	,EMP_PYG_CODE		--58
	,EMP_DATE_OF_BIRTH		--59
	,EMP_DOT_RATE_CODE		--60
	,EMP_NEXT_REVIEW_DATE		--61
	,EMP_EMAIL_ADDRESS		--62
	,EMP_MILITARY_STATUS		--63
	,EMP_PH_ADDRESS1		--64
	,EMP_LAST_PROM_DATE		--65
	,EMP_PH_ADDRESS2		--66
	,EMP_WRL_CODE		--67
	,EMP_PH_ADDRESS3		--68
	,EMP_PL_BY_JOB		--69
	,EMP_WCB_BY_JOB		--70
	,EMP_COMMENT		--71
	,APPLICANT_APL_NO		--72
	,EMP_VERTEX_GEOCODE		--73
	,EMP_JOB_CODE		--74
	,EMP_DEF_COMP_FLAG		--75
	,EMP_PRIM_EXEMP_AMT		--76
	,EMP_CELL_PHONE		--77
	,EMP_STATE_CODE		--78
	,EMP_BANK_AC_NO		--79
	,EMP_LAST_INCR_DATE		--80
	,EMP_USER		--81
	,EMP_YEAR_WORKING_DAYS		--82
	,EMP_NR_CERTIFICATE		--83
	,EMP_TYPE		--84
	,EMP_PAYMENT_MODE		--85
	,EMP_STATUS		--86
	,EMP_RES_LATITUDE		--87
	,EMP_HIRE_DATE		--88
	,EMP_LAST_TRAN_DATE		--89
	,EMP_SECN_EXEMP		--90
	,EMP_DEPT_CODE		--91
	,EMP_TD1_EXEMP_AMT		--92
	,EMP_OT_RATE_CODE		--93
	,EMP_COMP_CODE		--94
	,EMP_PRN_CODE		--95
	,EMP_ANNUAL_SALARY		--96
	,EMP_HOURLY_RATE		--97
	,EMP_PREFIX_NAME		--98
	,EMP_VERTEX_SCHDIST		--99
	,EMP_PREFER_BILL_RATE		--100
	,EMP_PLACE_OF_BIRTH		--101
	,EMP_CAT_CODE		--102
	,EMP_LAST_NAME		--103
	,EMP_ETHNIC_CODE		--104
	,EMP_ADDRESS1		--105
	,EMP_PREFER_CHARGE_RATE		--106
	,EMP_ADDRESS2		--107
	,EMP_ADDRESS3		--108
	,EMP_OT_ELIGIBILITY		--109
	,EMP_PHONE		--110
	,EMP_WORK_PHONE		--111
	,EMP_COUNTY_CODE		--112
	,EMP_NO		--113
        ,EMP_STATE_FILING_STATUS   --114
        ,EMP_CITY_FILING_STATUS    --115
        ,EMP_LEV_ACRU_GL_ACC_CODE  --116
        ,EMP_LEV_CLEAR_ACC_CODE    --117
        ,EMP_TD1_PROV_EXEMP_AMT    --118
        ,EMP_TD1_EXEMP_FLAG        --119
        ,EMP_WRL_FLAG              --120
	,EMP_TRAVEL_FLAG           --121
        ,EMP_TRAVEL_DISTANCE       --122
        ,EMP_POS_CODE              --123
        ,EMP_SUB_STATUS            --124
        ,EMP_HOME_COMP_CODE        --125
	,EMP_HOME_DEPT_CODE        --126
        ,EMP_USER_ENTERED_OT       --127
        ,EMP_USER_ENTERED_DT       --128
        ,EMP_SENIORITY_DATE        --129
        ,EMP_EXP_APRV_GRP_CODE     --130
        ,EMP_CALC_ACCRUED_LEAVE    --131
        ,EMP_CALC_PREF              --132
        ,EMP_LEAVE_CALC_PREF        --133
        ,EMP_TSH_CODE        -- Used only by ADP employee import --134
        ,EMP_INCL_CERT_PY_REP_FLAG   -- 135
	,EMP_PRIMARY_EMP_NO		--136
	,EMP_REHIRE_ELIGIBLE		--137
	,EMP_CKLOC_CODE			-- 138
	,EMP_AUTOGENERATE_TIMESHEET	-- 139
    FROM DA.DC_PYEMPLOYEE_TABLE;
	-- WHERE NVL(dc_valid_flag,'N') <> 'N';
*/

--End of insert select section

--insert loop
   for row_dc in cInsert
   loop
     insert into DA.PYEMPLOYEE_TABLE
        (EMP_NO		--1
	,EMP_FIRST_NAME		--2
	,EMP_MIDDLE_NAME		--3
	,EMP_LAST_NAME		--4
	,EMP_PREFIX_NAME		--5
	,EMP_SUFFIX_NAME		--6
	,EMP_NICK_NAME		--7
	,EMP_SIN_NO		--8
	,EMP_TYPE		--9
	,EMP_UNIONIZED		--10
	,EMP_JOB_TITLE		--11
	,EMP_ADDRESS1		--12
	,EMP_ADDRESS2		--13
	,EMP_ADDRESS3		--14
	,EMP_ZIP_CODE		--15
	,EMP_PHONE		--16
	,EMP_FAX		--17
	,EMP_RES_LOC		--18
	,EMP_COUNTRY_CODE		--19
	,EMP_STATE_CODE		--20
	,EMP_COUNTY_CODE		--21
	,EMP_CITY_CODE		--22
	,EMP_VERTEX_GEOCODE		--23
	,EMP_VERTEX_SCHDIST		--24
	,EMP_FILING_STATUS		--25
	,EMP_NR_CERTIFICATE		--26
	,EMP_PRIM_EXEMP		--27
	,EMP_SECN_EXEMP		--28
	,EMP_TERT_EXEMP		--29
	,EMP_PRIM_EXEMP_AMT		--30
	,EMP_SUPL_EXEMP_AMT		--31
	,EMP_COMP_CODE		--32
	,EMP_DEPT_CODE		--33
	,EMP_WRL_CODE		--34
	,EMP_JOB_CODE		--35
	,EMP_PHS_CODE		--36
	,EMP_CAT_CODE		--37
	,EMP_EQUIPMENT_NO		--38
	,EMP_EQUIP_TRAN_CODE		--39
	,EMP_EQUIP_CATEGORY		--40
	,EMP_UNI_CODE		--41
	,EMP_UNION_MEM_NO		--42
	,EMP_MEMBERSHIP_DATE		--43
	,EMP_TRD_CODE		--44
	,EMP_PYG_CODE		--45
	,EMP_HIRE_DATE		--46
	,EMP_RE_HIRE_DATE		--47
	,EMP_TERMINATION_DATE		--48
	,EMP_DATE_DECEASED		--49
	,EMP_DATE_OF_BIRTH		--50
	,EMP_PLACE_OF_BIRTH		--51
	,EMP_GRD_CODE		--52
	,EMP_ETHNIC_CODE		--53
	,EMP_SEX		--54
	,EMP_MARITAL_STATUS		--55
	,EMP_RESIDENT_STATUS		--56
	,EMP_OT_ELIGIBILITY		--57
	,EMP_PAYMENT_MODE		--58
	,EMP_BANK_CODE		--59
	,EMP_BRANCH_CODE		--60
	,EMP_BANK_AC_NO		--61
	,EMP_LAST_INCR_DATE		--62
	,EMP_LAST_PROM_DATE		--63
	,EMP_LAST_TRAN_DATE		--64
	,EMP_ANNUAL_SALARY		--65
	,EMP_HOURLY_RATE		--66
	,EMP_CHARGE_OUT_RATE		--67
	,EMP_BILLING_RATE		--68
	,EMP_PRN_CODE		--69
	,EMP_WCB_CODE		--70
	,EMP_WCB_BY_JOB		--71
	,EMP_PL_CODE		--72
	,EMP_PL_BY_JOB		--73
	,EMP_PREFER_PAY_RATE		--74
	,EMP_PREFER_CHARGE_RATE		--75
	,EMP_PREFER_BILL_RATE		--76
	,EMP_RATE_CODE		--77
	,EMP_OT_RATE_CODE		--78
	,EMP_DOT_RATE_CODE		--79
	,EMP_OTH_RATE_CODE		--80
	,EMP_GL_ACC_CODE		--81
	,EMP_PAYROLL_CLEAR_ACC_CODE		--82
	,EMP_DR_CLEAR_ACC_CODE		--83
	,EMP_SUI_STATE		--84
	,EMP_USER		--85
	,EMP_LAST_UPD_DATE		--86
	,EMP_STATUS		--87
	,EMP_PENSION_FLAG		--88
	,EMP_LOGIN_USER		--89
	,EMP_DEF_COMP_FLAG		--90
	,EMP_TD1_EXEMP_AMT		--91
	,EMP_EI_CODE		--92
	,EMP_YEAR_WORKING_DAYS		--93
	,EMP_YEAR_WORKING_HOURS		--94
	,EMP_SERVICE_YEARS		--95
	,EMP_PH_ADDRESS1		--96
	,EMP_PH_ADDRESS2		--97
	,EMP_PH_ADDRESS3		--98
	,APPLICANT_APL_NO		--99
	,DISABILITY_DIS_CODE		--100
	,LANGUAGE_LANG_NAME		--101
	,EMP_WORK_PHONE		--102
	,EMP_WORK_FAX		--103
	,EMP_CELL_PHONE		--104
	,EMP_PAGER		--105
	,EMP_EMAIL_ADDRESS		--106
	,EMP_RES_LATITUDE		--107
	,EMP_RES_LONGITUDE		--108
	,EMP_DOMINANT_HAND		--109
	,EMP_COMMENT		--110
	,EMP_MILITARY_STATUS		--111
	,EMP_PH_ZIP_CODE		--112
	,EMP_NEXT_REVIEW_DATE		--113
	,EMP_EXCP_INCL_FLAG		--114
	,EMP_WRL_FLAG		--115
	,EMP_TRAVEL_FLAG		--116
	,EMP_TRAVEL_DISTANCE		--117
	,EMP_ADDR_CODE		--118
	,EMP_ADDR_COMP_CODE		--119
	,EMP_REGION_CODE		--120
	,EMP_REG_COMP_CODE		--121
	,EMP_POS_CODE		--122
	,EMP_SUB_STATUS		--123
	,EMP_HARDSHIP_SUSP_FLAG		--124
	,EMP_ELIGIBILITY_FLAG		--125
	,EMP_PLAN_NUM1		--126
	,EMP_PLAN_NUM2		--127
	,EMP_CHECK_PREF_FLAG		--128
	,EMP_HIST_LAST_APPLIED_DATE		--129
	,EMP_PENSION_NUMBER		--130
	,EMP_HOME_COMP_CODE		--131
	,EMP_WORK_PROVINCE		--132
	,EMP_HOME_DEPT_CODE		--133
	,EMP_DISABLED_FLAG		--134
	,EMP_ABORIGINAL_FLAG		--135
	,EMP_VISIBLE_MINORITY_FLAG		--136
	,EMP_TSH_CODE		--137
	,EMP_USER_ENTERED_OT		--138
	,EMP_USER_ENTERED_DT		--139
	,EMP_SENIORITY_DATE		--140
	,EMP_TD1_PROV_EXEMP_AMT		--141
	,EMP_EXP_APRV_GRP_CODE		--142
	,EMP_TD1_EXEMP_FLAG		--143
	,EMP_LEAVE_CALC_PREF		--144
	,EMP_CALC_ACCRUED_LEAVE		--145
	,EMP_LAST_TSH_JOB_CODE		--146
	,EMP_ADP_FILING_STATUS		--147
	,EMP_STATE_FILING_STATUS		--148
	,EMP_CITY_FILING_STATUS		--149
	,EMP_LEV_ACRU_GL_ACC_CODE		--150
	,EMP_LEV_CLEAR_ACC_CODE		--151
	,EMP_ADJUSTED_SERIVICE_DATE		--152
	,EMP_CALC_PREF		--153
	,EMP_EQUIP_PHS_CODE		--154
	,EMP_INCL_CERT_PY_REP_FLAG		--155
	,EMP_CREATE_DATE		--156
	,EMP_UE_VALID_FLAG		--157
	,EMP_PRIMARY_EMP_NO		--158
	,EMP_HRSS_FLAG		--159
	,EMP_MIN_HOUR_CODE		--160
	,EMP__IU__CREATE_DATE		--161
	,EMP__IU__CREATE_USER		--162
	,EMP__IU__UPDATE_DATE		--163
	,EMP__IU__UPDATE_USER		--164
	,EMP_PREF_CONTACT_MTH		--165
	,EMP_BP_CODE		--166
	,EMP_MILITARY_SEPARATION_DATE		--167
	,EMP_CKLOC_CODE		--168
	,EMP_LAST_TSH_JOB_COMP_CODE		--169
	,EMP_AUTOGENERATE_TIMESHEET		--170
	,EMP_SSE_FLAG		--171
	,EMP_REHIRE_ELIGIBLE		--172
	--,EMP_DISPATCH_FLAG		--173
	--,EMP_FULL_PART_TIME		--174
     )values
	(row_dc.EMP_NO		--1
	,row_dc.EMP_FIRST_NAME		--2
	,row_dc.EMP_MIDDLE_NAME		--3
	,row_dc.EMP_LAST_NAME		--4
	,row_dc.EMP_PREFIX_NAME		--5
	,row_dc.EMP_SUFFIX_NAME		--6
	,row_dc.EMP_NICK_NAME		--7
	,row_dc.EMP_SIN_NO		--8
	,row_dc.EMP_TYPE		--9
	,row_dc.EMP_UNIONIZED		--10
	,row_dc.EMP_JOB_TITLE		--11
	,row_dc.EMP_ADDRESS1		--12
	,row_dc.EMP_ADDRESS2		--13
	,row_dc.EMP_ADDRESS3		--14
	,row_dc.EMP_ZIP_CODE		--15
	,row_dc.EMP_PHONE		--16
	,row_dc.EMP_FAX		--17
	,row_dc.EMP_RES_LOC		--18
	,row_dc.EMP_COUNTRY_CODE		--19
	,row_dc.EMP_STATE_CODE		--20
	,row_dc.EMP_COUNTY_CODE		--21
	,row_dc.EMP_CITY_CODE		--22
	,row_dc.EMP_VERTEX_GEOCODE		--23
	,row_dc.EMP_VERTEX_SCHDIST		--24
	,row_dc.EMP_FILING_STATUS		--25
	,row_dc.EMP_NR_CERTIFICATE		--26
	,row_dc.EMP_PRIM_EXEMP		--27
	,row_dc.EMP_SECN_EXEMP		--28
	,row_dc.EMP_TERT_EXEMP		--29
	,row_dc.EMP_PRIM_EXEMP_AMT		--30
	,row_dc.EMP_SUPL_EXEMP_AMT		--31
	,row_dc.EMP_COMP_CODE		--32
	,row_dc.EMP_DEPT_CODE		--33
	,row_dc.EMP_WRL_CODE		--34
	,row_dc.EMP_JOB_CODE		--35
	,row_dc.EMP_PHS_CODE		--36
	,row_dc.EMP_CAT_CODE		--37
	,row_dc.EMP_EQUIPMENT_NO		--38
	,row_dc.EMP_EQUIP_TRAN_CODE		--39
	,row_dc.EMP_EQUIP_CATEGORY		--40
	,row_dc.EMP_UNI_CODE		--41
	,row_dc.EMP_UNION_MEM_NO		--42
	,row_dc.EMP_MEMBERSHIP_DATE		--43
	,row_dc.EMP_TRD_CODE		--44
	,row_dc.EMP_PYG_CODE		--45
	,row_dc.EMP_HIRE_DATE		--46
	,row_dc.EMP_RE_HIRE_DATE		--47
	,row_dc.EMP_TERMINATION_DATE		--48
	,row_dc.EMP_DATE_DECEASED		--49
	,row_dc.EMP_DATE_OF_BIRTH		--50
	,row_dc.EMP_PLACE_OF_BIRTH		--51
	,row_dc.EMP_GRD_CODE		--52
	,row_dc.EMP_ETHNIC_CODE		--53
	,row_dc.EMP_SEX		--54
	,row_dc.EMP_MARITAL_STATUS		--55
	,row_dc.EMP_RESIDENT_STATUS		--56
	,row_dc.EMP_OT_ELIGIBILITY		--57
	,row_dc.EMP_PAYMENT_MODE		--58
	,row_dc.EMP_BANK_CODE		--59
	,row_dc.EMP_BRANCH_CODE		--60
	,row_dc.EMP_BANK_AC_NO		--61
	,row_dc.EMP_LAST_INCR_DATE		--62
	,row_dc.EMP_LAST_PROM_DATE		--63
	,row_dc.EMP_LAST_TRAN_DATE		--64
	,row_dc.EMP_ANNUAL_SALARY		--65
	,row_dc.EMP_HOURLY_RATE		--66
	,row_dc.EMP_CHARGE_OUT_RATE		--67
	,row_dc.EMP_BILLING_RATE		--68
	,row_dc.EMP_PRN_CODE		--69
	,row_dc.EMP_WCB_CODE		--70
	,row_dc.EMP_WCB_BY_JOB		--71
	,row_dc.EMP_PL_CODE		--72
	,row_dc.EMP_PL_BY_JOB		--73
	,row_dc.EMP_PREFER_PAY_RATE		--74
	,row_dc.EMP_PREFER_CHARGE_RATE		--75
	,row_dc.EMP_PREFER_BILL_RATE		--76
	,row_dc.EMP_RATE_CODE		--77
	,row_dc.EMP_OT_RATE_CODE		--78
	,row_dc.EMP_DOT_RATE_CODE		--79
	,row_dc.EMP_OTH_RATE_CODE		--80
	,row_dc.EMP_GL_ACC_CODE		--81
	,row_dc.EMP_PAYROLL_CLEAR_ACC_CODE		--82
	,row_dc.EMP_DR_CLEAR_ACC_CODE		--83
	,row_dc.EMP_SUI_STATE		--84
	,row_dc.EMP_USER		--85
	,row_dc.EMP_LAST_UPD_DATE		--86
	,row_dc.EMP_STATUS		--87
	,row_dc.EMP_PENSION_FLAG		--88
	,row_dc.EMP_LOGIN_USER		--89
	,row_dc.EMP_DEF_COMP_FLAG		--90
	,row_dc.EMP_TD1_EXEMP_AMT		--91
	,row_dc.EMP_EI_CODE		--92
	,row_dc.EMP_YEAR_WORKING_DAYS		--93
	,row_dc.EMP_YEAR_WORKING_HOURS		--94
	,row_dc.EMP_SERVICE_YEARS		--95
	,row_dc.EMP_PH_ADDRESS1		--96
	,row_dc.EMP_PH_ADDRESS2		--97
	,row_dc.EMP_PH_ADDRESS3		--98
	,row_dc.APPLICANT_APL_NO		--99
	,row_dc.DISABILITY_DIS_CODE		--100
	,row_dc.LANGUAGE_LANG_NAME		--101
	,row_dc.EMP_WORK_PHONE		--102
	,row_dc.EMP_WORK_FAX		--103
	,row_dc.EMP_CELL_PHONE		--104
	,row_dc.EMP_PAGER		--105
	,row_dc.EMP_EMAIL_ADDRESS		--106
	,row_dc.EMP_RES_LATITUDE		--107
	,row_dc.EMP_RES_LONGITUDE		--108
	,row_dc.EMP_DOMINANT_HAND		--109
	,row_dc.EMP_COMMENT		--110
	,row_dc.EMP_MILITARY_STATUS		--111
	,row_dc.EMP_PH_ZIP_CODE		--112
	,row_dc.EMP_NEXT_REVIEW_DATE		--113
	,row_dc.EMP_EXCP_INCL_FLAG		--114
	,row_dc.EMP_WRL_FLAG		--115
	,row_dc.EMP_TRAVEL_FLAG		--116
	,row_dc.EMP_TRAVEL_DISTANCE		--117
	,row_dc.EMP_ADDR_CODE		--118
	,row_dc.EMP_ADDR_COMP_CODE		--119
	,row_dc.EMP_REGION_CODE		--120
	,row_dc.EMP_REG_COMP_CODE		--121
	,row_dc.EMP_POS_CODE		--122
	,row_dc.EMP_SUB_STATUS		--123
	,row_dc.EMP_HARDSHIP_SUSP_FLAG		--124
	,row_dc.EMP_ELIGIBILITY_FLAG		--125
	,row_dc.EMP_PLAN_NUM1		--126
	,row_dc.EMP_PLAN_NUM2		--127
	,row_dc.EMP_CHECK_PREF_FLAG		--128
	,row_dc.EMP_HIST_LAST_APPLIED_DATE		--129
	,row_dc.EMP_PENSION_NUMBER		--130
	,row_dc.EMP_HOME_COMP_CODE		--131
	,row_dc.EMP_WORK_PROVINCE		--132
	,row_dc.EMP_HOME_DEPT_CODE		--133
	,row_dc.EMP_DISABLED_FLAG		--134
	,row_dc.EMP_ABORIGINAL_FLAG		--135
	,row_dc.EMP_VISIBLE_MINORITY_FLAG		--136
	,row_dc.EMP_TSH_CODE		--137
	,row_dc.EMP_USER_ENTERED_OT		--138
	,row_dc.EMP_USER_ENTERED_DT		--139
	,row_dc.EMP_SENIORITY_DATE		--140
	,row_dc.EMP_TD1_PROV_EXEMP_AMT		--141
	,row_dc.EMP_EXP_APRV_GRP_CODE		--142
	,row_dc.EMP_TD1_EXEMP_FLAG		--143
	,row_dc.EMP_LEAVE_CALC_PREF		--144
	,row_dc.EMP_CALC_ACCRUED_LEAVE		--145
	,row_dc.EMP_LAST_TSH_JOB_CODE		--146
	,row_dc.EMP_ADP_FILING_STATUS		--147
	,row_dc.EMP_STATE_FILING_STATUS		--148
	,row_dc.EMP_CITY_FILING_STATUS		--149
	,row_dc.EMP_LEV_ACRU_GL_ACC_CODE		--150
	,row_dc.EMP_LEV_CLEAR_ACC_CODE		--151
	,row_dc.EMP_ADJUSTED_SERIVICE_DATE		--152
	,row_dc.EMP_CALC_PREF		--153
	,row_dc.EMP_EQUIP_PHS_CODE		--154
	,row_dc.EMP_INCL_CERT_PY_REP_FLAG		--155
	,row_dc.EMP_CREATE_DATE		--156
	,row_dc.EMP_UE_VALID_FLAG		--157
	,row_dc.EMP_PRIMARY_EMP_NO		--158
	,row_dc.EMP_HRSS_FLAG		--159
	,row_dc.EMP_MIN_HOUR_CODE		--160
	,row_dc.EMP__IU__CREATE_DATE		--161
	,row_dc.EMP__IU__CREATE_USER		--162
	,row_dc.EMP__IU__UPDATE_DATE		--163
	,row_dc.EMP__IU__UPDATE_USER		--164
	,row_dc.EMP_PREF_CONTACT_MTH		--165
	,row_dc.EMP_BP_CODE		--166
	,row_dc.EMP_MILITARY_SEPARATION_DATE		--167
	,row_dc.EMP_CKLOC_CODE		--168
	,row_dc.EMP_LAST_TSH_JOB_COMP_CODE		--169
	,row_dc.EMP_AUTOGENERATE_TIMESHEET		--170
	,row_dc.EMP_SSE_FLAG		--171
	,row_dc.EMP_REHIRE_ELIGIBLE		--172
	--,row_dc.EMP_DISPATCH_FLAG		--173
	--,row_dc.EMP_FULL_PART_TIME		--174
     );
   end loop;
--end of loop insert



   display_status('Insert into DA.PYEMPHIST');


-- PYEMPHIST Insert

	for row_dc in cInsert
	loop
   	INSERT INTO da.PYEMPHIST
	(EMH_EMP_NO                             --1
	,EMH_SEQ_NO                             --2
	,EMH_ACTION_CODE                        --3
	,EMH_EFFECTIVE_DATE                     --4
        ,EMH_TXT_TYPE                           --5
        ,EMH_TXT_CODE                           --6
	 ,EMH_FIRST_NAME
	 ,EMH_MIDDLE_NAME
	 ,EMH_LAST_NAME
	 ,EMH_PREFIX_NAME
	 ,EMH_SUFFIX_NAME
	 ,EMH_NICK_NAME
	 ,EMH_SIN_NO
	 ,EMH_EMP_TYPE
	 ,EMH_EMP_UNIONIZED
	 ,EMH_JOB_TITLE
	 ,EMH_ADDRESS1
	 ,EMH_ADDRESS2
	 ,EMH_ADDRESS3
	 ,EMH_ZIP_CODE
	 ,EMH_PHONE
	 ,EMH_FAX
	 ,EMH_RES_LOC
	 ,EMH_EMP_COUNTRY_CODE
	 ,EMH_EMP_STATE_CODE
	 ,EMH_COUNTY_CODE
	 ,EMH_CITY_CODE
	 ,EMH_VERTEX_GEOCODE
	 ,EMH_VERTEX_SCHDIST
	 ,EMH_FILING_STATUS
	 ,EMH_NR_CERTIFICATE
	 ,EMH_PRIM_EXEMP
	 ,EMH_SECN_EXEMP
	 ,EMH_TERT_EXEMP
	 ,EMH_PRIM_EXEMP_AMT
	 ,EMH_SUPL_EXEMP_AMT
	 ,EMH_COMP_CODE
	 ,EMH_DEPARTMENT_CODE
	 ,EMH_WORK_LOCATION
	 ,EMH_JOB_CODE
	 ,EMH_PHS_CODE
	 ,EMH_CAT_CODE
	 ,EMH_EQUIPMENT_NO
	 ,EMH_EQUIP_TRAN_CODE
	 ,EMH_EQUIP_CATEGORY
	 ,EMH_UNION_CODE
	 ,EMH_UNION_MEM_NO
	 ,EMH_MEMBERSHIP_DATE
	 ,EMH_TRADE_CODE
	 ,EMH_PAY_GROUP
	 ,EMH_HIRE_DATE
	 ,EMH_RE_HIRE_DATE
	 ,EMH_TERMINATION_DATE
	 ,EMH_DATE_DECEASED
	 ,EMH_DATE_OF_BIRTH
	 ,EMH_PLACE_OF_BIRTH
	 ,EMH_GRD_CODE
	 ,EMH_ETHNIC_CODE
	 ,EMH_SEX
	 ,EMH_MARITAL_STATUS
	 ,EMH_RESIDENT_STATUS
	 ,EMH_OT_ELIGIBILITY
	 ,EMH_PAYMENT_MODE
	 ,EMH_BANK_CODE
	 ,EMH_BRANCH_CODE
	 ,EMH_BANK_AC_NO
	 ,EMH_LAST_INCR_DATE
	 ,EMH_LAST_PROM_DATE
	 ,EMH_LAST_TRAN_DATE
	 ,EMH_ANNUAL_SALARY
	 ,EMH_HOUR_RATE
	 ,EMH_CHARGE_RATE
	 ,EMH_BILLING_RATE
	 ,EMH_PRN_CODE
	 ,EMH_WCB_CODE
	 ,EMH_WCB_BY_JOB
	 ,EMH_PL_CODE
	 ,EMH_PL_BY_JOB
	 ,EMH_PREFER_PAY_RATE
	 ,EMH_PREFER_CHARGE_RATE
	 ,EMH_PREFER_BILL_RATE
	 ,EMH_RATE_CODE
	 ,EMH_OT_RATE_CODE
	 ,EMH_DOT_RATE_CODE
	 ,EMH_OTH_RATE_CODE
	 ,EMH_GL_ACC_CODE
	 ,EMH_PAYROLL_CLEAR_ACC_CODE
	 ,EMH_DR_CLEAR_ACC_CODE
	 ,EMH_SUI_STATE
	 ,EMH_USER
	 ,EMH_LAST_UPD_DATE
	 ,EMH_STATUS
	 ,EMH_TD1_EXEMP_AMT
	 ,EMH_PENSION_FLAG
	 ,EMH_LOGIN_USER
	 ,EMH_DEF_COMP_FLAG
	 ,EMH_EI_CODE
	 ,EMH_YEAR_WORKING_DAYS
	 ,EMH_YEAR_WORKING_HOURS
	 ,EMH_STATE_FILING_STATUS
	 ,EMH_CITY_FILING_STATUS
	 ,EMH_LEV_ACRU_GL_ACC_CODE
	 ,EMH_LEV_CLEAR_ACC_CODE
	 ,EMH_TD1_PROV_EXEMP_AMT
	 ,EMH_TD1_EXEMP_FLAG
	 ,EMH_PH_ADDRESS1
	 ,EMH_PH_ADDRESS2
	 ,EMH_PH_ADDRESS3
	 ,EMH_PH_ZIP_CODE
	 ,EMH_DISABILITY_DIS_CODE
	 ,EMH_LANGUAGE_LANG_NAME
	 ,EMH_WORK_PHONE
	 ,EMH_WORK_FAX
	 ,EMH_CELL_PHONE
	 ,EMH_PAGER
	 ,EMH_EMAIL_ADDRESS
	 ,EMH_DOMINANT_HAND
	 ,EMH_COMMENT
	 ,EMH_MILITARY_STATUS
	 ,EMH_NEXT_REVIEW_DATE
	 ,EMH_SERVICE_YEARS
	 ,EMH_WRL_FLAG
	 ,EMH_TRAVEL_FLAG
	 ,EMH_TRAVEL_DISTANCE
	 ,EMH_POS_CODE
	 ,EMH_SUB_STATUS_CODE
	 ,EMH_HOME_COMP_CODE
	 ,EMH_HOME_DEPT_CODE
	 ,EMH_USER_ENTERED_OT
	 ,EMH_USER_ENTERED_DT
	 ,EMH_SENIORITY_DATE
	 ,EMH_EXP_APRV_GRP_CODE
	 ,EMH_CALC_ACCRUED_LEAVE
	 ,EMH_CALC_PREF
     ,EMH_TSH_CODE        -- Used only by ADP employee import
        ,EMH_INCL_CERT_PY_REP_FLAG   
	,EMH_LEAVE_CALC_PREF
	,EMH_REHIRE_ELIGIBLE
	,EMH_CKLOC_CODE			-- 138
	,EMH_AUTOGENERATE_TIMESHEET	-- 139
	--,EMH_DISPATCH_FLAG		--140
	--,EMH_FULL_PART_TIME		--141
--	 ,EMH_MANUAL_ACTIVATE
) values
	( row_dc.EMP_NO                                 --1
        ,da.pyemphist_seq.NEXTVAL               --2
        ,'NR'                                   --3
        ,row_dc.EMP_HIRE_DATE                          --4
        ,'' -- EMH_TXT_TYPE                     --5
        ,'' -- EMH_TXT_CODE                     --6
        ,row_dc.EMP_FIRST_NAME
        ,row_dc.EMP_MIDDLE_NAME
        ,row_dc.EMP_LAST_NAME
        ,row_dc.EMP_PREFIX_NAME
        ,row_dc.EMP_SUFFIX_NAME
        ,row_dc.EMP_NICK_NAME
        ,row_dc.EMP_SIN_NO
        ,row_dc.EMP_TYPE
        ,row_dc.EMP_UNIONIZED
        ,row_dc.EMP_JOB_TITLE
        ,row_dc.EMP_ADDRESS1
        ,row_dc.EMP_ADDRESS2
        ,row_dc.EMP_ADDRESS3
        ,row_dc.EMP_ZIP_CODE
        ,row_dc.EMP_PHONE
        ,row_dc.EMP_FAX
        ,row_dc.EMP_RES_LOC
        ,row_dc.EMP_COUNTRY_CODE
        ,row_dc.EMP_STATE_CODE
        ,row_dc.EMP_COUNTY_CODE
        ,row_dc.EMP_CITY_CODE
        ,row_dc.EMP_VERTEX_GEOCODE
        ,row_dc.EMP_VERTEX_SCHDIST
        ,row_dc.EMP_FILING_STATUS
        ,row_dc.EMP_NR_CERTIFICATE
        ,row_dc.EMP_PRIM_EXEMP
        ,row_dc.EMP_SECN_EXEMP
        ,row_dc.EMP_TERT_EXEMP
        ,row_dc.EMP_PRIM_EXEMP_AMT
        ,row_dc.EMP_SUPL_EXEMP_AMT
        ,row_dc.EMP_COMP_CODE
        ,row_dc.EMP_DEPT_CODE
        ,row_dc.EMP_WRL_CODE
        ,row_dc.EMP_JOB_CODE
        ,row_dc.EMP_PHS_CODE
        ,row_dc.EMP_CAT_CODE
        ,row_dc.EMP_EQUIPMENT_NO
        ,row_dc.EMP_EQUIP_TRAN_CODE
        ,row_dc.EMP_EQUIP_CATEGORY
        ,row_dc.EMP_UNI_CODE
        ,row_dc.EMP_UNION_MEM_NO
        ,row_dc.EMP_MEMBERSHIP_DATE
        ,row_dc.EMP_TRD_CODE
        ,row_dc.EMP_PYG_CODE
        ,row_dc.EMP_HIRE_DATE
        ,row_dc.EMP_RE_HIRE_DATE
        ,row_dc.EMP_TERMINATION_DATE
        ,row_dc.EMP_DATE_DECEASED
        ,row_dc.EMP_DATE_OF_BIRTH
        ,row_dc.EMP_PLACE_OF_BIRTH
        ,row_dc.EMP_GRD_CODE
        ,row_dc.EMP_ETHNIC_CODE
        ,row_dc.EMP_SEX
        ,row_dc.EMP_MARITAL_STATUS
        ,row_dc.EMP_RESIDENT_STATUS
        ,row_dc.EMP_OT_ELIGIBILITY
        ,row_dc.EMP_PAYMENT_MODE
        ,row_dc.EMP_BANK_CODE
        ,row_dc.EMP_BRANCH_CODE
        ,row_dc.EMP_BANK_AC_NO
        ,row_dc.EMP_LAST_INCR_DATE
        ,row_dc.EMP_LAST_PROM_DATE
        ,row_dc.EMP_LAST_TRAN_DATE
        ,row_dc.EMP_ANNUAL_SALARY
        ,row_dc.EMP_HOURLY_RATE
        ,row_dc.EMP_CHARGE_OUT_RATE
        ,row_dc.EMP_BILLING_RATE
        ,row_dc.EMP_PRN_CODE
        ,row_dc.EMP_WCB_CODE
        ,row_dc.EMP_WCB_BY_JOB
        ,row_dc.EMP_PL_CODE
        ,row_dc.EMP_PL_BY_JOB
        ,row_dc.EMP_PREFER_PAY_RATE
        ,row_dc.EMP_PREFER_CHARGE_RATE
        ,row_dc.EMP_PREFER_BILL_RATE
        ,row_dc.EMP_RATE_CODE
        ,row_dc.EMP_OT_RATE_CODE
        ,row_dc.EMP_DOT_RATE_CODE
        ,row_dc.EMP_OTH_RATE_CODE
        ,row_dc.EMP_GL_ACC_CODE
        ,row_dc.EMP_PAYROLL_CLEAR_ACC_CODE
        ,row_dc.EMP_DR_CLEAR_ACC_CODE
        ,row_dc.EMP_SUI_STATE
        ,'DA'
        ,SYSDATE
        ,row_dc.EMP_STATUS
        ,row_dc.EMP_TD1_EXEMP_AMT
        ,row_dc.EMP_PENSION_FLAG
        ,row_dc.EMP_LOGIN_USER
        ,row_dc.EMP_DEF_COMP_FLAG
        ,row_dc.EMP_EI_CODE
        ,row_dc.EMP_YEAR_WORKING_DAYS
        ,row_dc.EMP_YEAR_WORKING_HOURS
        ,row_dc.EMP_STATE_FILING_STATUS
        ,row_dc.EMP_CITY_FILING_STATUS
        ,row_dc.EMP_LEV_ACRU_GL_ACC_CODE
        ,row_dc.EMP_LEV_CLEAR_ACC_CODE
        ,row_dc.EMP_TD1_PROV_EXEMP_AMT
        ,row_dc.EMP_TD1_EXEMP_FLAG
        ,row_dc.EMP_PH_ADDRESS1
        ,row_dc.EMP_PH_ADDRESS2
        ,row_dc.EMP_PH_ADDRESS3
        ,row_dc.EMP_PH_ZIP_CODE
        ,row_dc.DISABILITY_DIS_CODE
        ,row_dc.LANGUAGE_LANG_NAME
        ,row_dc.EMP_WORK_PHONE
        ,row_dc.EMP_WORK_FAX
        ,row_dc.EMP_CELL_PHONE
        ,row_dc.EMP_PAGER
        ,row_dc.EMP_EMAIL_ADDRESS
        ,row_dc.EMP_DOMINANT_HAND
        ,row_dc.EMP_COMMENT
        ,row_dc.EMP_MILITARY_STATUS
        ,row_dc.EMP_NEXT_REVIEW_DATE
        ,row_dc.EMP_SERVICE_YEARS
        ,row_dc.EMP_WRL_FLAG
        ,row_dc.EMP_TRAVEL_FLAG
        ,row_dc.EMP_TRAVEL_DISTANCE
        ,row_dc.EMP_POS_CODE
        ,row_dc.EMP_SUB_STATUS
        ,row_dc.EMP_HOME_COMP_CODE
        ,row_dc.EMP_HOME_DEPT_CODE
        ,row_dc.EMP_USER_ENTERED_OT
        ,row_dc.EMP_USER_ENTERED_DT
        ,row_dc.EMP_SENIORITY_DATE
        ,row_dc.EMP_EXP_APRV_GRP_CODE
        ,row_dc.EMP_CALC_ACCRUED_LEAVE
        ,row_dc.EMP_CALC_PREF
        ,row_dc.EMP_TSH_CODE        -- Used only by ADP employee import
        ,row_dc.EMP_INCL_CERT_PY_REP_FLAG  
	,row_dc.EMP_LEAVE_CALC_PREF
	,row_dc.EMP_REHIRE_ELIGIBLE		--137
	,row_dc.EMP_CKLOC_CODE			-- 138
	,row_dc.EMP_AUTOGENERATE_TIMESHEET	-- 139
	--,row_dc.EMP_DISPATCH_FLAG		--140
	--,row_dc.EMP_FULL_PART_TIME		--141 
);

	end loop;
	-- end of loop insert

--        ,EMP_MANUAL_ACTIVATE
--    FROM da.dc_pyemployee_table;
	-- WHERE NVL(dc_valid_flag,'N') <> 'N';

---create terminated records in PYEMPHIST
	for row_dc in cInsertTM
	loop
      INSERT INTO da.PYEMPHIST
	(EMH_EMP_NO                             --1
	,EMH_SEQ_NO                             --2
	,EMH_ACTION_CODE                        --3
	,EMH_EFFECTIVE_DATE                     --4
        ,EMH_TXT_TYPE                           --5
        ,EMH_TXT_CODE                           --6
	 ,EMH_FIRST_NAME
	 ,EMH_MIDDLE_NAME
	 ,EMH_LAST_NAME
	 ,EMH_PREFIX_NAME
	 ,EMH_SUFFIX_NAME
	 ,EMH_NICK_NAME
	 ,EMH_SIN_NO
	 ,EMH_EMP_TYPE
	 ,EMH_EMP_UNIONIZED
	 ,EMH_JOB_TITLE
	 ,EMH_ADDRESS1
	 ,EMH_ADDRESS2
	 ,EMH_ADDRESS3
	 ,EMH_ZIP_CODE
	 ,EMH_PHONE
	 ,EMH_FAX
	 ,EMH_RES_LOC
	 ,EMH_EMP_COUNTRY_CODE
	 ,EMH_EMP_STATE_CODE
	 ,EMH_COUNTY_CODE
	 ,EMH_CITY_CODE
	 ,EMH_VERTEX_GEOCODE
	 ,EMH_VERTEX_SCHDIST
	 ,EMH_FILING_STATUS
	 ,EMH_NR_CERTIFICATE
	 ,EMH_PRIM_EXEMP
	 ,EMH_SECN_EXEMP
	 ,EMH_TERT_EXEMP
	 ,EMH_PRIM_EXEMP_AMT
	 ,EMH_SUPL_EXEMP_AMT
	 ,EMH_COMP_CODE
	 ,EMH_DEPARTMENT_CODE
	 ,EMH_WORK_LOCATION
	 ,EMH_JOB_CODE
	 ,EMH_PHS_CODE
	 ,EMH_CAT_CODE
	 ,EMH_EQUIPMENT_NO
	 ,EMH_EQUIP_TRAN_CODE
	 ,EMH_EQUIP_CATEGORY
	 ,EMH_UNION_CODE
	 ,EMH_UNION_MEM_NO
	 ,EMH_MEMBERSHIP_DATE
	 ,EMH_TRADE_CODE
	 ,EMH_PAY_GROUP
	 ,EMH_HIRE_DATE
	 ,EMH_RE_HIRE_DATE
	 ,EMH_TERMINATION_DATE
	 ,EMH_DATE_DECEASED
	 ,EMH_DATE_OF_BIRTH
	 ,EMH_PLACE_OF_BIRTH
	 ,EMH_GRD_CODE
	 ,EMH_ETHNIC_CODE
	 ,EMH_SEX
	 ,EMH_MARITAL_STATUS
	 ,EMH_RESIDENT_STATUS
	 ,EMH_OT_ELIGIBILITY
	 ,EMH_PAYMENT_MODE
	 ,EMH_BANK_CODE
	 ,EMH_BRANCH_CODE
	 ,EMH_BANK_AC_NO
	 ,EMH_LAST_INCR_DATE
	 ,EMH_LAST_PROM_DATE
	 ,EMH_LAST_TRAN_DATE
	 ,EMH_ANNUAL_SALARY
	 ,EMH_HOUR_RATE
	 ,EMH_CHARGE_RATE
	 ,EMH_BILLING_RATE
	 ,EMH_PRN_CODE
	 ,EMH_WCB_CODE
	 ,EMH_WCB_BY_JOB
	 ,EMH_PL_CODE
	 ,EMH_PL_BY_JOB
	 ,EMH_PREFER_PAY_RATE
	 ,EMH_PREFER_CHARGE_RATE
	 ,EMH_PREFER_BILL_RATE
	 ,EMH_RATE_CODE
	 ,EMH_OT_RATE_CODE
	 ,EMH_DOT_RATE_CODE
	 ,EMH_OTH_RATE_CODE
	 ,EMH_GL_ACC_CODE
	 ,EMH_PAYROLL_CLEAR_ACC_CODE
	 ,EMH_DR_CLEAR_ACC_CODE
	 ,EMH_SUI_STATE
	 ,EMH_USER
	 ,EMH_LAST_UPD_DATE
	 ,EMH_STATUS
	 ,EMH_TD1_EXEMP_AMT
	 ,EMH_PENSION_FLAG
	 ,EMH_LOGIN_USER
	 ,EMH_DEF_COMP_FLAG
	 ,EMH_EI_CODE
	 ,EMH_YEAR_WORKING_DAYS
	 ,EMH_YEAR_WORKING_HOURS
	 ,EMH_STATE_FILING_STATUS
	 ,EMH_CITY_FILING_STATUS
	 ,EMH_LEV_ACRU_GL_ACC_CODE
	 ,EMH_LEV_CLEAR_ACC_CODE
	 ,EMH_TD1_PROV_EXEMP_AMT
	 ,EMH_TD1_EXEMP_FLAG
	 ,EMH_PH_ADDRESS1
	 ,EMH_PH_ADDRESS2
	 ,EMH_PH_ADDRESS3
	 ,EMH_PH_ZIP_CODE
	 ,EMH_DISABILITY_DIS_CODE
	 ,EMH_LANGUAGE_LANG_NAME
	 ,EMH_WORK_PHONE
	 ,EMH_WORK_FAX
	 ,EMH_CELL_PHONE
	 ,EMH_PAGER
	 ,EMH_EMAIL_ADDRESS
	 ,EMH_DOMINANT_HAND
	 ,EMH_COMMENT
	 ,EMH_MILITARY_STATUS
	 ,EMH_NEXT_REVIEW_DATE
	 ,EMH_SERVICE_YEARS
	 ,EMH_WRL_FLAG
	 ,EMH_TRAVEL_FLAG
	 ,EMH_TRAVEL_DISTANCE
	 ,EMH_POS_CODE
	 ,EMH_SUB_STATUS_CODE
	 ,EMH_HOME_COMP_CODE
	 ,EMH_HOME_DEPT_CODE
	 ,EMH_USER_ENTERED_OT
	 ,EMH_USER_ENTERED_DT
	 ,EMH_SENIORITY_DATE
	 ,EMH_EXP_APRV_GRP_CODE
	 ,EMH_CALC_ACCRUED_LEAVE
	 ,EMH_CALC_PREF
         ,EMH_INCL_CERT_PY_REP_FLAG   
	 ,EMH_LEAVE_CALC_PREF
	 ,EMH_REHIRE_ELIGIBLE
	,EMH_CKLOC_CODE			-- 138
	,EMH_AUTOGENERATE_TIMESHEET	-- 139
	--,EMH_DISPATCH_FLAG		--140
	--,EMH_FULL_PART_TIME		--141
--	 ,EMH_MANUAL_ACTIVATE
) values 
	(row_dc.EMP_NO                                 --1
        ,da.pyemphist_seq.NEXTVAL               --2
        ,'TM'                                   --3 TM is action_code for termination
        ,row_dc.EMP_HIRE_DATE                          --4
        ,'' -- EMH_TXT_TYPE                     --5
        ,'' -- EMH_TXT_CODE                     --6
        ,row_dc.EMP_FIRST_NAME
        ,row_dc.EMP_MIDDLE_NAME
        ,row_dc.EMP_LAST_NAME
        ,row_dc.EMP_PREFIX_NAME
        ,row_dc.EMP_SUFFIX_NAME
        ,row_dc.EMP_NICK_NAME
        ,row_dc.EMP_SIN_NO
        ,row_dc.EMP_TYPE
        ,row_dc.EMP_UNIONIZED
        ,row_dc.EMP_JOB_TITLE
        ,row_dc.EMP_ADDRESS1
        ,row_dc.EMP_ADDRESS2
        ,row_dc.EMP_ADDRESS3
        ,row_dc.EMP_ZIP_CODE
        ,row_dc.EMP_PHONE
        ,row_dc.EMP_FAX
        ,row_dc.EMP_RES_LOC
        ,row_dc.EMP_COUNTRY_CODE
        ,row_dc.EMP_STATE_CODE
        ,row_dc.EMP_COUNTY_CODE
        ,row_dc.EMP_CITY_CODE
        ,row_dc.EMP_VERTEX_GEOCODE
        ,row_dc.EMP_VERTEX_SCHDIST
        ,row_dc.EMP_FILING_STATUS
        ,row_dc.EMP_NR_CERTIFICATE
        ,row_dc.EMP_PRIM_EXEMP
        ,row_dc.EMP_SECN_EXEMP
        ,row_dc.EMP_TERT_EXEMP
        ,row_dc.EMP_PRIM_EXEMP_AMT
        ,row_dc.EMP_SUPL_EXEMP_AMT
        ,row_dc.EMP_COMP_CODE
        ,row_dc.EMP_DEPT_CODE
        ,row_dc.EMP_WRL_CODE
        ,row_dc.EMP_JOB_CODE
        ,row_dc.EMP_PHS_CODE
        ,row_dc.EMP_CAT_CODE
        ,row_dc.EMP_EQUIPMENT_NO
        ,row_dc.EMP_EQUIP_TRAN_CODE
        ,row_dc.EMP_EQUIP_CATEGORY
        ,row_dc.EMP_UNI_CODE
        ,row_dc.EMP_UNION_MEM_NO
        ,row_dc.EMP_MEMBERSHIP_DATE
        ,row_dc.EMP_TRD_CODE
        ,row_dc.EMP_PYG_CODE
        ,row_dc.EMP_HIRE_DATE
        ,row_dc.EMP_RE_HIRE_DATE
        ,row_dc.EMP_TERMINATION_DATE
        ,row_dc.EMP_DATE_DECEASED
        ,row_dc.EMP_DATE_OF_BIRTH
        ,row_dc.EMP_PLACE_OF_BIRTH
        ,row_dc.EMP_GRD_CODE
        ,row_dc.EMP_ETHNIC_CODE
        ,row_dc.EMP_SEX
        ,row_dc.EMP_MARITAL_STATUS
        ,row_dc.EMP_RESIDENT_STATUS
        ,row_dc.EMP_OT_ELIGIBILITY
        ,row_dc.EMP_PAYMENT_MODE
        ,row_dc.EMP_BANK_CODE
        ,row_dc.EMP_BRANCH_CODE
        ,row_dc.EMP_BANK_AC_NO
        ,row_dc.EMP_LAST_INCR_DATE
        ,row_dc.EMP_LAST_PROM_DATE
        ,row_dc.EMP_LAST_TRAN_DATE
        ,row_dc.EMP_ANNUAL_SALARY
        ,row_dc.EMP_HOURLY_RATE
        ,row_dc.EMP_CHARGE_OUT_RATE
        ,row_dc.EMP_BILLING_RATE
        ,row_dc.EMP_PRN_CODE
        ,row_dc.EMP_WCB_CODE
        ,row_dc.EMP_WCB_BY_JOB
        ,row_dc.EMP_PL_CODE
        ,row_dc.EMP_PL_BY_JOB
        ,row_dc.EMP_PREFER_PAY_RATE
        ,row_dc.EMP_PREFER_CHARGE_RATE
        ,row_dc.EMP_PREFER_BILL_RATE
        ,row_dc.EMP_RATE_CODE
        ,row_dc.EMP_OT_RATE_CODE
        ,row_dc.EMP_DOT_RATE_CODE
        ,row_dc.EMP_OTH_RATE_CODE
        ,row_dc.EMP_GL_ACC_CODE
        ,row_dc.EMP_PAYROLL_CLEAR_ACC_CODE
        ,row_dc.EMP_DR_CLEAR_ACC_CODE
        ,row_dc.EMP_SUI_STATE
        ,'DA'
        ,SYSDATE
        ,row_dc.EMP_STATUS
        ,row_dc.EMP_TD1_EXEMP_AMT
        ,row_dc.EMP_PENSION_FLAG
        ,row_dc.EMP_LOGIN_USER
        ,row_dc.EMP_DEF_COMP_FLAG
        ,row_dc.EMP_EI_CODE
        ,row_dc.EMP_YEAR_WORKING_DAYS
        ,row_dc.EMP_YEAR_WORKING_HOURS
        ,row_dc.EMP_STATE_FILING_STATUS
        ,row_dc.EMP_CITY_FILING_STATUS
        ,row_dc.EMP_LEV_ACRU_GL_ACC_CODE
        ,row_dc.EMP_LEV_CLEAR_ACC_CODE
        ,row_dc.EMP_TD1_PROV_EXEMP_AMT
        ,row_dc.EMP_TD1_EXEMP_FLAG
        ,row_dc.EMP_PH_ADDRESS1
        ,row_dc.EMP_PH_ADDRESS2
        ,row_dc.EMP_PH_ADDRESS3
        ,row_dc.EMP_PH_ZIP_CODE
        ,row_dc.DISABILITY_DIS_CODE
        ,row_dc.LANGUAGE_LANG_NAME
        ,row_dc.EMP_WORK_PHONE
        ,row_dc.EMP_WORK_FAX
        ,row_dc.EMP_CELL_PHONE
        ,row_dc.EMP_PAGER
        ,row_dc.EMP_EMAIL_ADDRESS
        ,row_dc.EMP_DOMINANT_HAND
        ,row_dc.EMP_COMMENT
        ,row_dc.EMP_MILITARY_STATUS
        ,row_dc.EMP_NEXT_REVIEW_DATE
        ,row_dc.EMP_SERVICE_YEARS
        ,row_dc.EMP_WRL_FLAG
        ,row_dc.EMP_TRAVEL_FLAG
        ,row_dc.EMP_TRAVEL_DISTANCE
        ,row_dc.EMP_POS_CODE
        ,row_dc.EMP_SUB_STATUS
        ,row_dc.EMP_HOME_COMP_CODE
        ,row_dc.EMP_HOME_DEPT_CODE
        ,row_dc.EMP_USER_ENTERED_OT
        ,row_dc.EMP_USER_ENTERED_DT
        ,row_dc.EMP_SENIORITY_DATE
        ,row_dc.EMP_EXP_APRV_GRP_CODE
        ,row_dc.EMP_CALC_ACCRUED_LEAVE
        ,row_dc.EMP_CALC_PREF
        ,row_dc.EMP_INCL_CERT_PY_REP_FLAG  
	,row_dc.EMP_LEAVE_CALC_PREF
	,row_dc.EMP_REHIRE_ELIGIBLE		--137
	,row_dc.EMP_CKLOC_CODE			-- 138
	,row_dc.EMP_AUTOGENERATE_TIMESHEET	-- 139
	--,row_dc.EMP_DISPATCH_FLAG		--140
	--,row_dc.EMP_FULL_PART_TIME		--141
);

	end loop;
	-- end of loop insert

--        ,EMP_MANUAL_ACTIVATE
--    FROM da.dc_pyemployee_table
--     WHERE emp_termination_date IS NOT NULL;
	   -- AND NVL(dc_valid_flag,'N') <> 'N';


---create re-hire records in PYEMPHIST
	for row_dc in cInsertRR
	loop
      INSERT INTO da.PYEMPHIST
	(EMH_EMP_NO                             --1
	,EMH_SEQ_NO                             --2
	,EMH_ACTION_CODE                        --3
	,EMH_EFFECTIVE_DATE                     --4
        ,EMH_TXT_TYPE                           --5
        ,EMH_TXT_CODE                           --6
	 ,EMH_FIRST_NAME
	 ,EMH_MIDDLE_NAME
	 ,EMH_LAST_NAME
	 ,EMH_PREFIX_NAME
	 ,EMH_SUFFIX_NAME
	 ,EMH_NICK_NAME
	 ,EMH_SIN_NO
	 ,EMH_EMP_TYPE
	 ,EMH_EMP_UNIONIZED
	 ,EMH_JOB_TITLE
	 ,EMH_ADDRESS1
	 ,EMH_ADDRESS2
	 ,EMH_ADDRESS3
	 ,EMH_ZIP_CODE
	 ,EMH_PHONE
	 ,EMH_FAX
	 ,EMH_RES_LOC
	 ,EMH_EMP_COUNTRY_CODE
	 ,EMH_EMP_STATE_CODE
	 ,EMH_COUNTY_CODE
	 ,EMH_CITY_CODE
	 ,EMH_VERTEX_GEOCODE
	 ,EMH_VERTEX_SCHDIST
	 ,EMH_FILING_STATUS
	 ,EMH_NR_CERTIFICATE
	 ,EMH_PRIM_EXEMP
	 ,EMH_SECN_EXEMP
	 ,EMH_TERT_EXEMP
	 ,EMH_PRIM_EXEMP_AMT
	 ,EMH_SUPL_EXEMP_AMT
	 ,EMH_COMP_CODE
	 ,EMH_DEPARTMENT_CODE
	 ,EMH_WORK_LOCATION
	 ,EMH_JOB_CODE
	 ,EMH_PHS_CODE
	 ,EMH_CAT_CODE
	 ,EMH_EQUIPMENT_NO
	 ,EMH_EQUIP_TRAN_CODE
	 ,EMH_EQUIP_CATEGORY
	 ,EMH_UNION_CODE
	 ,EMH_UNION_MEM_NO
	 ,EMH_MEMBERSHIP_DATE
	 ,EMH_TRADE_CODE
	 ,EMH_PAY_GROUP
	 ,EMH_HIRE_DATE
	 ,EMH_RE_HIRE_DATE
	 ,EMH_TERMINATION_DATE
	 ,EMH_DATE_DECEASED
	 ,EMH_DATE_OF_BIRTH
	 ,EMH_PLACE_OF_BIRTH
	 ,EMH_GRD_CODE
	 ,EMH_ETHNIC_CODE
	 ,EMH_SEX
	 ,EMH_MARITAL_STATUS
	 ,EMH_RESIDENT_STATUS
	 ,EMH_OT_ELIGIBILITY
	 ,EMH_PAYMENT_MODE
	 ,EMH_BANK_CODE
	 ,EMH_BRANCH_CODE
	 ,EMH_BANK_AC_NO
	 ,EMH_LAST_INCR_DATE
	 ,EMH_LAST_PROM_DATE
	 ,EMH_LAST_TRAN_DATE
	 ,EMH_ANNUAL_SALARY
	 ,EMH_HOUR_RATE
	 ,EMH_CHARGE_RATE
	 ,EMH_BILLING_RATE
	 ,EMH_PRN_CODE
	 ,EMH_WCB_CODE
	 ,EMH_WCB_BY_JOB
	 ,EMH_PL_CODE
	 ,EMH_PL_BY_JOB
	 ,EMH_PREFER_PAY_RATE
	 ,EMH_PREFER_CHARGE_RATE
	 ,EMH_PREFER_BILL_RATE
	 ,EMH_RATE_CODE
	 ,EMH_OT_RATE_CODE
	 ,EMH_DOT_RATE_CODE
	 ,EMH_OTH_RATE_CODE
	 ,EMH_GL_ACC_CODE
	 ,EMH_PAYROLL_CLEAR_ACC_CODE
	 ,EMH_DR_CLEAR_ACC_CODE
	 ,EMH_SUI_STATE
	 ,EMH_USER
	 ,EMH_LAST_UPD_DATE
	 ,EMH_STATUS
	 ,EMH_TD1_EXEMP_AMT
	 ,EMH_PENSION_FLAG
	 ,EMH_LOGIN_USER
	 ,EMH_DEF_COMP_FLAG
	 ,EMH_EI_CODE
	 ,EMH_YEAR_WORKING_DAYS
	 ,EMH_YEAR_WORKING_HOURS
	 ,EMH_STATE_FILING_STATUS
	 ,EMH_CITY_FILING_STATUS
	 ,EMH_LEV_ACRU_GL_ACC_CODE
	 ,EMH_LEV_CLEAR_ACC_CODE
	 ,EMH_TD1_PROV_EXEMP_AMT
	 ,EMH_TD1_EXEMP_FLAG
	 ,EMH_PH_ADDRESS1
	 ,EMH_PH_ADDRESS2
	 ,EMH_PH_ADDRESS3
	 ,EMH_PH_ZIP_CODE
	 ,EMH_DISABILITY_DIS_CODE
	 ,EMH_LANGUAGE_LANG_NAME
	 ,EMH_WORK_PHONE
	 ,EMH_WORK_FAX
	 ,EMH_CELL_PHONE
	 ,EMH_PAGER
	 ,EMH_EMAIL_ADDRESS
	 ,EMH_DOMINANT_HAND
	 ,EMH_COMMENT
	 ,EMH_MILITARY_STATUS
	 ,EMH_NEXT_REVIEW_DATE
	 ,EMH_SERVICE_YEARS
	 ,EMH_WRL_FLAG
	 ,EMH_TRAVEL_FLAG
	 ,EMH_TRAVEL_DISTANCE
	 ,EMH_POS_CODE
	 ,EMH_SUB_STATUS_CODE
	 ,EMH_HOME_COMP_CODE
	 ,EMH_HOME_DEPT_CODE
	 ,EMH_USER_ENTERED_OT
	 ,EMH_USER_ENTERED_DT
	 ,EMH_SENIORITY_DATE
	 ,EMH_EXP_APRV_GRP_CODE
	 ,EMH_CALC_ACCRUED_LEAVE
	 ,EMH_CALC_PREF
         ,EMH_TSH_CODE        -- Used only by ADP employee import
         ,EMH_INCL_CERT_PY_REP_FLAG 
	 ,EMH_LEAVE_CALC_PREF
	 ,EMH_REHIRE_ELIGIBLE
	,EMH_CKLOC_CODE			-- 138
	,EMH_AUTOGENERATE_TIMESHEET	-- 139
	--,EMH_DISPATCH_FLAG		--140
	--,EMH_FULL_PART_TIME		--141
--	 ,EMH_MANUAL_ACTIVATE
) values
	(row_dc.EMP_NO                                 --1
        ,da.pyemphist_seq.NEXTVAL               --2
        ,'RR'                                   --3 RR is action_code for re-hired
        ,row_dc.EMP_HIRE_DATE                          --4
        ,'' -- EMH_TXT_TYPE                     --5
        ,'' -- EMH_TXT_CODE                     --6
        ,row_dc.EMP_FIRST_NAME
        ,row_dc.EMP_MIDDLE_NAME
        ,row_dc.EMP_LAST_NAME
        ,row_dc.EMP_PREFIX_NAME
        ,row_dc.EMP_SUFFIX_NAME
        ,row_dc.EMP_NICK_NAME
        ,row_dc.EMP_SIN_NO
        ,row_dc.EMP_TYPE
        ,row_dc.EMP_UNIONIZED
        ,row_dc.EMP_JOB_TITLE
        ,row_dc.EMP_ADDRESS1
        ,row_dc.EMP_ADDRESS2
        ,row_dc.EMP_ADDRESS3
        ,row_dc.EMP_ZIP_CODE
        ,row_dc.EMP_PHONE
        ,row_dc.EMP_FAX
        ,row_dc.EMP_RES_LOC
        ,row_dc.EMP_COUNTRY_CODE
        ,row_dc.EMP_STATE_CODE
        ,row_dc.EMP_COUNTY_CODE
        ,row_dc.EMP_CITY_CODE
        ,row_dc.EMP_VERTEX_GEOCODE
        ,row_dc.EMP_VERTEX_SCHDIST
        ,row_dc.EMP_FILING_STATUS
        ,row_dc.EMP_NR_CERTIFICATE
        ,row_dc.EMP_PRIM_EXEMP
        ,row_dc.EMP_SECN_EXEMP
        ,row_dc.EMP_TERT_EXEMP
        ,row_dc.EMP_PRIM_EXEMP_AMT
        ,row_dc.EMP_SUPL_EXEMP_AMT
        ,row_dc.EMP_COMP_CODE
        ,row_dc.EMP_DEPT_CODE
        ,row_dc.EMP_WRL_CODE
        ,row_dc.EMP_JOB_CODE
        ,row_dc.EMP_PHS_CODE
        ,row_dc.EMP_CAT_CODE
        ,row_dc.EMP_EQUIPMENT_NO
        ,row_dc.EMP_EQUIP_TRAN_CODE
        ,row_dc.EMP_EQUIP_CATEGORY
        ,row_dc.EMP_UNI_CODE
        ,row_dc.EMP_UNION_MEM_NO
        ,row_dc.EMP_MEMBERSHIP_DATE
        ,row_dc.EMP_TRD_CODE
        ,row_dc.EMP_PYG_CODE
        ,row_dc.EMP_HIRE_DATE
        ,row_dc.EMP_RE_HIRE_DATE
        ,row_dc.EMP_TERMINATION_DATE
        ,row_dc.EMP_DATE_DECEASED
        ,row_dc.EMP_DATE_OF_BIRTH
        ,row_dc.EMP_PLACE_OF_BIRTH
        ,row_dc.EMP_GRD_CODE
        ,row_dc.EMP_ETHNIC_CODE
        ,row_dc.EMP_SEX
        ,row_dc.EMP_MARITAL_STATUS
        ,row_dc.EMP_RESIDENT_STATUS
        ,row_dc.EMP_OT_ELIGIBILITY
        ,row_dc.EMP_PAYMENT_MODE
        ,row_dc.EMP_BANK_CODE
        ,row_dc.EMP_BRANCH_CODE
        ,row_dc.EMP_BANK_AC_NO
        ,row_dc.EMP_LAST_INCR_DATE
        ,row_dc.EMP_LAST_PROM_DATE
        ,row_dc.EMP_LAST_TRAN_DATE
        ,row_dc.EMP_ANNUAL_SALARY
        ,row_dc.EMP_HOURLY_RATE
        ,row_dc.EMP_CHARGE_OUT_RATE
        ,row_dc.EMP_BILLING_RATE
        ,row_dc.EMP_PRN_CODE
        ,row_dc.EMP_WCB_CODE
        ,row_dc.EMP_WCB_BY_JOB
        ,row_dc.EMP_PL_CODE
        ,row_dc.EMP_PL_BY_JOB
        ,row_dc.EMP_PREFER_PAY_RATE
        ,row_dc.EMP_PREFER_CHARGE_RATE
        ,row_dc.EMP_PREFER_BILL_RATE
        ,row_dc.EMP_RATE_CODE
        ,row_dc.EMP_OT_RATE_CODE
        ,row_dc.EMP_DOT_RATE_CODE
        ,row_dc.EMP_OTH_RATE_CODE
        ,row_dc.EMP_GL_ACC_CODE
        ,row_dc.EMP_PAYROLL_CLEAR_ACC_CODE
        ,row_dc.EMP_DR_CLEAR_ACC_CODE
        ,row_dc.EMP_SUI_STATE
        ,'DA'
        ,SYSDATE
        ,row_dc.EMP_STATUS
        ,row_dc.EMP_TD1_EXEMP_AMT
        ,row_dc.EMP_PENSION_FLAG
        ,row_dc.EMP_LOGIN_USER
        ,row_dc.EMP_DEF_COMP_FLAG
        ,row_dc.EMP_EI_CODE
        ,row_dc.EMP_YEAR_WORKING_DAYS
        ,row_dc.EMP_YEAR_WORKING_HOURS
        ,row_dc.EMP_STATE_FILING_STATUS
        ,row_dc.EMP_CITY_FILING_STATUS
        ,row_dc.EMP_LEV_ACRU_GL_ACC_CODE
        ,row_dc.EMP_LEV_CLEAR_ACC_CODE
        ,row_dc.EMP_TD1_PROV_EXEMP_AMT
        ,row_dc.EMP_TD1_EXEMP_FLAG
        ,row_dc.EMP_PH_ADDRESS1
        ,row_dc.EMP_PH_ADDRESS2
        ,row_dc.EMP_PH_ADDRESS3
        ,row_dc.EMP_PH_ZIP_CODE
        ,row_dc.DISABILITY_DIS_CODE
        ,row_dc.LANGUAGE_LANG_NAME
        ,row_dc.EMP_WORK_PHONE
        ,row_dc.EMP_WORK_FAX
        ,row_dc.EMP_CELL_PHONE
        ,row_dc.EMP_PAGER
        ,row_dc.EMP_EMAIL_ADDRESS
        ,row_dc.EMP_DOMINANT_HAND
        ,row_dc.EMP_COMMENT
        ,row_dc.EMP_MILITARY_STATUS
        ,row_dc.EMP_NEXT_REVIEW_DATE
        ,row_dc.EMP_SERVICE_YEARS
        ,row_dc.EMP_WRL_FLAG
        ,row_dc.EMP_TRAVEL_FLAG
        ,row_dc.EMP_TRAVEL_DISTANCE
        ,row_dc.EMP_POS_CODE
        ,row_dc.EMP_SUB_STATUS
        ,row_dc.EMP_HOME_COMP_CODE
        ,row_dc.EMP_HOME_DEPT_CODE
        ,row_dc.EMP_USER_ENTERED_OT
        ,row_dc.EMP_USER_ENTERED_DT
        ,row_dc.EMP_SENIORITY_DATE
        ,row_dc.EMP_EXP_APRV_GRP_CODE
        ,row_dc.EMP_CALC_ACCRUED_LEAVE
        ,row_dc.EMP_CALC_PREF
        ,row_dc.EMP_TSH_CODE        -- Used only by ADP employee import
        ,row_dc.EMP_INCL_CERT_PY_REP_FLAG  
	,row_dc.EMP_LEAVE_CALC_PREF
	,row_dc.EMP_REHIRE_ELIGIBLE		--137
	,row_dc.EMP_CKLOC_CODE			-- 138
	,row_dc.EMP_AUTOGENERATE_TIMESHEET	-- 139
	--,row_dc.EMP_DISPATCH_FLAG		--140
	--,row_dc.EMP_FULL_PART_TIME		--141
);

	end loop;
	-- end of loop insert

--        ,EMP_MANUAL_ACTIVATE
--    FROM da.dc_pyemployee_table
--     WHERE EMP_RE_HIRE_DATE IS NOT NULL;
	   -- AND NVL(dc_valid_flag,'N') <> 'N';
	 
     --- create records in PYACCESSCODE and PYACCESSEMP table
     for t1 in (select UPPER(emp_login_user)  emp_login_user
                      ,EMP_FIRST_NAME
                      ,EMP_LAST_NAME
                      ,EMP_EMAIL_ADDRESS
                      ,emp_no
                  FROM da.dc_pyemployee_table
                 WHERE emp_login_user IS NOT NULL)
                 ---  AND NVL(dc_valid_flag,'N') = 'Y')
     loop
       --- Populate PYACCESSCODE if the code is not already there
       INSERT INTO DA.PYACCESSCODE
	( ACS_CODE
	, ACS_PW
        , acs_unaprv_email
	, ACS_LAST_UPDATE
	, ACS_PW_EXPIRE_DAYS
	)
	(SELECT
	  t1.emp_login_user
	, t1.emp_login_user
        , t1.EMP_EMAIL_ADDRESS
	, SYSDATE
	, 0
	FROM dual
	WHERE NOT EXISTS (SELECT 'x' FROM DA.PYACCESSCODE
	                 WHERE acs_code = t1.emp_login_user));

       -- For Turner the password must be at least 7 characters with at least one numeric.
       DBK_USER_MAINT.P_CREATE_LDAP_USER(t1.emp_login_user
                                       , rpad(t1.emp_login_user,6,'1') || '1'
                                       , t1.emp_first_name
                                       , t1.emp_last_name
                                       , t1.emp_email_address
                                       );

        --- Populate PYACCESSEMP with the employee number
        --- Mark this entry as a default employee if no other record has this flag set yet
        declare
           t_default_emp_flag      varchar2(1);
           cursor c1 is 
              select 'N'
                from da.pyaccessemp
               where ace_acs_code = t1.emp_login_user
                 and nvl(ace_dflt_emp_flag, 'N') = 'Y';
        begin
           t_default_emp_flag := 'Y';
           open c1;
           fetch c1 into t_default_emp_flag;
           close c1;
           insert into da.pyaccessemp
              ( ACE_ACS_CODE           
               ,ACE_EMP_NO
               ,ace_dflt_emp_flag)
             (select t1.emp_login_user 
                    ,t1.emp_no
                    ,t_default_emp_flag
                from dual
               where not exists (select 'p' from da.pyaccessemp
                                  where ace_acs_code = t1.emp_login_user
                                    and ace_emp_no = t1.emp_no));  
        end;
    end loop;
  --
  --delete everything from DA.DC_PYEMPLOYEE_TABLE
    display_status('Delete rows from DA.DC_PYEMPLOYEE_TABLE table.');
   DELETE FROM DA.DC_PYEMPLOYEE_TABLE; --  WHERE NVL(dc_valid_flag,'N') <> 'N';
    display_status('Number of records deleted from DA.DC_PYEMPLOYEE_TABLE table:'||TO_CHAR(SQL%rowcount));

     display_status('PYEMPLOYEE_TABLE moving from temp table was successful.');
     --COMMIT;

 END IF; /*    if nvl(t_num_errors_PYEMPLOYEE_TABLE,0) = 0 */

EXCEPTION WHEN OTHERS
     THEN
       display_status('Can not move data from DA.DC_PYEMPLOYEE_TABLE into DA.PYEMPLOYEE_TABLE.');
       da.Dbk_Dc.output(SQLERRM);
       ROLLBACK;
       RAISE;

END Process_temp_data ;

END Dbk_Dc_Pyemployee_Table;
/
show error
/
