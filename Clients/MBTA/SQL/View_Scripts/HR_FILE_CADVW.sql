CREATE OR REPLACE VIEW DA1.HR_FILE_CADVW (HFC_COMP_CODE, HFC_EMP_NO, HFC_PRN_CODE, HFC_START_DAT
                                        , HFC_END_DATE, HFC_DATA) 
AS 

SELECT CHK.PYC_COMP_CODE
     , CHK.PYC_EMP_NO
     , CHK.PYC_PRN_CODE
     , PPRD.PPR_START_DATE
     , PPRD.PPR_END_DATE
    --, CHK.PYC_YEAR
    --, CHK.PYC_PPR_PERIOD
        , CHK.PYC_EMP_NO
|| ',' || EMP.EMP_FIRST_NAME
|| ',' || EMP.EMP_MIDDLE_NAME
|| ',' || EMP.EMP_LAST_NAME
|| ',' || EMP.EMP_FIRST_NAME
|| ' ' || EMP.EMP_MIDDLE_NAME
|| ' ' || EMP.EMP_LAST_NAME
|| ',' || SUBSTR(EMP.EMP_SIN_NO,1,3) || '-' || SUBSTR(EMP.EMP_SIN_NO,4,2) || '-' || SUBSTR(EMP.EMP_SIN_NO,6,4)
|| ',' || EMP.EMP_ADDRESS1	
|| ',' || EMP.EMP_ADDRESS3	
|| ',' || EMP.EMP_STATE_CODE	
|| ',' || EMP.EMP_ZIP_CODE	
|| ',' || EMP.EMP_SEX	
|| ',' || EMP.EMP_ETHNIC_CODE	
|| ',' || EMP.EMP_JOB_TITLE	
|| ',' || EMP.EMP_STATUS	
|| ',' || EMP.EMP_WRL_CODE
|| ',' || 'DEPT CHANGE DATE'
|| ',' || TO_CHAR(EMP.EMP_HIRE_DATE, 'MM/DD/YYYY')	
|| ',' || TO_CHAR(EMP.EMP_TERMINATION_DATE, 'MM/DD/YYYY')
|| ',' || 'REHIRE DATE'
|| ',' || 'INCREASE DATE'
|| ',' || TO_CHAR(EMP.EMP_DATE_OF_BIRTH, 'MM/DD/YYYY')
|| ',' || EMP.EMP_TRD_CODE
|| ',' || 'REVIEW DATE'
|| ',' || EMP.EMP_PHONE
FROM     
     (
      SELECT PYC_EMP_NO
           , PYC_COMP_CODE 
           , PYC_PRN_CODE
           , PYC_YEAR
           , PYC_PPR_PERIOD
       FROM DA.PYCHECKS
       WHERE PYC_COMP_CODE NOT IN ('ZZ')
       GROUP BY PYC_EMP_NO, PYC_COMP_CODE , PYC_PRN_CODE
              , PYC_YEAR, PYC_PPR_PERIOD
     ) CHK
   , DA.PYCOMPAYPRD PPRD
   , DA.PYEMPLOYEE_TABLE EMP
WHERE CHK.PYC_COMP_CODE = PPRD.PPR_COMP_CODE
AND CHK.PYC_PRN_CODE    = PPRD.PPR_PRN_CODE
AND CHK.PYC_YEAR        = PPRD.PPR_YEAR
AND CHK.PYC_PPR_PERIOD  = PPRD.PPR_PERIOD
AND CHK.PYC_EMP_NO      = EMP.EMP_NO

select * from jcdetail where jcdt_bch_num >0

select min(jcdt_bch_num), max(jcdt_bch_num) from jcdetail   -- 31
where jcbch_comp_code not in ('ZZ')
and jcbch_num > 0

select min(scmst_post_batch), max(scmst_post_batch) from scmast    63

select * from scmast where scmst_post_batch = 112

select min(jcbch_num),max(jcbch_num) from jcbatch_table  -99992286866	10032

select * from all_tables where table_name like '%SEQ%'

select * from seqnum

select * from batch

select * from gledger where gl_bch_num = 10034

update da.seqnum set seq_num = 10033 where seq_num = 112

select * from PYEMPTIMSHT