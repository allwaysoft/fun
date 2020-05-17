select 'AcctNo','Name','EGB','LI','STCODE','Res','MTRloc','TARR','TNONARR','Status','BDD','Score','Segment','RandomNo','Curr','30','60','90','O90',
       'fDt fShutO','RBal','RStrat','RLevel','     DtRan',999 as Sequence1 from dual
union
select /*+ FIRST_ROWS PARALLEL(AD, 12) PARALLEL(RMI, 12) PARALLEL(AG, 12) PARALLEL(FCH, 12) */ distinct
to_char(AD.CAD_ACCOUNT_NUMBER) "Acctno" , 
to_char(AD.CAD_CUSTOMER_NAME) "Name" , 
to_char(AD.CAD_ENERGY_TYPE) "EGB" , 
DECODE (dbms_lob.instr(cad_account_xmlstring, '<profileCode>LI<',1,1),0,'N','Y'),
to_char(AD.CAD_STATUS_CODE_CURR) "STCODE" , 
to_char(decode(AD . CAD_ACCOUNT_TYPE,'RES','Y','N'))  "Res" , 
to_char(AD.CAD_METER_LOCATION) "MTRloc" , 
to_char(AD.CAD_TOTAL_ENERGY_ARR) "TARR" ,
to_char(AD.CAD_TOTAL_NONENERGY_ARR) "TNONARR", 
to_char(AD.CAD_ACCOUNT_STATUS)  "Status" , 
to_char(trunc(AD.CAD_BILL_DUE_DATE)) "BDD",
to_char(RMI.CRS_SCORE) "Score", 
to_char(RMI.CRS_SEGMENT) "Segment", 
to_char(RMI.CRS_RANDOM_NUM) "RandomNo",
to_char(INVL1.CURR) , 
to_char(INVL1.Thirty_buc) , 
to_char(INVL1.Sixty_buc) , 
to_char(INVL1.Ninety_buc) , 
to_char(INVL1.ONienty_buc),
to_char(INLV2.Process_date),
to_char(SUBSTR(RMI.CRS_SEGMENT,3,1)), 
to_char(SUBSTR(RMI.CRS_SEGMENT,10,1)),
to_char(SUBSTR(RMI.CRS_SEGMENT,15)),
to_char(sysdate) DtRan,
1 as Sequence1
FROM ccs_account_detail AD , 
     CCS_RMI_SCORE RMI,
  (select AG.CASA_CAD_ID cad_id,
        SUM (AG.CASA_CURRENT_BALANCE ) CURR , 
        SUM (AG.CASA_THIRTY_BUCKET ) Thirty_buc , 
        SUM (AG.CASA_SIXTY_BUCKET ) Sixty_buc , 
        SUM (AG.CASA_NINETY_BUCKET ) Ninety_buc , 
        SUM (AG.CASA_OVER_NINETY_BUCKET ) ONienty_buc 
     from ccs_account_service_agreement AG 
       group by AG.CASA_CAD_ID) INVL1,
     (Select fch.cfch_cad_id cad_id,
             MAX(FCH.CFCH_PROCESS_DATE ) Process_date  
        from CCS_FIELD_CUT_HISTORY FCH 
          group by fch.cfch_cad_id ) INLV2  
where AD.CAD_IDENTIFIER = INVL1.CAD_ID(+)
  and AD.CAD_IDENTIFIER = RMI.CRS_CAD_ID(+)
  and AD.CAD_IDENTIFIER = INLV2.CAD_ID(+)
  and AD.CAD_ACCOUNT_STATUS = 'ACTIVE'
  and (RMI.CRS_MODEL = 'CO' or RMI.CRS_MODEL is null )
  and (AD.CAD_TOTAL_ENERGY_ARR<>0 or AD.CAD_TOTAL_NONENERGY_ARR<>0 
         or INVL1.CURR<>0 or INVL1.Thirty_buc <>0 or INVL1.Sixty_buc <>0 
            or INVL1 . Ninety_buc <>0 or INVL1.ONienty_buc<>0)
            order by Sequence1 desc