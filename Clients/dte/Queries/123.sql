
SELECT  DISTINCT to_date('11-18-2007','mm-dd-yyyy') load_date,
    A.CAD_ACCOUNT_NUMBER ACCOUNT_NO, 
	MAX(B.CASA_SUPPLIER_ID) CHOICE_NOCHOICE, 
	SUM(B.CASA_THIRTY_BUCKET)  AMT_30, 
   SUM( B.CASA_SIXTY_BUCKET)  AMT_60, 
	SUM(B.CASA_NINETY_BUCKET) AMT_90, 
	SUM(B.CASA_OVER_NINETY_BUCKET) AMT_OVER_90, 
	A.CAD_METER_LOCATION MTR_LOC, 
    A.CAD_ENERGY_TYPE Gas_or_Both, 
	A.CAD_ACCOUNT_TYPE acct_type, 
	A.CAD_TOTAL_ENERGY_ARR    TOT_ENERGY_ARR, 
	A.CAD_ACCOUNT_STATUS      ACCT_STATUS, 
	A.CAD_STATUS_CODE_CURR     COLLECTION_STATUS_CD, 
	L.CCL_DESCRIPTION           COLLECTION_STATUS_DESC, 
    A.CAD_FIELD_COLLECTOR_ID   COLLECTOR_ID, 
  P.CAPH_PYMT_DATE           DATE_LAST_PMT, 
	P.CAPH_PYMT_AMT             AMT_LAST_PMT, 
	R.CRS_SCORE                COLL_CO_SCORE, 
	A.CAD_SEVERITY_CODE        COLL_Severity_code, 
	A.CAD_CURRENT_AGE          current_age 
FROM 
    CCS_ACCOUNT_DETAIL A , 
    CCS_ACCOUNT_SERVICE_AGREEMENT B, 
	CCS_ACCOUNT_PAYMENT_HISTORY P, 
	CCS_RMI_SCORE R, 
	CCS_CODE_LOOKUP L 
WHERE  A.CAD_IDENTIFIER = B.CASA_CAD_ID 
AND    A.CAD_IDENTIFIER = P.CAPH_CAD_ID (+) 
AND    (P.CAPH_IDENTIFIER IN 
                                (SELECT MAX(CAPH_IDENTIFIER ) 
                           FROM   CCS_ACCOUNT_PAYMENT_HISTORY P2 
                             WHERE   P.CAPH_CAD_ID= P2.CAPH_CAD_ID)
                OR
                NOT EXISTS                                 (SELECT CAPH_IDENTIFIER  
                            FROM   CCS_ACCOUNT_PAYMENT_HISTORY P2 
                             WHERE   P.CAPH_CAD_ID= P2.CAPH_CAD_ID)
      )
AND    A.CAD_IDENTIFIER = R.CRS_CAD_ID(+)
AND    R.CRS_MODEL(+) = 'CO' 
AND    L.CCL_TYPE = 'STATUS_CODE' 
AND    L.CCL_CODE = A.CAD_STATUS_CODE_CURR 
--AND    A.CAD_ENERGY_TYPE IN ('G', 'B') 
--AND    A.CAD_CURRENT_AGE IN ('30','60', '90', '90+') 
AND    A.CAD_BILLING_SYSTEM = 'CSB' 
--AND    A.CAD_ACCOUNT_TYPE = 'COM' 
--AND    A.CAD_ACCOUNT_STATUS = 'ACTIVE' 
GROUP BY 
A.CAD_ACCOUNT_NUMBER , 
    A.CAD_METER_LOCATION , 
    A.CAD_ENERGY_TYPE , 
    A.CAD_ACCOUNT_TYPE, 
    A.CAD_ACCOUNT_STATUS, 
    A.CAD_STATUS_CODE_CURR     , 
    A.CAD_FIELD_COLLECTOR_ID   , 
   P.CAPH_PYMT_DATE           , 
    P.CAPH_PYMT_AMT             , 
    R.CRS_SCORE                , 
    A.CAD_SEVERITY_CODE        , 
    A.CAD_TOTAL_ENERGY_ARR, 
    L.CCL_DESCRIPTION, 
    cad_current_age