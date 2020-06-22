select 'AcctNo','Name','EGB','LI','STCODE','Res','MTRloc','TARR','TNONARR','Status','BDD','Score','Segment','RandomNo','Curr','30','60','90','O90',
       'fDt fShutO','RBal','RStrat','RLevel','     DtRan',999 as Sequence1 from dual
union
select /*+ ORDERED FIRST_ROWS PARALLEL(AD, 12) PARALLEL(RMI, 12) PARALLEL_INDEX(AG, CASA_CAD_FK_I, 12)  */ distinct
to_char(AD.CAD_ACCOUNT_NUMBER), 
to_char(AD.CAD_CUSTOMER_NAME) , 
to_char(AD.CAD_ENERGY_TYPE) , 
max(DECODE(dbms_lob.instr(cad_account_xmlstring, '<profileCode>LI<',1,1),0,'N','Y')),
to_char(AD.CAD_STATUS_CODE_CURR) , 
to_char(decode(AD . CAD_ACCOUNT_TYPE,'RES','Y','N')), 
to_char(AD.CAD_METER_LOCATION) , 
to_char(max(AD.CAD_TOTAL_ENERGY_ARR)) ,
to_char(max(AD.CAD_TOTAL_NONENERGY_ARR)) , 
to_char(AD.CAD_ACCOUNT_STATUS)  , 
to_char(trunc(AD.CAD_BILL_DUE_DATE)),
to_char(RMI.CRS_SCORE) , 
to_char(RMI.CRS_SEGMENT) , 
to_char(RMI.CRS_RANDOM_NUM),
to_char(sum(INVL1.CURR)) , 
to_char(sum(INVL1.Thirty_buc)) , 
to_char(sum(INVL1.Sixty_buc)) , 
to_char(sum(INVL1.Ninety_buc)) , 
to_char(sum(INVL1.ONienty_buc)),
to_char(INLV2.Process_date),
to_char(SUBSTR(RMI.CRS_SEGMENT,3,1)), 
to_char(SUBSTR(RMI.CRS_SEGMENT,10,1)),
to_char(SUBSTR(RMI.CRS_SEGMENT,15)),
to_char(sysdate),
1 as Sequence1
FROM ccs_account_detail AD , 
     CCS_RMI_SCORE RMI,
     ccs_account_service_agreement INVL1,
     (Select /*+ PARALLEL(FCH, 12) */ fch.cfch_cad_id cad_id,
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